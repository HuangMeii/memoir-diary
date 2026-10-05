"""Admin schemas: kho câu (system quotes) + user management."""

import uuid
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field

from app.models.user import ROLES


class AdminQuoteCreate(BaseModel):
    """Create a system quote (user_id = NULL) shared by every account."""

    text: str
    author: str | None = None
    source: str | None = None
    category: str | None = None
    is_active: bool = True


class AdminQuoteUpdate(BaseModel):
    text: str | None = None
    author: str | None = None
    source: str | None = None
    category: str | None = None
    is_active: bool | None = None


class AdminQuoteOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    user_id: uuid.UUID | None = None
    text: str
    author: str | None = None
    source: str | None = None
    category: str | None = None
    is_active: bool
    created_at: datetime
    updated_at: datetime


class AdminUserUpdate(BaseModel):
    """Admin can toggle activity or promote/demote an account."""

    is_active: bool | None = None
    role: str | None = Field(default=None, pattern="^(user|admin)$")


class AdminUserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: uuid.UUID
    email: str
    username: str
    display_name: str | None = None
    is_active: bool
    role: str
    created_at: datetime
    updated_at: datetime
    quote_count: int = 0
    entry_count: int = 0


class AdminStatsOut(BaseModel):
    total_users: int
    active_users: int
    admin_users: int
    total_quotes: int
    system_quotes: int
    user_quotes: int
    total_entries: int