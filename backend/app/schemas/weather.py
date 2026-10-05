"""Weather schemas: forecast, history and the saved location."""

from datetime import date

from pydantic import BaseModel, Field, field_validator


class WeatherLocationIn(BaseModel):
    lat: float = Field(ge=-90, le=90)
    lon: float = Field(ge=-180, le=180)
    name: str | None = Field(default=None, max_length=100)


class WeatherCurrentOut(BaseModel):
    time: str | None = None
    temperature: float | None = None
    weather_code: int
    condition: str
    icon: str


class WeatherDayOut(BaseModel):
    date: date
    weather_code: int
    condition: str
    icon: str
    weather_id: int | None = None
    temp_min: float | None = None
    temp_max: float | None = None


class WeatherForecastOut(BaseModel):
    location_name: str
    current: WeatherCurrentOut
    daily: list[WeatherDayOut]
    #: "open-meteo" for a live reading, "cache" when the upstream was
    #: unreachable and the response is a stored one.
    source: str


class WeatherHistoryOut(BaseModel):
    days: list[WeatherDayOut]