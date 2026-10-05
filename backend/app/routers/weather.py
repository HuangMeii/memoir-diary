"""Weather endpoints backed by Open-Meteo (no API key required)."""

from datetime import date, timedelta

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import User
from app.schemas.weather import (
    WeatherDayOut,
    WeatherForecastOut,
    WeatherHistoryOut,
    WeatherLocationIn,
)
from app.services import weather_service

router = APIRouter(prefix="/weather", tags=["weather"])


@router.get("/current", response_model=WeatherForecastOut)
def current(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Now plus the forecast, or the stored snapshot if Open-Meteo is down."""
    try:
        return weather_service.current_weather(db, current_user)
    except weather_service.WeatherUnavailable as exc:
        # 503 rather than 500: the client is expected to hide the card and
        # carry on, which is only reasonable if it is told the data is absent.
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE, detail=str(exc)
        ) from exc


@router.get("/daily", response_model=WeatherDayOut | None)
def daily(
    date_: date = Query(alias="date"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """One day from stored snapshots. Reads the database only, never upstream.

    Declared as `WeatherDayOut | None` rather than the full forecast model: this
    returns a single day, and answering with `None` for a day that was never
    forecast is the documented behaviour.
    """
    return weather_service.daily_weather(db, current_user, date_)


@router.get("/history", response_model=WeatherHistoryOut)
def history(
    date_from: date | None = Query(None, alias="from"),
    date_to: date | None = Query(None, alias="to"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Readings between two dates, oldest first. Defaults to the last 30 days."""
    end = date_to or date.today()
    start = date_from or (end - timedelta(days=29))
    return {"days": weather_service.history(db, current_user, start, end)}


@router.put("/location", response_model=WeatherLocationIn)
def set_location(
    payload: WeatherLocationIn,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """Save the coordinates used for this account's forecast."""
    weather_service.set_location(
        current_user, payload.lat, payload.lon, payload.name
    )
    db.commit()
    db.refresh(current_user)
    return payload