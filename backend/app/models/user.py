"""User account model (multi-user)."""

import uuid
from datetime import UTC, datetime

from sqlalchemy import Boolean, DateTime, Float, String
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.types import Uuid

from app.core.database import Base

# Roles are plain strings (not a DB enum) so adding one later is just a code
# change, not a migration.
ROLE_USER = "user"
ROLE_ADMIN = "admin"
ROLES = (ROLE_USER, ROLE_ADMIN)


def _utcnow() -> datetime:
    return datetime.now(UTC)


class User(Base):
    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(
        Uuid(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    email: Mapped[str] = mapped_column(String(255), unique=True, index=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, index=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    display_name: Mapped[str | None] = mapped_column(String(100), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True, nullable=False)
    # server_default keeps the migration safe for the rows that already exist.
    role: Mapped[str] = mapped_column(
        String(20), default=ROLE_USER, server_default=ROLE_USER, nullable=False, index=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_utcnow, nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_utcnow, onupdate=_utcnow, nullable=False
    )

    @property
    def is_admin(self) -> bool:
        return self.role == ROLE_ADMIN

    # --- Weather location ---
    # Nullable so an account that never sets one falls back to the configured
    # default rather than being forced to pick a city on first sign-up.
    weather_lat: Mapped[float | None] = mapped_column(Float, nullable=True)
    weather_lon: Mapped[float | None] = mapped_column(Float, nullable=True)
    weather_location_name: Mapped[str | None] = mapped_column(
        String(100), nullable=True
    )

    entries = relationship(
        "DiaryEntry", back_populates="user", cascade="all, delete-orphan"
    )
