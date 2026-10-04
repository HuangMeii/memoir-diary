"""Tests for the idempotent seed script."""

from app.core.database import SessionLocal
from app.models import Mood, Quote, Weather
from app.seed.seed import load_quotes, reset_seed_data, seed_lookups, seed_quotes


def test_quote_library_has_100_unique_entries():
    quotes = load_quotes()
    assert len(quotes) == 100
    assert len({q["text"] for q in quotes}) == 100
    assert all(q["text"] and q["category"] for q in quotes)


def test_seed_lookups_creates_five_moods_and_five_weathers():
    with SessionLocal() as db:
        reset_seed_data(db)
        seed_lookups(db)

        moods = db.query(Mood).order_by(Mood.sort_order).all()
        weathers = db.query(Weather).order_by(Weather.sort_order).all()

        assert [m.code for m in moods] == ["happy", "sad", "bored", "neutral", "angry"]
        assert [w.code for w in weathers] == [
            "sunny",
            "cloudy",
            "rainy",
            "storm",
            "other",
        ]
        assert weathers[-1].label_vi == "Khác"
        for row in [*moods, *weathers]:
            assert row.color_hex.startswith("#")
            assert len(row.color_hex) == 7


def test_seed_quotes_is_idempotent():
    with SessionLocal() as db:
        reset_seed_data(db)
        seed_lookups(db)

        inserted, skipped = seed_quotes(db)
        assert inserted == 100
        assert skipped == 0

        # Second run must not duplicate anything.
        inserted_again, skipped_again = seed_quotes(db)
        assert inserted_again == 0
        assert skipped_again == 100

        total = db.query(Quote).count()
        assert total == 100
        assert all(q.user_id is None for q in db.query(Quote).all())