"""Diary entry and image schemas."""

import uuid
from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field


class EntryBase(BaseModel):
    entry_date: date
    mood_id: int | None = None
    weather_id: int | None = None
    diary_text: str | None = None
    other_perspective: str | None = None
    future_message: str | None = None
    self_care: str | None = None
    tomorrow_hope: str | None = None
    gratitude: str | None = None
    dream: str | None = None


class EntryCreate(EntryBase):
    pass


class EntryUpdate(BaseModel):
    entry_date: date | None = None
    mood_id: int | None = None
    weather_id: int | None = None
    diary_text: str | None = None
    other_perspective: str | None = None
    future_message: str | None = None
    self_care: str | None = None
    tomorrow_hope: str | None = None
    gratitude: str | None = None
    dream: str | None = None


class ImageOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    entry_id: uuid.UUID
    object_key: str
    url: str | None = None
    content_type: str
    size_bytes: int | None = None
    width: int | None = None
    height: int | None = None
    caption: str | None = None
    created_at: datetime


class EntryOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    entry_date: date
    mood_id: int | None = None
    weather_id: int | None = None
    diary_text: str | None = None
    other_perspective: str | None = None
    future_message: str | None = None
    self_care: str | None = None
    tomorrow_hope: str | None = None
    gratitude: str | None = None
    dream: str | None = None
    created_at: datetime
    updated_at: datetime
    images: list[ImageOut] = Field(default_factory=list)
