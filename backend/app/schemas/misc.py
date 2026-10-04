"""Schemas for notes, todos, events, schedule items and health logs."""

import uuid
from datetime import date, datetime

from pydantic import BaseModel, ConfigDict


# --- Notes ---
class NoteCreate(BaseModel):
    content: str
    color: str | None = None
    is_pinned: bool = False


class NoteUpdate(BaseModel):
    content: str | None = None
    color: str | None = None
    is_pinned: bool | None = None


class NoteOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    content: str
    color: str | None = None
    is_pinned: bool
    created_at: datetime
    updated_at: datetime


# --- Todos ---
class TodoCreate(BaseModel):
    title: str
    notes: str | None = None
    due_date: date | None = None
    week_label: str | None = None
    priority: int = 2


class TodoUpdate(BaseModel):
    title: str | None = None
    notes: str | None = None
    due_date: date | None = None
    week_label: str | None = None
    priority: int | None = None
    is_done: bool | None = None


class TodoOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    title: str
    notes: str | None = None
    due_date: date | None = None
    week_label: str | None = None
    priority: int
    is_done: bool
    completed_at: datetime | None = None
    created_at: datetime


# --- Events ---
class EventCreate(BaseModel):
    title: str
    description: str | None = None
    start_at: datetime
    end_at: datetime | None = None
    location: str | None = None
    is_all_day: bool = False


class EventUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    start_at: datetime | None = None
    end_at: datetime | None = None
    location: str | None = None
    is_all_day: bool | None = None


class EventOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    title: str
    description: str | None = None
    start_at: datetime
    end_at: datetime | None = None
    location: str | None = None
    is_all_day: bool
    created_at: datetime


# --- Schedule items ---
class ScheduleCreate(BaseModel):
    title: str
    start_at: datetime
    end_at: datetime | None = None
    recurrence_rule: str | None = None
    reminder_minutes: int | None = None


class ScheduleUpdate(BaseModel):
    title: str | None = None
    start_at: datetime | None = None
    end_at: datetime | None = None
    recurrence_rule: str | None = None
    reminder_minutes: int | None = None


class ScheduleOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    title: str
    start_at: datetime
    end_at: datetime | None = None
    recurrence_rule: str | None = None
    reminder_minutes: int | None = None
    created_at: datetime


# --- Health logs ---
class HealthLogCreate(BaseModel):
    log_date: date
    steps: int | None = None
    workout_minutes: int | None = None
    water_ml: int | None = None
    sleep_hours: float | None = None
    weight_kg: float | None = None
    note: str | None = None


class HealthLogUpdate(BaseModel):
    steps: int | None = None
    workout_minutes: int | None = None
    water_ml: int | None = None
    sleep_hours: float | None = None
    weight_kg: float | None = None
    note: str | None = None


class HealthLogOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID
    log_date: date
    steps: int | None = None
    workout_minutes: int | None = None
    water_ml: int | None = None
    sleep_hours: float | None = None
    weight_kg: float | None = None
    note: str | None = None
    created_at: datetime
