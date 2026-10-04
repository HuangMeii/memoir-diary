"""Daily quote history: which pair was shown on which day."""

import uuid
from datetime import date, datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session, selectinload

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import DailyQuote, User
from app.schemas.quote import DailyQuoteOut
from app.services import quote_service

router = APIRouter(prefix="/daily-quotes", tags=["daily-quotes"])

#: Matches `today` on the server rather than trusting a client clock, so a phone
#: with a wrong timezone cannot request someone else's "today".
_LOADS = (selectinload(DailyQuote.quote), selectinload(DailyQuote.self_message))


def _load(stmt):
    return stmt.options(*_LOADS)


def _parse_month(month: str) -> tuple[date, date]:
    """Split a `YYYY-MM` string into [first day, first day of next month).

    The month number is checked explicitly: `date()` raises ValueError on 13,
    which FastAPI would surface as a 500 rather than a 422.
    """
    try:
        year, mon = (int(p) for p in month.split("-"))
        if not 1 <= mon <= 12:
            raise ValueError("month out of range")
        first = date(year, mon, 1)
    except ValueError:
        raise HTTPException(
            status_code=422, detail="month must look like YYYY-MM with month 01-12"
        ) from None
    # Adding 32 days then normalising lands on the first of the next month
    # without pulling in dateutil, and stays correct for 28/29/30/31-day months.
    nxt = first + timedelta(days=32)
    return first, date(nxt.year, nxt.month, 1)


@router.get("/today", response_model=DailyQuoteOut)
def daily_quote_today(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """The pair for today, drawing and storing one if this is the first call."""
    today = datetime.now().date()
    return quote_service.get_or_create_daily_pair(db, current_user.id, today)


@router.get("", response_model=list[DailyQuoteOut])
def list_daily_quotes(
    month: str | None = Query(None, pattern=r"^\d{4}-\d{2}$"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """History, newest first. [month] is `YYYY-MM`."""
    stmt = select(DailyQuote).where(DailyQuote.user_id == current_user.id)
    if month:
        first, last = _parse_month(month)
        stmt = stmt.where(DailyQuote.quote_date >= first, DailyQuote.quote_date < last)
    stmt = stmt.order_by(DailyQuote.quote_date.desc())
    return db.execute(_load(stmt)).scalars().all()


@router.delete("/{daily_quote_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_daily_quote(
    daily_quote_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    item = db.get(DailyQuote, daily_quote_id)
    if item is None or item.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Daily quote not found")
    db.delete(item)
    db.commit()