"""Self message CRUD endpoints (user's own messages to self)."""

import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import SelfMessage, User
from app.schemas.quote import (
    SelfMessageCreate,
    SelfMessageOut,
    SelfMessageUpdate,
)

router = APIRouter(prefix="/self-messages", tags=["self-messages"])


def _get_owned(db: Session, user: User, message_id: uuid.UUID) -> SelfMessage:
    message = db.get(SelfMessage, message_id)
    if message is None or message.user_id != user.id:
        raise HTTPException(status_code=404, detail="Self message not found")
    return message


@router.get("", response_model=list[SelfMessageOut])
def list_self_messages(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = (
        select(SelfMessage)
        .where(SelfMessage.user_id == current_user.id)
        .order_by(SelfMessage.created_at.desc())
    )
    return db.execute(stmt).scalars().all()


@router.post("", response_model=SelfMessageOut, status_code=status.HTTP_201_CREATED)
def create_self_message(
    payload: SelfMessageCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    message = SelfMessage(user_id=current_user.id, **payload.model_dump())
    db.add(message)
    db.commit()
    db.refresh(message)
    return message


@router.put("/{message_id}", response_model=SelfMessageOut)
def update_self_message(
    message_id: uuid.UUID,
    payload: SelfMessageUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    message = _get_owned(db, current_user, message_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(message, field, value)
    db.commit()
    db.refresh(message)
    return message


@router.delete("/{message_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_self_message(
    message_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    message = _get_owned(db, current_user, message_id)
    db.delete(message)
    db.commit()
