"""Tests for the Open-Meteo weather endpoints.

The upstream call is stubbed everywhere: what matters here is the mapping, the
caching and the fallback, and the suite must not depend on the network.
"""

import uuid
from datetime import date, timedelta

import httpx
import pytest
from fastapi.testclient import TestClient

from app.core.database import SessionLocal
from app.main import app
from app.models import WeatherSnapshot
from app.services import weather_service

client = TestClient(app)

API = "/api/v1"


def _register() -> dict:
    suffix = uuid.uuid4().hex[:10]
    email = f"weather_{suffix}@example.com"
    resp = client.post(
        f"{API}/auth/register",
        json={"email": email, "username": f"w{suffix}", "password": "secret123"},
    )
    assert resp.status_code == 201, resp.text
    body = resp.json()
    return {
        "headers": {"Authorization": f"Bearer {body['access_token']}"},
        "id": body["id"],
    }


def _upstream() -> dict:
    """A trimmed Open-Meteo reply with the same parallel-array shape."""
    return {
        "current": {"time": "2026-10-05T18:15", "temperature": 24.4, "weather_code": 0},
        "daily": {
            "time": ["2026-10-05", "2026-10-06", "2026-10-07"],
            "weather_code": [0, 61, 95],
            "temperature_2m_max": [25.9, 27.5, 28.9],
            "temperature_2m_min": [22.3, 21.0, 19.5],
            "precipitation_sum": [0.0, 4.2, 0.0],
        },
    }


@pytest.fixture(autouse=True)
def _clear_cache():
    weather_service.clear_cache()
    yield
    weather_service.clear_cache()


def _snapshots_for(user_id: str) -> list[WeatherSnapshot]:
    with SessionLocal() as db:
        return (
            db.query(WeatherSnapshot)
            .filter(WeatherSnapshot.user_id == uuid.UUID(user_id))
            .all()
        )


# --- WMO grouping ---
@pytest.mark.parametrize(
    ("code", "expected"),
    [
        (0, "sunny"),
        (1, "sunny"),
        (3, "cloudy"),
        (45, "cloudy"),
        (61, "rainy"),
        (82, "rainy"),
        (95, "storm"),
        (99, "storm"),
        (71, "other"),  # snow
        (999, "other"),  # unlisted -> fallback
    ],
)
def test_wmo_codes_map_to_the_five_groups(code, expected):
    assert weather_service.group_for_code(code) == expected


def test_every_group_has_a_label_and_icon():
    for group in ("sunny", "cloudy", "rainy", "storm", "other"):
        code = next(c for c in range(100) if weather_service.group_for_code(c) == group)
        label, icon = weather_service.label_for_code(code)
        assert label and icon


# --- Current weather ---
def test_current_weather_labels_each_day(monkeypatch):
    monkeypatch.setattr(weather_service, "_fetch", lambda lat, lon: _upstream())
    headers = _register()["headers"]

    resp = client.get(f"{API}/weather/current", headers=headers)
    assert resp.status_code == 200, resp.text
    body = resp.json()

    assert body["source"] == "open-meteo"
    assert body["current"]["temperature"] == 24.4
    assert body["current"]["condition"] == "Trời quang"
    assert body["current"]["icon"] == "☀️"
    assert len(body["daily"]) == 3
    # Rain and storm get their own wording rather than a raw number.
    assert body["daily"][1]["condition"] == "Mưa"
    assert body["daily"][2]["condition"] == "Bão"


def test_current_weather_saves_a_snapshot_per_day(monkeypatch):
    monkeypatch.setattr(weather_service, "_fetch", lambda lat, lon: _upstream())
    account = _register()
    client.get(f"{API}/weather/current", headers=account["headers"])

    rows = _snapshots_for(account["id"])
    assert len(rows) == 3
    assert all(r.weather_code is not None for r in rows)


def test_refetch_does_not_overwrite_a_stored_reading(monkeypatch):
    monkeypatch.setattr(weather_service, "_fetch", lambda lat, lon: _upstream())
    account = _register()
    headers = account["headers"]

    client.get(f"{API}/weather/current", headers=headers)
    weather_service.clear_cache()
    client.get(f"{API}/weather/current", headers=headers)

    # Still three rows, not six: a re-run must not rewrite what the user saw.
    assert len(_snapshots_for(account["id"])) == 3


def test_fetch_returns_the_decoded_body(monkeypatch):
    """_fetch must hand back the parsed JSON, not None.

    The tests above stub _fetch out entirely, so without this one a _fetch that
    forgot its `return` would pass the suite and only fail in production - which
    is exactly what happened: every other test stayed green while
    /weather/current returned 500 against the real API.
    """
    captured: dict = {}

    class _FakeResponse:
        def raise_for_status(self) -> None:
            return None

        def json(self) -> dict:
            return _upstream()

    class _FakeClient:
        def __init__(self, timeout: float) -> None:
            captured["timeout"] = timeout

        def __enter__(self):
            return self

        def __exit__(self, *exc: object) -> None:
            return None

        def get(self, url: str, params: dict) -> _FakeResponse:
            captured["url"] = url
            captured["params"] = params
            return _FakeResponse()

    monkeypatch.setattr(weather_service.httpx, "Client", _FakeClient)

    result = weather_service._fetch(21.0285, 105.8542)

    assert result == _upstream()
    assert captured["params"]["latitude"] == 21.0285
    assert captured["params"]["forecast_days"] == 7


def test_daily_returns_a_single_day_not_the_whole_forecast(monkeypatch):
    """/weather/daily answers with one day, so its response model must allow one.

    It used to be declared as the full forecast model, which made every call
    that actually had data fail the response validation and return 500, while a
    day with no snapshot still returned 200 - the failure hid behind the happy
    path.
    """
    monkeypatch.setattr(weather_service, "_fetch", lambda lat, lon: _upstream())
    headers = _register()["headers"]

    # Seed the snapshots first, so /daily has a row to return.
    client.get(f"{API}/weather/current", headers=headers)

    known = client.get(f"{API}/weather/daily", params={"date": "2026-10-06"}, headers=headers)
    assert known.status_code == 200, known.text
    body = known.json()
    assert body["condition"] == "Mưa"
    assert body["date"] == "2026-10-06"

    # A day that was never forecast still answers 200 with a null body.
    unknown = client.get(f"{API}/weather/daily", params={"date": "2019-01-01"}, headers=headers)
    assert unknown.status_code == 200, unknown.text
    assert unknown.json() is None


def test_current_weather_survives_a_malformed_upstream_reply(monkeypatch):
    """A broken upstream reply must degrade, not raise a 500.

    `_fetch` returning None was the original 500: the handler caught a list of
    error types that did not include AttributeError, so a malformed payload
    escaped the fallback meant for exactly this case.
    """
    monkeypatch.setattr(weather_service, "_fetch", lambda lat, lon: None)
    headers = _register()["headers"]

    resp = client.get(f"{API}/weather/current", headers=headers)

    # No fresh data and no stored history for this new account: 503, not 500.
    assert resp.status_code == 503, resp.text