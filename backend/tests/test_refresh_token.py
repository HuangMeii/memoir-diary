"""Tests for the refresh-token flow.

The point of these is that a refresh token is only ever good for
`/auth/refresh`: replaying one as an access token would hand a 30-day
credential to the whole API.
"""

import uuid
from datetime import datetime, timedelta, timezone

from fastapi.testclient import TestClient
from jose import jwt as jose_jwt
from jose.exceptions import JWTError

from app.core.config import settings
from app.core.database import SessionLocal
from app.core.security import (
    TOKEN_TYPE_ACCESS,
    TOKEN_TYPE_REFRESH,
    decode_access_token,
    decode_refresh_token,
)
from app.main import app
from app.models import User

client = TestClient(app)

API = "/api/v1"


def _register(role: str = "user") -> dict:
    suffix = uuid.uuid4().hex[:10]
    email = f"{role}_{suffix}@example.com"
    resp = client.post(
        f"{API}/auth/register",
        json={
            "email": email,
            "username": f"{role[:1]}{suffix}",
            "password": "secret123",
        },
    )
    assert resp.status_code == 201, resp.text
    return {"email": email, **resp.json()}


def _login(email: str) -> dict:
    resp = client.post(
        f"{API}/auth/login", data={"username": email, "password": "secret123"}
    )
    assert resp.status_code == 200, resp.text
    return resp.json()


# --- Issuing ---
def test_register_returns_both_tokens():
    body = _register()
    assert body["access_token"]
    assert body["refresh_token"]


def test_login_returns_both_tokens():
    account = _register()
    tokens = _login(account["email"])
    assert tokens["access_token"]
    assert tokens["refresh_token"]
    assert tokens["expires_in"] == settings.access_token_expire_minutes * 60


# --- Refreshing ---
def test_refresh_issues_a_usable_access_token():
    account = _register()
    tokens = _login(account["email"])

    resp = client.post(
        f"{API}/auth/refresh",
        json={"refresh_token": tokens["refresh_token"]},
    )
    assert resp.status_code == 200, resp.text
    fresh = resp.json()["access_token"]

    me = client.get(f"{API}/auth/me", headers={"Authorization": f"Bearer {fresh}"})
    assert me.status_code == 200
    assert me.json()["id"] == account["id"]


def test_refresh_rejects_a_bogus_token():
    resp = client.post(
        f"{API}/auth/refresh", json={"refresh_token": "not-a-real-token"}
    )
    assert resp.status_code == 401


def test_refresh_rejects_an_expired_refresh_token():
    account = _register()
    expired = jose_jwt.encode(
        {
            "sub": account["id"],
            "exp": datetime.now(timezone.utc) - timedelta(minutes=5),
            "type": TOKEN_TYPE_REFRESH,
        },
        settings.jwt_secret,
        algorithm=settings.jwt_algorithm,
    )
    resp = client.post(f"{API}/auth/refresh", json={"refresh_token": expired})
    assert resp.status_code == 401


def test_deactivated_account_cannot_refresh():
    """Deactivating an account must cut off refreshes, not just requests."""
    account = _register()
    tokens = _login(account["email"])

    with SessionLocal() as db:
        user = db.get(User, uuid.UUID(account["id"]))
        user.is_active = False
        db.commit()

    resp = client.post(
        f"{API}/auth/refresh",
        json={"refresh_token": tokens["refresh_token"]},
    )
    assert resp.status_code == 401


# --- The security guarantee ---
def test_refresh_token_is_rejected_as_an_access_token():
    account = _register()
    tokens = _login(account["email"])

    # Used against the API...
    resp = client.get(
        f"{API}/auth/me",
        headers={"Authorization": f"Bearer {tokens['refresh_token']}"},
    )
    assert resp.status_code == 401, "a refresh token must not open the API"

    # ...and refused by the decoder itself.
    try:
        decode_access_token(tokens["refresh_token"])
    except JWTError:
        pass
    else:  # pragma: no cover - only reached if the check regresses
        raise AssertionError("decode_access_token accepted a refresh token")


def test_access_token_is_rejected_by_the_refresh_endpoint():
    account = _register()
    tokens = _login(account["email"])

    resp = client.post(
        f"{API}/auth/refresh",
        json={"refresh_token": tokens["access_token"]},
    )
    assert resp.status_code == 401, "the two token types must not be swappable"

    try:
        decode_refresh_token(tokens["access_token"])
    except JWTError:
        pass
    else:  # pragma: no cover - only reached if the check regresses
        raise AssertionError("decode_refresh_token accepted an access token")


def test_each_token_carries_its_own_type():
    account = _register()
    tokens = _login(account["email"])
    assert decode_access_token(tokens["access_token"])["type"] == TOKEN_TYPE_ACCESS
    assert decode_refresh_token(tokens["refresh_token"])["type"] == TOKEN_TYPE_REFRESH