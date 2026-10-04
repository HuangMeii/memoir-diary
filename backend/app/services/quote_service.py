"""Quote helpers: random selection for the daily pair."""

import uuid
from datetime import date

from sqlalchemy import func, or_, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.models import DailyQuote, Quote, SelfMessage


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


def get_or_create_daily_pair(
    db: Session, user_id: uuid.UUID, day: date
) -> DailyQuote:
    """Return the pair stored for [day], drawing one only if none exists yet.

    The fast path is a plain read, so the common case costs one SELECT and
    nothing else. The insert is still race-safe: two requests can pass that read
    together, and then the unique constraint decides the winner. Catching the
    IntegrityError keeps this portable -- `ON CONFLICT DO NOTHING` is
    Postgres-only, and `insert()` from SQLAlchemy core returns an ORM `Insert`
    that has no such method.
    """
    def _existing():
        return db.execute(
            select(DailyQuote).where(
                DailyQuote.user_id == user_id, DailyQuote.quote_date == day
            )
        ).scalars().first()

    stored = _existing()
    if stored is not None:
        return stored

    quote, self_message = random_pair(db, user_id)
    db.add(
        DailyQuote(
            user_id=user_id,
            quote_date=day,
            quote_id=quote.id if quote else None,
            self_message_id=self_message.id if self_message else None,
        )
    )
    try:
        db.commit()
    except IntegrityError:
        # Lost the race: the other request's row is the one that counts.
        db.rollback()

    # Re-read rather than trusting the local object: after a lost race the row
    # in the database is not the one just built here.
    return _existing()
