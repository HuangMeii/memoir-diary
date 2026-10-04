"""Statistics endpoints: month grids and summary."""

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import User
from app.schemas.stats import MoodGridOut, StatsSummaryOut, WeatherGridOut
from app.services import stats_service

router = APIRouter(prefix="/stats", tags=["stats"])


@router.get("/mood-grid", response_model=MoodGridOut)
def mood_grid(
    month: str = Query(..., description="YYYY-MM"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return MoodGridOut(
        month=month, cells=stats_service.mood_grid(db, current_user.id, month)
    )


@router.get("/weather-grid", response_model=WeatherGridOut)
def weather_grid(
    month: str = Query(..., description="YYYY-MM"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return WeatherGridOut(
        month=month, cells=stats_service.weather_grid(db, current_user.id, month)
    )


@router.get("/summary", response_model=StatsSummaryOut)
def summary(
    month: str = Query(..., description="YYYY-MM"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return stats_service.summary(db, current_user.id, month)
