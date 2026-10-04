"""Lookup schemas (moods, weathers)."""

from pydantic import BaseModel, ConfigDict


class LookupOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    code: str
    label_vi: str
    color_hex: str
    icon: str
    sort_order: int


class MoodOut(LookupOut):
    pass


class WeatherOut(LookupOut):
    pass
