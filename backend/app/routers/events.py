"""Special event CRUD endpoints."""

import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import Event, User
from app.schemas.misc import EventCreate, EventOut, EventUpdate

router = APIRouter(prefix="/events", tags=["events"])


def _get_owned(db: Session, user: User, event_id: uuid.UUID) -> Event:
    event = db.get(Event, event_id)
    if event is None or event.user_id != user.id:
        raise HTTPException(status_code=404, detail="Event not found")
    return event


@router.get("", response_model=list[EventOut])
def list_events(
    date_from: datetime | None = Query(None, alias="from"),
    date_to: datetime | None = Query(None, alias="to"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Event).where(Event.user_id == current_user.id)
    if date_from:
        stmt = stmt.where(Event.start_at >= date_from)
    if date_to:
        stmt = stmt.where(Event.start_at <= date_to)
    stmt = stmt.order_by(Event.start_at)
    return db.execute(stmt).scalars().all()


@router.post("", response_model=EventOut, status_code=status.HTTP_201_CREATED)
def create_event(
    payload: EventCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    event = Event(user_id=current_user.id, **payload.model_dump())
    db.add(event)
    db.commit()
    db.refresh(event)
    return event


@router.put("/{event_id}", response_model=EventOut)
def update_event(
    event_id: uuid.UUID,
    payload: EventUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    event = _get_owned(db, current_user, event_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(event, field, value)
    db.commit()
    db.refresh(event)
    return event


@router.delete("/{event_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_event(
    event_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    event = _get_owned(db, current_user, event_id)
    db.delete(event)
    db.commit()
