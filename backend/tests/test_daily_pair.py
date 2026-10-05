"""Tests for the daily pair: two quotes, and reflections without an entry."""

import uuid

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import select

from app.core.database import SessionLocal
from app.core.security import hash_password
from app.main import app
from app.models import Quote, SelfMessage, User
from app.services import quote_service

client = TestClient(app)

API = "/api/v1"


@pytest.fixture(autouse=True)
def _clean_own_quotes():
    """Drop the quotes these tests create.

    `test_seed` asserts the library holds exactly the 100 seed quotes and the
    test database is session-scoped and shared, so leftovers here would break
    it. Only rows owned by the accounts created below are removed, never the
    seed rows (user_id NULL) or another test's fixtures.
    """
    yield
    with SessionLocal() as db:
        owned_by_tests = [
            row[0]
            for row in db.execute(
                select(User.id).where(User.email.like("user_%@example.com"))
            ).all()
        ] + [
            row[0]
            for row in db.execute(
                select(User.id).where(User.email.like("admin_%@example.com"))
            ).all()
        ]
        if owned_by_tests:
            db.query(Quote).filter(Quote.user_id.in_(owned_by_tests)).delete(
                synchronize_session=False
            )
            db.commit()


def _make_user(role: str = "user") -> dict:
    suffix = uuid.uuid4().hex[:10]
    email = f"{role}_{suffix}@example.com"
    with SessionLocal() as db:
        db.add(
            User(
                email=email,
                username=f"{role[:1]}{suffix}",
                password_hash=hash_password("secret123"),
                is_active=True,
                role=role,
            )
        )
        db.commit()
    resp = client.post(
        f"{API}/auth/login", data={"username": email, "password": "secret123"}
    )
    assert resp.status_code == 200, resp.text
    return {"Authorization": f"Bearer {resp.json()['access_token']}", "email": email}


def _seed_quote(text: str, user_id) -> Quote:
    with SessionLocal() as db:
        quote = Quote(user_id=user_id, text=text, is_active=True)
        db.add(quote)
        db.commit()
        db.refresh(quote)
        return quote


def _seed_self_message(user_id, content: str) -> None:
    with SessionLocal() as db:
        db.add(SelfMessage(user_id=user_id, content=content))
        db.commit()


def _user_id(account: dict):
    me = client.get(f"{API}/auth/me", headers=account)
    assert me.status_code == 200, me.text
    return uuid.UUID(me.json()["id"])


# --- Pairing rule ---
def test_few_self_messages_yield_two_different_quotes():
    account = _make_user()
    uid = _user_id(account)
    _seed_quote("Câu A", uid)
    _seed_quote("Câu B", uid)
    _seed_quote("Câu C", uid)

    with SessionLocal() as db:
        first, second, mine = quote_service.random_pair(db, uid)

    assert first is not None
    assert mine is None, "below the threshold no self message is drawn"
    assert second is not None, "below the threshold two quotes are drawn"
    assert first.id != second.id, "the two quotes must differ"


def test_enough_self_messages_pair_one_quote_with_one_message():
    account = _make_user()
    uid = _user_id(account)
    _seed_quote("Câu A", uid)
    for i in range(quote_service.MIN_SELF_MESSAGES_TO_PAIR):
        _seed_self_message(uid, f"Lời nhắn {i}")

    with SessionLocal() as db:
        first, second, mine = quote_service.random_pair(db, uid)

    assert first is not None
    assert mine is not None, "at the threshold a self message is drawn"
    assert second is None, "the second quote slot is unused when paired"


def test_today_endpoint_stores_two_quotes_when_unpaired():
    account = _make_user()
    uid = _user_id(account)
    _seed_quote("Câu A cho hôm nay", uid)
    _seed_quote("Câu B cho hôm nay", uid)

    resp = client.get(f"{API}/daily-quotes/today", headers=account)
    assert resp.status_code == 200, resp.text
    body = resp.json()
    assert body["quote_id"] is not None
    # With no self messages saved, the day carries two quotes.
    assert body["quote_id_2"] is not None
    assert body["quote_id"] != body["quote_id_2"]
    assert body["quote"]["text"]
    assert body["quote_2"]["text"]
    assert body["self_message_id"] is None


# --- Reflections without a diary entry ---
def test_reflection_saves_without_entry_and_links_today():
    account = _make_user()
    uid = _user_id(account)
    _seed_quote("Câu để suy nghĩ", uid)

    today = client.get(f"{API}/daily-quotes/today", headers=account).json()

    resp = client.post(
        f"{API}/reflections",
        json={"thought": "Suy nghĩ của hôm nay"},
        headers=account,
    )
    assert resp.status_code == 201, resp.text
    body = resp.json()
    # No diary entry exists for this account, so entry_id stays null...
    assert body["entry_id"] is None
    assert body["thought"] == "Suy nghĩ của hôm nay"
    # ...while the thought still points at the quotes actually shown.
    assert body["quote_id"] == today["quote_id"]

    listed = client.get(f"{API}/reflections", headers=account)
    assert listed.status_code == 200
    assert any(r["thought"] == "Suy nghĩ của hôm nay" for r in listed.json())


def test_reflection_rejects_unknown_entry():
    account = _make_user()
    resp = client.post(
        f"{API}/reflections",
        json={"thought": "x", "entry_id": str(uuid.uuid4())},
        headers=account,
    )
    assert resp.status_code == 404


# --- Self message library ---
def test_self_message_saved_from_card_joins_the_library():
    account = _make_user()

    created = client.post(
        f"{API}/self-messages",
        json={"content": "Một năm nữa mình thế nào?"},
        headers=account,
    )
    assert created.status_code == 201, created.text

    listed = client.get(f"{API}/self-messages", headers=account)
    assert listed.status_code == 200
    assert len(listed.json()) == 1
    assert listed.json()[0]["content"] == "Một năm nữa mình thế nào?"