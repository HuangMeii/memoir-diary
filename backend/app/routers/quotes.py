"""Quote library CRUD + random selection + daily pair."""

import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import Quote, User
from app.schemas.quote import (
    QuoteCreate,
    QuoteOut,
    QuoteUpdate,
    RandomPairOut,
)
from app.services import quote_service

router = APIRouter(tags=["quotes"])


def _visible(user: User):
    return or_(Quote.user_id == user.id, Quote.user_id.is_(None))


def _get_manageable_quote(
    db: Session, user: User, quote_id: uuid.UUID
) -> Quote:
    quote = db.get(Quote, quote_id)
    if quote is None or quote.user_id not in (None, user.id):
        raise HTTPException(status_code=404, detail="Quote not found")
    return quote


@router.get("/quotes", response_model=list[QuoteOut])
def list_quotes(
    category: str | None = None,
    is_active: bool | None = None,
    page: int = Query(1, ge=1),
    size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Quote).where(_visible(current_user))
    if category:
        stmt = stmt.where(Quote.category == category)
    if is_active is not None:
        stmt = stmt.where(Quote.is_active == is_active)
    stmt = stmt.order_by(Quote.created_at.desc()).offset((page - 1) * size).limit(size)
    return db.execute(stmt).scalars().all()


@router.get("/quotes/random", response_model=QuoteOut)
def random_quote(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    quote = quote_service.random_quote(db, current_user.id)
    if quote is None:
        raise HTTPException(status_code=404, detail="No quotes available")
    return quote


@router.get("/random-pair", response_model=RandomPairOut)
def random_pair(
    entry_id: uuid.UUID | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    quote, self_message = quote_service.random_pair(db, current_user.id)
    return RandomPairOut(quote=quote, self_message=self_message)


@router.post("/quotes", response_model=QuoteOut, status_code=status.HTTP_201_CREATED)
def create_quote(
    payload: QuoteCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    quote = Quote(user_id=current_user.id, **payload.model_dump())
    db.add(quote)
    db.commit()
    db.refresh(quote)
    return quote


@router.get("/quotes/{quote_id}", response_model=QuoteOut)
def get_quote(
    quote_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    quote = db.get(Quote, quote_id)
    if quote is None or quote.user_id not in (None, current_user.id):
        raise HTTPException(status_code=404, detail="Quote not found")
    return quote


@router.put("/quotes/{quote_id}", response_model=QuoteOut)
def update_quote(
    quote_id: uuid.UUID,
    payload: QuoteUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    quote = _get_manageable_quote(db, current_user, quote_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(quote, field, value)
    db.commit()
    db.refresh(quote)
    return quote


@router.delete("/quotes/{quote_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_quote(
    quote_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    quote = _get_manageable_quote(db, current_user, quote_id)
    quote.is_active = False  # soft delete
    db.commit()
