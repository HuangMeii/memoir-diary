"""Statistics helpers: month grids and summary."""

import uuid
from calendar import monthrange
from datetime import date

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.models import DiaryEntry, HealthLog, Mood, Weather
from app.schemas.stats import GridCell, StatsSummaryOut


def month_bounds(month: str) -> tuple[date, date]:
    year, mon = (int(p) for p in month.split("-"))
    first = date(year, mon, 1)
    last = date(year, mon, monthrange(year, mon)[1])
    return first, last


def _grid_rows(db: Session, user_id: uuid.UUID, month: str, lookup, fk_col):
    first, last = month_bounds(month)
    stmt = (
        select(
            DiaryEntry.entry_date,
            lookup.code,
            lookup.label_vi,
            lookup.color_hex,
        )
        .join(lookup, fk_col == lookup.id, isouter=True)
        .where(
            DiaryEntry.user_id == user_id,
            DiaryEntry.entry_date >= first,
            DiaryEntry.entry_date <= last,
        )
        .order_by(DiaryEntry.entry_date)
    )
    return [
        GridCell(date=row[0], code=row[1], label=row[2], color=row[3])
        for row in db.execute(stmt).all()
    ]


def mood_grid(db: Session, user_id: uuid.UUID, month: str) -> list[GridCell]:
    return _grid_rows(db, user_id, month, Mood, DiaryEntry.mood_id)


def weather_grid(db: Session, user_id: uuid.UUID, month: str) -> list[GridCell]:
    return _grid_rows(db, user_id, month, Weather, DiaryEntry.weather_id)


def summary(db: Session, user_id: uuid.UUID, month: str) -> StatsSummaryOut:
    first, last = month_bounds(month)

    entries = (
        db.execute(
            select(DiaryEntry.mood_id, DiaryEntry.weather_id).where(
                DiaryEntry.user_id == user_id,
                DiaryEntry.entry_date >= first,
                DiaryEntry.entry_date <= last,
            )
        )
        .all()
        .__len__()
    )

    mood_rows = db.execute(
        select(Mood.code, DiaryEntry.id)
        .join(Mood, DiaryEntry.mood_id == Mood.id)
        .where(
            DiaryEntry.user_id == user_id,
            DiaryEntry.entry_date >= first,
            DiaryEntry.entry_date <= last,
        )
    ).all()
    weather_rows = db.execute(
        select(Weather.code, DiaryEntry.id)
        .join(Weather, DiaryEntry.weather_id == Weather.id)
        .where(
            DiaryEntry.user_id == user_id,
            DiaryEntry.entry_date >= first,
            DiaryEntry.entry_date <= last,
        )
    ).all()

    mood_counts: dict[str, int] = {}
    for code, _ in mood_rows:
        mood_counts[code] = mood_counts.get(code, 0) + 1
    weather_counts: dict[str, int] = {}
    for code, _ in weather_rows:
        weather_counts[code] = weather_counts.get(code, 0) + 1

    health = db.execute(
        select(HealthLog.steps, HealthLog.workout_minutes).where(
            HealthLog.user_id == user_id,
            HealthLog.log_date >= first,
            HealthLog.log_date <= last,
        )
    ).all()
    total_steps = sum(s or 0 for s, _ in health)
    total_workout = sum(w or 0 for _, w in health)

    return StatsSummaryOut(
        month=month,
        days_logged=entries,
        mood_counts=mood_counts,
        weather_counts=weather_counts,
        total_steps=total_steps,
        total_workout_minutes=total_workout,
    )
