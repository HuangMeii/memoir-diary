"""Tests for the admin surface: kho câu curation + user management."""

import uuid

import pytest
from fastapi.testclient import TestClient

from app.core.database import SessionLocal
from app.core.security import hash_password
from app.main import app
from app.models import Quote, User

client = TestClient(app)

API = "/api/v1"


def _make_user(role: str = "user") -> tuple[str, dict]:
    """Create a user directly so we control `role` (register always makes users)."""
    suffix = uuid.uuid4().hex[:10]
    email = f"{role}_{suffix}@example.com"
    username = f"{role[:1]}{suffix}"
    with SessionLocal() as db:
        db.add(
            User(
                email=email,
                username=username,
                password_hash=hash_password("secret123"),
                display_name=f"{role} test",
                is_active=True,
                role=role,
            )
        )
        db.commit()
    return email, {"Authorization": f"Bearer {_token(email)}"}


def _token(email: str) -> str:
    resp = client.post(
        f"{API}/auth/login", data={"username": email, "password": "secret123"}
    )
    assert resp.status_code == 200, resp.text
    return resp.json()["access_token"]


def _admin_headers() -> dict:
    email, headers = _make_user("admin")
    return headers


def _user_headers() -> dict:
    _, headers = _make_user("user")
    return headers


# --- Guards ---
def test_admin_endpoints_require_auth():
    assert client.get(f"{API}/admin/stats").status_code == 401


def test_admin_endpoints_forbid_normal_users():
    headers = _user_headers()
    assert client.get(f"{API}/admin/stats", headers=headers).status_code == 403
    assert client.get(f"{API}/admin/quotes", headers=headers).status_code == 403
    assert client.get(f"{API}/admin/users", headers=headers).status_code == 403


# --- Kho câu ---
def test_admin_can_crud_system_quotes():
    headers = _admin_headers()

    created = client.post(
        f"{API}/admin/quotes",
        json={"text": "Câu hệ thống do admin tạo", "category": "kiên trì"},
        headers=headers,
    )
    assert created.status_code == 201, created.text
    quote_id = created.json()["id"]
    assert created.json()["user_id"] is None

    listed = client.get(f"{API}/admin/quotes", headers=headers)
    assert listed.status_code == 200
    assert any(q["id"] == quote_id for q in listed.json())

    updated = client.put(
        f"{API}/admin/quotes/{quote_id}", json={"author": "Admin"}, headers=headers
    )
    assert updated.status_code == 200
    assert updated.json()["author"] == "Admin"

    # System quotes are visible to everyone, including normal users.
    visible = client.get(f"{API}/quotes/{quote_id}", headers=_user_headers())
    assert visible.status_code == 200

    assert client.delete(f"{API}/admin/quotes/{quote_id}", headers=headers).status_code == 204
    after = client.get(f"{API}/admin/quotes?is_active=true", headers=headers)
    assert not any(q["id"] == quote_id for q in after.json())


def test_admin_cannot_touch_user_owned_quotes():
    headers = _admin_headers()
    _, user_headers = _make_user("user")

    created = client.post(
        f"{API}/quotes", json={"text": "Câu riêng của user"}, headers=user_headers
    )
    quote_id = created.json()["id"]

    assert client.put(
        f"{API}/admin/quotes/{quote_id}", json={"text": "hacked"}, headers=headers
    ).status_code == 404
    assert client.delete(
        f"{API}/admin/quotes/{quote_id}", headers=headers
    ).status_code == 404

    # The database is session-scoped and shared with test_seed, which asserts
    # an exact quote count; clean up this private quote.
    with SessionLocal() as db:
        db.delete(db.get(Quote, uuid.UUID(quote_id)))
        db.commit()


def test_normal_user_cannot_modify_system_quote():
    headers = _admin_headers()
    quote_id = client.post(
        f"{API}/admin/quotes",
        json={"text": "Câu chung không ai được sửa"},
        headers=headers,
    ).json()["id"]

    user_headers = _user_headers()
    assert client.put(
        f"{API}/quotes/{quote_id}", json={"text": "sửa"}, headers=user_headers
    ).status_code == 403
    assert client.delete(
        f"{API}/quotes/{quote_id}", headers=user_headers
    ).status_code == 403


# --- User management ---
def test_admin_can_list_and_update_users():
    headers = _admin_headers()
    target_email, _ = _make_user("user")

    # size=100 keeps this test independent of how many accounts earlier
    # tests already created in the shared session-scoped database.
    listed = client.get(f"{API}/admin/users?size=100", headers=headers)
    assert listed.status_code == 200
    target = next(u for u in listed.json() if u["email"] == target_email)
    assert target["role"] == "user"
    assert target["quote_count"] == 0

    patched = client.patch(
        f"{API}/admin/users/{target['id']}", json={"role": "admin"}, headers=headers
    )
    assert patched.status_code == 200
    assert patched.json()["role"] == "admin"

    deactivated = client.patch(
        f"{API}/admin/users/{target['id']}", json={"is_active": False}, headers=headers
    )
    assert deactivated.json()["is_active"] is False

    # A deactivated account can no longer authenticate.
    assert client.post(
        f"{API}/auth/login", data={"username": target_email, "password": "secret123"}
    ).status_code == 401


def test_admin_cannot_deactivate_self():
    headers = _admin_headers()
    me = client.get(f"{API}/auth/me", headers=headers).json()
    resp = client.patch(
        f"{API}/admin/users/{me['id']}", json={"is_active": False}, headers=headers
    )
    assert resp.status_code == 400


def test_admin_stats_reports_totals():
    headers = _admin_headers()
    resp = client.get(f"{API}/admin/stats", headers=headers)
    assert resp.status_code == 200
    body = resp.json()
    assert body["total_users"] >= 2
    assert body["admin_users"] >= 1
    assert body["total_quotes"] == body["system_quotes"] + body["user_quotes"]


# --- Auth surface ---
def test_me_exposes_role():
    _, headers = _make_user("admin")
    me = client.get(f"{API}/auth/me", headers=headers)
    assert me.status_code == 200
    assert me.json()["role"] == "admin"