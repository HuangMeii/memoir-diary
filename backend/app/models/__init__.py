"""ORM models. Importing this package registers every table on Base.metadata."""

from app.models.event import Event
from app.models.health import HealthLog
from app.models.image import EntryImage
from app.models.lookup import Mood, Weather
from app.models.note import Note
from app.models.quote import DailyQuote, Quote, Reflection, SelfMessage
from app.models.schedule import ScheduleItem
from app.models.todo import Todo
from app.models.user import User
from app.models.entry import DiaryEntry
from app.models.weather_snapshot import WeatherSnapshot

__all__ = [
    "User",
    "Mood",
    "Weather",
    "DiaryEntry",
    "EntryImage",
    "Quote",
    "SelfMessage",
    "Reflection",
    "DailyQuote",
    "Note",
    "Todo",
    "Event",
    "ScheduleItem",
    "HealthLog",
    "WeatherSnapshot",
]
