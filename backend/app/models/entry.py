"""Diary entry model (central entity)."""

import uuid
from datetime import UTC, date, datetime

from sqlalchemy import (
    Date,
    DateTime,
    ForeignKey,
    SmallInteger,
    Text,
    UniqueConstraint,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.types import Uuid

from app.core.database import Base


def _utcnow() -> datetime:
    return datetime.now(UTC)


class DiaryEntry(Base):
    __tablename__ = "diary_entries"
    __table_args__ = (
        UniqueConstraint("user_id", "entry_date", name="uq_entries_user_date"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        Uuid(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), index=True
    )
    entry_date: Mapped[date] = mapped_column(Date, index=True)
    mood_id: Mapped[int | None] = mapped_column(
        SmallInteger, ForeignKey("moods.id"), nullable=True
    )
    weather_id: Mapped[int | None] = mapped_column(
        SmallInteger, ForeignKey("weathers.id"), nullable=True
    )
    diary_text: Mapped[str | None] = mapped_column(Text, nullable=True)
    other_perspective: Mapped[str | None] = mapped_column(Text, nullable=True)
    future_message: Mapped[str | None] = mapped_column(Text, nullable=True)
    self_care: Mapped[str | None] = mapped_column(Text, nullable=True)
    tomorrow_hope: Mapped[str | None] = mapped_column(Text, nullable=True)
    gratitude: Mapped[str | None] = mapped_column(Text, nullable=True)
    dream: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_utcnow, nullable=False
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), default=_utcnow, onupdate=_utcnow, nullable=False
    )

    user = relationship("User", back_populates="entries")
    images = relationship(
        "EntryImage", back_populates="entry", cascade="all, delete-orphan"
    )
    reflections = relationship(
        "Reflection", back_populates="entry", cascade="all, delete-orphan"
    )
