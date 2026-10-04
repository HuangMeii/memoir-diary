"""End-to-end smoke tests for the Phase 1 backend.

Run from the `backend/` directory:  pytest -q
Uses TestClient against the configured database (SQLite by default).
"""

import uuid

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)

API = "/api/v1"


def _new_account() -> dict:
    suffix = uuid.uuid4().hex[:10]
    return {
        "email": f"user_{suffix}@example.com",
        "username": f"u{suffix}",
        "password": "secret123",
    }


def _auth_headers() -> dict:
    payload = _new_account()
    resp = client.post(f"{API}/auth/register", json=payload)
    assert resp.status_code == 201, resp.text
    return {"Authorization": f"Bearer {resp.json()['access_token']}"}


def test_health():
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.json()["status"] == "ok"


def test_lookups_are_public():
    assert client.get(f"{API}/moods").status_code == 200
    assert client.get(f"{API}/weathers").status_code == 200


def test_register_login_me():
    payload = _new_account()
    resp = client.post(f"{API}/auth/register", json=payload)
    assert resp.status_code == 201, resp.text
    body = resp.json()
    assert body["email"] == payload["email"]
    token = body["access_token"]

    me = client.get(f"{API}/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert me.status_code == 200
    assert me.json()["username"] == payload["username"]

    login = client.post(
        f"{API}/auth/login",
        data={"username": payload["email"], "password": payload["password"]},
    )
    assert login.status_code == 200
    assert "access_token" in login.json()


def test_duplicate_registration_conflicts():
    payload = _new_account()
    assert client.post(f"{API}/auth/register", json=payload).status_code == 201
    assert client.post(f"{API}/auth/register", json=payload).status_code == 409


def test_protected_endpoint_requires_auth():
    assert client.get(f"{API}/notes").status_code == 401


def test_notes_crud():
    headers = _auth_headers()

    created = client.post(f"{API}/notes", json={"content": "ghi chú test"}, headers=headers)
    assert created.status_code == 201, created.text
    note_id = created.json()["id"]

    listed = client.get(f"{API}/notes", headers=headers)
    assert listed.status_code == 200
    assert len(listed.json()) == 1

    pinned = client.patch(f"{API}/notes/{note_id}/pin", headers=headers)
    assert pinned.status_code == 200
    assert pinned.json()["is_pinned"] is True

    deleted = client.delete(f"{API}/notes/{note_id}", headers=headers)
    assert deleted.status_code == 204


def test_quotes_crud_and_random_pair():
    headers = _auth_headers()

    created = client.post(
        f"{API}/quotes",
        json={"text": "Câu test động viên", "category": "động viên"},
        headers=headers,
    )
    assert created.status_code == 201, created.text
    quote_id = created.json()["id"]

    listed = client.get(f"{API}/quotes", headers=headers)
    assert listed.status_code == 200
    assert any(q["id"] == quote_id for q in listed.json())

    pair = client.get(f"{API}/random-pair", headers=headers)
    assert pair.status_code == 200
    assert "quote" in pair.json()

    soft_deleted = client.delete(f"{API}/quotes/{quote_id}", headers=headers)
    assert soft_deleted.status_code == 204


def test_todos_and_health_and_stats():
    headers = _auth_headers()

    todo = client.post(f"{API}/todos", json={"title": "Mục tiêu tuần"}, headers=headers)
    assert todo.status_code == 201
    todo_id = todo.json()["id"]
    done = client.patch(f"{API}/todos/{todo_id}/done", headers=headers)
    assert done.status_code == 200 and done.json()["is_done"] is True

    health = client.post(
        f"{API}/health-logs",
        json={"log_date": "2026-04-04", "steps": 8000, "workout_minutes": 45},
        headers=headers,
    )
    assert health.status_code == 201

    grid = client.get(f"{API}/stats/mood-grid?month=2026-04", headers=headers)
    assert grid.status_code == 200
    assert grid.json()["cells"] == []

    summary = client.get(f"{API}/stats/summary?month=2026-04", headers=headers)
    assert summary.status_code == 200
    assert summary.json()["total_steps"] == 8000
