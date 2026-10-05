"""Quote, self message, reflection and random-pair schemas."""

import uuid
from datetime import date, datetime

from pydantic import BaseModel, ConfigDict


class QuoteBase(BaseModel):
    text: str
    author: str | None = None
    source: str | None = None
    category: str | None = None
    is_active: bool = True


class QuoteCreate(QuoteBase):
    pass


class QuoteUpdate(BaseModel):
    text: str | None = None
    author: str | None = None
    source: str | None = None
    category: str | None = None
    is_active: bool | None = None


class QuoteOut(QuoteBase):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID | None = None
    created_at: datetime
    updated_at: datetime


class SelfMessageCreate(BaseModel):
    content: str
    entry_id: uuid.UUID | None = None


class SelfMessageUpdate(BaseModel):
    content: str | None = None


class SelfMessageOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    entry_id: uuid.UUID | None = None
    content: str
    created_at: datetime


class ReflectionCreate(BaseModel):
    """`entry_id` is optional: a thought can be written straight from the daily
    quote card, before the user has a diary entry for that day."""

    entry_id: uuid.UUID | None = None
    quote_id: uuid.UUID | None = None
    self_message_id: uuid.UUID | None = None
    thought: str | None = None


class ReflectionUpdate(BaseModel):
    entry_id: uuid.UUID | None = None
    quote_id: uuid.UUID | None = None
    self_message_id: uuid.UUID | None = None
    thought: str | None = None


class ReflectionOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    entry_id: uuid.UUID | None = None
    quote_id: uuid.UUID | None = None
    self_message_id: uuid.UUID | None = None
    thought: str | None = None
    created_at: datetime


class RandomPairOut(BaseModel):
    """An ad-hoc pair, not stored: `quote_2` is set only when two library
    quotes were drawn because the user has too few self messages to pair."""

    quote: QuoteOut | None = None
    quote_2: QuoteOut | None = None
    self_message: SelfMessageOut | None = None


class DailyQuoteOut(BaseModel):
    """A stored daily pair: the ids plus the rows they point at, if still there."""

    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    quote_date: date
    quote_id: uuid.UUID | None = None
    quote_id_2: uuid.UUID | None = None
    self_message_id: uuid.UUID | None = None
    created_at: datetime
    quote: QuoteOut | None = None
    quote_2: QuoteOut | None = None
    self_message: SelfMessageOut | None = None
