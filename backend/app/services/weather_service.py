"""Weather forecast from Open-Meteo.

Open-Meteo is free and needs no API key. The client never talks to it
directly: this module is the single place that maps WMO codes onto the five
`weathers` groups the app already ships, caches the answers, and keeps a
per-day history so the weather of a past day is still readable.
"""

import time
import uuid
from datetime import UTC, date, datetime

import httpx
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.config import settings
from app.models import User, Weather, WeatherSnapshot

#: WMO code -> `weathers.code`. Anything unlisted falls back to "other".
#: Ranges follow the WMO 4677 table as Open-Meteo documents it.
_WMO_GROUPS: dict[int, str] = {
    0: "sunny",
    1: "sunny",
    2: "cloudy",
    3: "cloudy",
    45: "cloudy",
    48: "cloudy",
    51: "rainy",
    53: "rainy",
    55: "rainy",
    56: "rainy",
    57: "rainy",
    61: "rainy",
    63: "rainy",
    65: "rainy",
    66: "rainy",
    67: "rainy",
    80: "rainy",
    81: "rainy",
    82: "rainy",
    95: "storm",
    96: "storm",
    99: "storm",
}

#: Vietnamese wording matching the seeded lookup labels.
_LABELS: dict[str, tuple[str, str]] = {
    "sunny": ("Trời quang", "☀️"),
    "cloudy": ("Có mây", "☁️"),
    "rainy": ("Mưa", "🌧️"),
    "storm": ("Bão", "⛈️"),
    "other": ("Khác", "❔"),
}


class WeatherUnavailable(RuntimeError):
    """No fresh data and nothing cached to fall back on."""


def group_for_code(code: int) -> str:
    return _WMO_GROUPS.get(code, "other")


def label_for_code(code: int) -> tuple[str, str]:
    return _LABELS.get(group_for_code(code), _LABELS["other"])


def _weather_ids(db: Session) -> dict[str, int]:
    """Map `weathers.code` -> id once per request instead of once per row."""
    return {row.code: row.id for row in db.execute(select(Weather)).scalars().all()}


def location_of(user: User) -> tuple[float, float, str]:
    """The user's saved coordinates, or the configured default."""
    lat = user.weather_lat if user.weather_lat is not None else settings.weather_default_lat
    lon = user.weather_lon if user.weather_lon is not None else settings.weather_default_lon
    name = user.weather_location_name or "Vị trí mặc định"
    return lat, lon, name


# --- in-memory cache -------------------------------------------------------
# Keyed by rounded coordinates so two people a few metres apart share an entry.
_memory: dict[tuple[float, float], tuple[float, dict]] = {}


def _cache_key(lat: float, lon: float) -> tuple[float, float]:
    return (round(lat, 2), round(lon, 2))


def _cached(lat: float, lon: float) -> dict | None:
    key = _cache_key(lat, lon)
    hit = _memory.get(key)
    if hit is None:
        return None
    stored_at, payload = hit
    if time.monotonic() - stored_at > settings.weather_cache_ttl_minutes * 60:
        _memory.pop(key, None)
        return None
    return payload


def _remember(lat: float, lon: float, payload: dict) -> None:
    _memory[_cache_key(lat, lon)] = (time.monotonic(), payload)


def clear_cache() -> None:
    """Drop the in-memory cache (used by tests)."""
    _memory.clear()


# --- upstream --------------------------------------------------------------
def _fetch(lat: float, lon: float) -> dict:
    params = {
        "latitude": lat,
        "longitude": lon,
        "current": "temperature_2m,weather_code",
        "daily": "weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum",
        "timezone": "auto",
        "forecast_days": settings.weather_forecast_days,
    }
    # A hard timeout matters more than the default here: this endpoint sits in
    # front of the home screen, so a slow upstream must not hold the request.
    with httpx.Client(timeout=settings.weather_timeout_seconds) as client:
        response = client.get(settings.weather_api_url, params=params)
        response.raise_for_status()
    return response.json()


def _daily_rows(raw: dict) -> list[dict]:
    """Flatten Open-Meteo's parallel arrays into one row per day."""
    daily = raw.get("daily") or {}
    dates = daily.get("time") or []
    codes = daily.get("weather_code") or []
    highs = daily.get("temperature_2m_max") or []
    lows = daily.get("temperature_2m_min") or []
    rain = daily.get("precipitation_sum") or []

    rows: list[dict] = []
    for index, day in enumerate(dates):
        try:
            parsed = date.fromisoformat(day)
        except (TypeError, ValueError):
            continue
        high = highs[index] if index < len(highs) else None
        low = lows[index] if index < len(lows) else None
        rows.append(
            {
                "date": parsed,
                "code": int(codes[index]) if index < len(codes) else 0,
                "temp_min": low,
                "temp_max": high,
                # Only average when both ends are present, otherwise the mean
                # would silently be whichever single value we happen to have.
                "temp_avg": (high + low) / 2 if high is not None and low is not None else None,
                "precipitation": rain[index] if index < len(rain) else None,
            }
        )
    return rows


def _save_snapshots(db: Session, user_id: uuid.UUID, rows: list[dict]) -> None:
    """Store the forecast per day so it stays readable later.

    Only writes days that have no snapshot yet: re-running a forecast must not
    overwrite a reading the user already saw.
    """
    existing = set(
        db.execute(
            select(WeatherSnapshot.forecast_date).where(
                WeatherSnapshot.user_id == user_id
            )
        ).scalars()
    )
    ids = _weather_ids(db)
    now = datetime.now(UTC)
    added = False
    for row in rows:
        if row["date"] in existing:
            continue
        db.add(
            WeatherSnapshot(
                user_id=user_id,
                forecast_date=row["date"],
                weather_code=row["code"],
                weather_id=ids.get(group_for_code(row["code"])),
                temp_min=row["temp_min"],
                temp_max=row["temp_max"],
                temp_avg=row["temp_avg"],
                precipitation_mm=row["precipitation"],
                fetched_at=now,
            )
        )
        added = True
    if added:
        db.commit()


def _shape_row(row: dict, ids: dict[str, int]) -> dict:
    label, icon = label_for_code(row["code"])
    return {
        "date": row["date"],
        "weather_code": row["code"],
        "condition": label,
        "icon": icon,
        "weather_id": ids.get(group_for_code(row["code"])),
        "temp_min": row["temp_min"],
        "temp_max": row["temp_max"],
    }


def _from_snapshot(row: WeatherSnapshot) -> dict:
    label, icon = label_for_code(row.weather_code)
    return {
        "date": row.forecast_date,
        "weather_code": row.weather_code,
        "condition": label,
        "icon": icon,
        "weather_id": row.weather_id,
        "temp_min": row.temp_min,
        "temp_max": row.temp_max,
    }
def current_weather(db: Session, user: User) -> dict:
    """Today's conditions plus the multi-day forecast.

    Falls back to the stored snapshots when Open-Meteo is slow or unreachable:
    a weather card is not worth failing a home screen over, and the reply says
    `source: "cache"` so the UI can show the reading is stale.
    """
    lat, lon, name = location_of(user)
    ids = _weather_ids(db)
    today = datetime.now(UTC).date()

    payload: dict | None = None
    source = "open-meteo"

    if settings.weather_api_enabled:
        cached = _cached(lat, lon)
        if cached is not None:
            payload, source = cached, "cache"
        else:
            try:
                raw = _fetch(lat, lon)
                rows = _daily_rows(raw)
                payload = {
                    "current": raw.get("current") or {},
                    "daily": [_shape_row(r, ids) for r in rows],
                }
                _remember(lat, lon, payload)
                _save_snapshots(db, user.id, rows)
            except (httpx.HTTPError, ValueError, KeyError, TypeError, AttributeError):
                # Deliberately broad: any failure upstream degrades to stored
                # history instead of surfacing as a 500.
                payload, source = None, "cache"

    if payload is None:
        stored = db.execute(
            select(WeatherSnapshot)
            .where(
                WeatherSnapshot.user_id == user.id,
                WeatherSnapshot.forecast_date <= today,
            )
            .order_by(WeatherSnapshot.forecast_date.desc())
            .limit(settings.weather_forecast_days)
        ).scalars().all()
        if not stored:
            raise WeatherUnavailable("Không lấy được dữ liệu thời tiết")
        payload = {
            "current": {
                "time": today.isoformat(),
                "temperature": stored[0].temp_avg,
                "weather_code": stored[0].weather_code,
            },
            # Reversed: that query is newest-first, the UI wants a forecast.
            "daily": [_from_snapshot(s) for s in reversed(stored)],
        }
        source = "cache"

    current = payload.get("current") or {}
    try:
        code = int(current.get("weather_code") or 0)
    except (TypeError, ValueError):
        code = 0
    label, icon = label_for_code(code)
    return {
        "location_name": name,
        "current": {
            "time": current.get("time"),
            "temperature": current.get("temperature"),
            "weather_code": code,
            "condition": label,
            "icon": icon,
        },
        "daily": payload.get("daily") or [],
        "source": source,
    }


def daily_weather(db: Session, user: User, day: date) -> dict | None:
    """One day from the stored snapshots. Never touches the network."""
    row = db.execute(
        select(WeatherSnapshot).where(
            WeatherSnapshot.user_id == user.id,
            WeatherSnapshot.forecast_date == day,
        )
    ).scalar_one_or_none()
    return _from_snapshot(row) if row else None


def history(db: Session, user: User, start: date, end: date) -> list[dict]:
    """Stored readings between two dates, oldest first. Offline by design."""
    rows = db.execute(
        select(WeatherSnapshot)
        .where(
            WeatherSnapshot.user_id == user.id,
            WeatherSnapshot.forecast_date >= start,
            WeatherSnapshot.forecast_date <= end,
        )
        .order_by(WeatherSnapshot.forecast_date)
    ).scalars().all()
    return [_from_snapshot(row) for row in rows]


def set_location(user: User, lat: float, lon: float, name: str | None) -> None:
    """Persist the user's coordinates.

    The in-memory cache is keyed by coordinates, so the old entry simply stops
    being looked up once the location changes.
    """
    user.weather_lat = lat
    user.weather_lon = lon
    user.weather_location_name = name