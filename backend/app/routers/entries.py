"""Diary entry CRUD endpoints."""

import uuid
from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import DiaryEntry, User
from app.schemas.entry import EntryCreate, EntryOut, EntryUpdate
from app.services.stats_service import month_bounds

router = APIRouter(prefix="/entries", tags=["entries"])


def _get_owned_entry(
    db: Session, user: User, entry_id: uuid.UUID
) -> DiaryEntry:
    entry = db.get(DiaryEntry, entry_id)
    if entry is None or entry.user_id != user.id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entry not found")
    return entry


@router.get("", response_model=list[EntryOut])
def list_entries(
    month: str | None = Query(None, description="YYYY-MM"),
    date_from: date | None = Query(None, alias="from"),
    date_to: date | None = Query(None, alias="to"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(DiaryEntry).where(DiaryEntry.user_id == current_user.id)
    if month:
        first, last = month_bounds(month)
        stmt = stmt.where(
            DiaryEntry.entry_date >= first, DiaryEntry.entry_date <= last
        )
    if date_from:
        stmt = stmt.where(DiaryEntry.entry_date >= date_from)
    if date_to:
        stmt = stmt.where(DiaryEntry.entry_date <= date_to)
    stmt = stmt.order_by(DiaryEntry.entry_date.desc())
    return db.execute(stmt).scalars().all()


@router.get("/by-date/{entry_date}", response_model=EntryOut)
def get_entry_by_date(
    entry_date: date,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entry = db.execute(
        select(DiaryEntry).where(
            DiaryEntry.user_id == current_user.id,
            DiaryEntry.entry_date == entry_date,
        )
    ).scalars().first()
    if entry is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entry not found")
    return entry


@router.get("/{entry_id}", response_model=EntryOut)
def get_entry(
    entry_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return _get_owned_entry(db, current_user, entry_id)


@router.post("", response_model=EntryOut, status_code=status.HTTP_201_CREATED)
def create_entry(
    payload: EntryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entry = DiaryEntry(user_id=current_user.id, **payload.model_dump())
    db.add(entry)
    try:
        db.commit()
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="An entry for this date already exists",
        ) from None
    db.refresh(entry)
    return entry


@router.put("/{entry_id}", response_model=EntryOut)
def update_entry(
    entry_id: uuid.UUID,
    payload: EntryUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entry = _get_owned_entry(db, current_user, entry_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(entry, field, value)
    db.commit()
    db.refresh(entry)
    return entry


@router.delete("/{entry_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_entry(
    entry_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entry = _get_owned_entry(db, current_user, entry_id)
    db.delete(entry)
    db.commit()
