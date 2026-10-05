"""Admin endpoints: curate the shared quote library (kho câu) and manage users.

Everything here is gated by `require_admin`. System quotes are the ones with
`user_id IS NULL`; they are what the daily "câu động viên" is drawn from, so
only admins may edit them.
"""

import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import require_admin
from app.models import DiaryEntry, Quote, User
from app.models.user import ROLE_ADMIN
from app.schemas.admin import (
    AdminQuoteCreate,
    AdminQuoteOut,
    AdminQuoteUpdate,
    AdminStatsOut,
    AdminUserOut,
    AdminUserUpdate,
)
from app.schemas.quote import QuoteOut

router = APIRouter(prefix="/admin", tags=["admin"])


def _get_system_quote(db: Session, quote_id: uuid.UUID) -> Quote:
    quote = db.get(Quote, quote_id)
    if quote is None or quote.user_id is not None:
        raise HTTPException(status_code=404, detail="System quote not found")
    return quote


def _user_counts(db: Session, user: User) -> tuple[int, int]:
    quotes = db.execute(
        select(func.count(Quote.id)).where(Quote.user_id == user.id)
    ).scalar()
    entries = db.execute(
        select(func.count(DiaryEntry.id)).where(DiaryEntry.user_id == user.id)
    ).scalar()
    return quotes or 0, entries or 0
# --- Kho câu: system quotes (user_id IS NULL) ---
@router.get("/quotes", response_model=list[QuoteOut])
def list_system_quotes(
    category: str | None = None,
    is_active: bool | None = None,
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    """List the shared library only, never another user's private quotes."""
    stmt = select(Quote).where(Quote.user_id.is_(None))
    if category:
        stmt = stmt.where(Quote.category == category)
    if is_active is not None:
        stmt = stmt.where(Quote.is_active == is_active)
    stmt = stmt.order_by(Quote.created_at.desc()).offset((page - 1) * size).limit(size)
    return db.execute(stmt).scalars().all()


@router.post(
    "/quotes", response_model=AdminQuoteOut, status_code=status.HTTP_201_CREATED
)
def create_system_quote(
    payload: AdminQuoteCreate,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    quote = Quote(user_id=None, **payload.model_dump())
    db.add(quote)
    db.commit()
    db.refresh(quote)
    return quote


@router.put("/quotes/{quote_id}", response_model=AdminQuoteOut)
def update_system_quote(
    quote_id: uuid.UUID,
    payload: AdminQuoteUpdate,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    quote = _get_system_quote(db, quote_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(quote, field, value)
    db.commit()
    db.refresh(quote)
    return quote


@router.delete("/quotes/{quote_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_system_quote(
    quote_id: uuid.UUID,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    """Soft delete: daily-quote history points at this row, so keep it."""
    quote = _get_system_quote(db, quote_id)
    quote.is_active = False
    db.commit()


# --- User management ---
@router.get("/users", response_model=list[AdminUserOut])
def list_users(
    role: str | None = Query(default=None, pattern="^(user|admin)$"),
    is_active: bool | None = None,
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    stmt = select(User)
    if role:
        stmt = stmt.where(User.role == role)
    if is_active is not None:
        stmt = stmt.where(User.is_active == is_active)
    stmt = stmt.order_by(User.created_at.desc()).offset((page - 1) * size).limit(size)

    users = db.execute(stmt).scalars().all()
    out = []
    for user in users:
        q_count, e_count = _user_counts(db, user)
        out.append(
            AdminUserOut(
                id=user.id,
                email=user.email,
                username=user.username,
                display_name=user.display_name,
                is_active=user.is_active,
                role=user.role,
                created_at=user.created_at,
                updated_at=user.updated_at,
                quote_count=q_count,
                entry_count=e_count,
            )
        )
    return out


@router.patch("/users/{user_id}", response_model=AdminUserOut)
def update_user(
    user_id: uuid.UUID,
    payload: AdminUserUpdate,
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    target = db.get(User, user_id)
    if target is None:
        raise HTTPException(status_code=404, detail="User not found")

    # An admin locking itself out would be unrecoverable without a shell.
    if target.id == admin.id and payload.is_active is False:
        raise HTTPException(
            status_code=400, detail="You cannot deactivate your own account"
        )

    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(target, field, value)
    db.commit()
    db.refresh(target)

    q_count, e_count = _user_counts(db, target)
    return AdminUserOut(
        id=target.id,
        email=target.email,
        username=target.username,
        display_name=target.display_name,
        is_active=target.is_active,
        role=target.role,
        created_at=target.created_at,
        updated_at=target.updated_at,
        quote_count=q_count,
        entry_count=e_count,
    )


@router.get("/stats", response_model=AdminStatsOut)
def admin_stats(
    db: Session = Depends(get_db),
    admin: User = Depends(require_admin),
):
    total_users = db.execute(select(func.count(User.id))).scalar() or 0
    active_users = (
        db.execute(select(func.count(User.id)).where(User.is_active.is_(True))).scalar()
        or 0
    )
    admin_users = (
        db.execute(select(func.count(User.id)).where(User.role == ROLE_ADMIN)).scalar() or 0
    )
    total_quotes = db.execute(select(func.count(Quote.id))).scalar() or 0
    system_quotes = (
        db.execute(select(func.count(Quote.id)).where(Quote.user_id.is_(None))).scalar() or 0
    )
    total_entries = db.execute(select(func.count(DiaryEntry.id))).scalar() or 0

    return AdminStatsOut(
        total_users=total_users,
        active_users=active_users,
        admin_users=admin_users,
        total_quotes=total_quotes,
        system_quotes=system_quotes,
        user_quotes=total_quotes - system_quotes,
        total_entries=total_entries,
    )
    quote.is_active = False
    db.commit()