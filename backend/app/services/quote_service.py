"""Quote helpers: random selection for the daily pair."""

import uuid

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from app.models import Quote, SelfMessage


def random_quote(db: Session, user_id: uuid.UUID) -> Quote | None:
    stmt = (
        select(Quote)
        .where(
            Quote.is_active.is_(True),
            or_(Quote.user_id == user_id, Quote.user_id.is_(None)),
        )
        .order_by(func.random())
        .limit(1)
    )
    return db.execute(stmt).scalars().first()


def random_self_message(db: Session, user_id: uuid.UUID) -> SelfMessage | None:
    stmt = (
        select(SelfMessage)
        .where(SelfMessage.user_id == user_id)
        .order_by(func.random())
        .limit(1)
    )
    return db.execute(stmt).scalars().first()


def random_pair(
    db: Session, user_id: uuid.UUID
) -> tuple[Quote | None, SelfMessage | None]:
    return random_quote(db, user_id), random_self_message(db, user_id)
