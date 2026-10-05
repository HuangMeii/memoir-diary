"""Quote helpers: random selection for the daily pair."""

import uuid
from datetime import date

from sqlalchemy import func, or_, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.models import DailyQuote, Quote, SelfMessage

# Below this many saved self messages the pairing has nothing interesting to
# work with, so the day shows two library quotes instead. The user keeps
# building the library and pairing switches on by itself later.
MIN_SELF_MESSAGES_TO_PAIR = 10


def _visible_quotes(user_id: uuid.UUID):
    return or_(Quote.user_id == user_id, Quote.user_id.is_(None))


def random_quote(
    db: Session, user_id: uuid.UUID, exclude: uuid.UUID | None = None
) -> Quote | None:
    stmt = select(Quote).where(
        Quote.is_active.is_(True),
        _visible_quotes(user_id),
    )
    if exclude is not None:
        stmt = stmt.where(Quote.id != exclude)
    stmt = stmt.order_by(func.random()).limit(1)
    return db.execute(stmt).scalars().first()


def random_self_message(db: Session, user_id: uuid.UUID) -> SelfMessage | None:
    stmt = (
        select(SelfMessage)
        .where(SelfMessage.user_id == user_id)
        .order_by(func.random())
        .limit(1)
    )
    return db.execute(stmt).scalars().first()


def self_message_count(db: Session, user_id: uuid.UUID) -> int:
    """How many self messages the user has saved, used to decide the pairing."""
    return (
        db.execute(
            select(func.count(SelfMessage.id)).where(SelfMessage.user_id == user_id)
        ).scalar()
        or 0
    )


def random_pair(
    db: Session, user_id: uuid.UUID
) -> tuple[Quote | None, Quote | None, SelfMessage | None]:
    """Draw what to show today: (first quote, second quote, self message).

    Enough self messages -> one library quote next to one of the user's own,
    which is the intended pairing. Too few -> two different library quotes,
    so the day is never half empty.
    """
    if self_message_count(db, user_id) >= MIN_SELF_MESSAGES_TO_PAIR:
        quote = random_quote(db, user_id)
        return quote, None, random_self_message(db, user_id)

    quote = random_quote(db, user_id)
    if quote is None:
        return None, None, random_self_message(db, user_id)
    # Excluding the first id guarantees the two quotes differ.
    return quote, random_quote(db, user_id, exclude=quote.id), None


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

    quote, quote_2, self_message = random_pair(db, user_id)
    db.add(
        DailyQuote(
            user_id=user_id,
            quote_date=day,
            quote_id=quote.id if quote else None,
            quote_id_2=quote_2.id if quote_2 else None,
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
