"""Reflection CRUD endpoints (thoughts about the daily quote pair)."""

import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import DiaryEntry, Reflection, User
from app.schemas.quote import ReflectionCreate, ReflectionOut, ReflectionUpdate

router = APIRouter(prefix="/reflections", tags=["reflections"])


def _get_owned(db: Session, user: User, reflection_id: uuid.UUID) -> Reflection:
    item = db.get(Reflection, reflection_id)
    if item is None or item.user_id != user.id:
        raise HTTPException(status_code=404, detail="Reflection not found")
    return item


@router.get("", response_model=list[ReflectionOut])
def list_reflections(
    entry_id: uuid.UUID | None = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Reflection).where(Reflection.user_id == current_user.id)
    if entry_id:
        stmt = stmt.where(Reflection.entry_id == entry_id)
    stmt = stmt.order_by(Reflection.created_at.desc())
    return db.execute(stmt).scalars().all()


@router.post("", response_model=ReflectionOut, status_code=status.HTTP_201_CREATED)
def create_reflection(
    payload: ReflectionCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    entry = db.get(DiaryEntry, payload.entry_id)
    if entry is None or entry.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Entry not found")
    item = Reflection(user_id=current_user.id, **payload.model_dump())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


@router.put("/{reflection_id}", response_model=ReflectionOut)
def update_reflection(
    reflection_id: uuid.UUID,
    payload: ReflectionUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    item = _get_owned(db, current_user, reflection_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    return item


@router.delete("/{reflection_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_reflection(
    reflection_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    item = _get_owned(db, current_user, reflection_id)
    db.delete(item)
    db.commit()
