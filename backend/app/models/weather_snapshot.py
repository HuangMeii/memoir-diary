"""Per-day weather snapshots, so the forecast survives restarts and outages.

Open-Meteo only forecasts forward, so without this the weather of a past day
would be lost as soon as the API window moved on.
"""

import uuid
from datetime import UTC, date, datetime

from sqlalchemy import Date, DateTime, Float, ForeignKey, SmallInteger, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column
from sqlalchemy.types import Uuid

from app.core.database import Base


def _utcnow() -> datetime:
    return datetime.now(UTC)


class WeatherSnapshot(Base):
    __tablename__ = "weather_snapshots"
    __table_args__ = (
        UniqueConstraint("user_id", "forecast_date", name="uq_weather_user_date"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        Uuid(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    forecast_date: Mapped[date] = mapped_column(Date, index=True)
    #: The raw WMO code from the API. Kept alongside `weather_id` so the
    #: grouping can be changed later without losing the original reading.
    weather_code: Mapped[int] = mapped_column(SmallInteger)
    #: The matching row in the `weathers` lookup (one of the five groups).
    weather_id: Mapped[int | None] = mapped_column(
        SmallInteger, ForeignKey("weathers.id", ondelete="SET NULL"), nullable=True
    )
    temp_min: Mapped[float | None] = mapped_column(Float, nullable=True)
    temp_max: Mapped[float | None] = mapped_column(Float, nullable=True)
    temp_avg: Mapped[float | None] = mapped_column(Float, nullable=True)
    precipitation_mm: Mapped[float | None] = mapped_column(Float, nullable=True)
    fetched_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_utcnow, nullable=False
    )