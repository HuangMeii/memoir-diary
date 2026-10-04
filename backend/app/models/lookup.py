"""Lookup tables: moods and weathers."""

from sqlalchemy import SmallInteger, String
from sqlalchemy.orm import Mapped, mapped_column

from app.core.database import Base


class Mood(Base):
    __tablename__ = "moods"

    id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    code: Mapped[str] = mapped_column(String(20), unique=True)
    label_vi: Mapped[str] = mapped_column(String(50))
    color_hex: Mapped[str] = mapped_column(String(7))
    icon: Mapped[str] = mapped_column(String(20))
    sort_order: Mapped[int] = mapped_column(SmallInteger, default=0)


class Weather(Base):
    __tablename__ = "weathers"

    id: Mapped[int] = mapped_column(SmallInteger, primary_key=True)
    code: Mapped[str] = mapped_column(String(20), unique=True)
    label_vi: Mapped[str] = mapped_column(String(50))
    color_hex: Mapped[str] = mapped_column(String(7))
    icon: Mapped[str] = mapped_column(String(20))
    sort_order: Mapped[int] = mapped_column(SmallInteger, default=0)
