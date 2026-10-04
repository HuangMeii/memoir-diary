"""Statistics schemas for month grids."""

from datetime import date

from pydantic import BaseModel


class GridCell(BaseModel):
    date: date
    code: str | None = None
    label: str | None = None
    color: str | None = None


class MoodGridOut(BaseModel):
    month: str
    cells: list[GridCell]


class WeatherGridOut(BaseModel):
    month: str
    cells: list[GridCell]


class StatsSummaryOut(BaseModel):
    month: str
    days_logged: int
    mood_counts: dict[str, int]
    weather_counts: dict[str, int]
    total_steps: int
    total_workout_minutes: int
