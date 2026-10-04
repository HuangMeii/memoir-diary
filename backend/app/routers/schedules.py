"""Schedule (timetable) item CRUD endpoints."""

import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import ScheduleItem, User
from app.schemas.misc import ScheduleCreate, ScheduleOut, ScheduleUpdate

router = APIRouter(prefix="/schedule-items", tags=["schedule"])


def _get_owned(db: Session, user: User, item_id: uuid.UUID) -> ScheduleItem:
    item = db.get(ScheduleItem, item_id)
    if item is None or item.user_id != user.id:
        raise HTTPException(status_code=404, detail="Schedule item not found")
    return item


@router.get("", response_model=list[ScheduleOut])
def list_items(
    date_from: datetime | None = Query(None, alias="from"),
    date_to: datetime | None = Query(None, alias="to"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(ScheduleItem).where(ScheduleItem.user_id == current_user.id)
    if date_from:
        stmt = stmt.where(ScheduleItem.start_at >= date_from)
    if date_to:
        stmt = stmt.where(ScheduleItem.start_at <= date_to)
    stmt = stmt.order_by(ScheduleItem.start_at)
    return db.execute(stmt).scalars().all()


@router.post("", response_model=ScheduleOut, status_code=status.HTTP_201_CREATED)
def create_item(
    payload: ScheduleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    item = ScheduleItem(user_id=current_user.id, **payload.model_dump())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


@router.put("/{item_id}", response_model=ScheduleOut)
def update_item(
    item_id: uuid.UUID,
    payload: ScheduleUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    item = _get_owned(db, current_user, item_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(item, field, value)
    db.commit()
    db.refresh(item)
    return item


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_item(
    item_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    item = _get_owned(db, current_user, item_id)
    db.delete(item)
    db.commit()
