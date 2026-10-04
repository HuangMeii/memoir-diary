"""Lookup endpoints: moods and weathers (public reference data)."""

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models import Mood, Weather
from app.schemas.lookup import MoodOut, WeatherOut

router = APIRouter(tags=["lookups"])


@router.get("/moods", response_model=list[MoodOut])
def list_moods(db: Session = Depends(get_db)):
    return db.execute(select(Mood).order_by(Mood.sort_order)).scalars().all()


@router.get("/weathers", response_model=list[WeatherOut])
def list_weathers(db: Session = Depends(get_db)):
    return db.execute(select(Weather).order_by(Weather.sort_order)).scalars().all()
