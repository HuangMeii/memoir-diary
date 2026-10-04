"""Idempotent database seeding.

Usage (from the `backend/` directory):

    python -m app.seed.seed             # seed lookups + 100 quotes
    python -m app.seed.seed --reset     # delete seed rows first, then seed

Design notes:
- Idempotent: re-running never duplicates rows.
  - lookups are keyed by `code`
  - quotes are keyed by `text`
- Seed quotes get `user_id = NULL` so every user sees the shared library
  (see `Quote.user_id` semantics in app/models/quote.py).
- Quote data lives in `quotes_100.json` next to this module so it can be
  edited without touching Python code.
"""

import argparse
import json
from collections.abc import Iterable
from pathlib import Path

from sqlalchemy import delete, select
from sqlalchemy.orm import Session

from app.core.database import SessionLocal
from app.models import Mood, Quote, Weather
from app.seed.lookups import MOODS, WEATHERS

QUOTES_FILE = Path(__file__).with_name("quotes_100.json")


def load_quotes() -> list[dict]:
    """Load the quote library, skipping blank lines and `#` comments."""
    raw = QUOTES_FILE.read_text(encoding="utf-8")
    rows: list[dict] = []
    for line in raw.splitlines():
        stripped = line.strip().rstrip(",")
        if not stripped or stripped.startswith("#"):
            continue
        # Skip the array brackets themselves; each remaining line is one object.
        if stripped in ("[", "]"):
            continue
        rows.append(json.loads(stripped))
    return rows


def _seed_lookups(
    db: Session, model: type[Mood] | type[Weather], items: Iterable[dict]
) -> tuple[int, int]:
    """Insert or update lookup rows. Returns (inserted, updated)."""
    inserted = updated = 0
    for item in items:
        existing = db.execute(
            select(model).where(model.code == item["code"])
        ).scalar_one_or_none()
        if existing is None:
            db.add(model(**item))
            inserted += 1
        else:
            for field, value in item.items():
                if getattr(existing, field) != value:
                    setattr(existing, field, value)
                    updated += 1
    db.commit()
    return inserted, updated


def seed_lookups(db: Session) -> tuple[int, int, int, int]:
    """Seed moods and weathers. Returns (moods_new, moods_upd, weathers_new, weathers_upd)."""
    m_new, m_upd = _seed_lookups(db, Mood, MOODS)
    w_new, w_upd = _seed_lookups(db, Weather, WEATHERS)
    return m_new, m_upd, w_new, w_upd


def seed_quotes(db: Session) -> tuple[int, int]:
    """Insert missing quotes only. Returns (inserted, skipped_existing)."""
    quotes = load_quotes()
    existing_texts = set(db.execute(select(Quote.text)).scalars().all())

    inserted = 0
    skipped = 0
    for item in quotes:
        if item["text"] in existing_texts:
            skipped += 1
            continue
        db.add(
            Quote(
                user_id=None,  # system quote, shared across users
                text=item["text"],
                author=item.get("author"),
                source=item.get("source"),
                category=item.get("category"),
                is_active=True,
            )
        )
        existing_texts.add(item["text"])
        inserted += 1
    db.commit()
    return inserted, skipped


def reset_seed_data(db: Session) -> None:
    """Remove system seed rows (quotes + lookup tables). User rows are untouched."""
    db.execute(delete(Quote).where(Quote.user_id.is_(None)))
    db.execute(delete(Mood))
    db.execute(delete(Weather))
    db.commit()


def _ensure_schema_exists(db: Session) -> None:
    """Fail fast with an actionable message if migrations have not been run."""
    from sqlalchemy import inspect
    from sqlalchemy.exc import OperationalError

    try:
        tables = set(inspect(db.get_bind()).get_table_names())
    except OperationalError as exc:  # pragma: no cover - connection issues
        raise SystemExit(f"Cannot reach the database: {exc}") from exc

    required = {"moods", "weathers", "quotes"}
    missing = required - tables
    if missing:
        raise SystemExit(
            "Database schema is missing tables: "
            f"{', '.join(sorted(missing))}.\n"
            "Run migrations first:\n"
            "    alembic upgrade head\n"
            "Or start the app once with AUTO_CREATE_TABLES=true."
        )


def run(reset: bool = False) -> None:
    with SessionLocal() as db:
        _ensure_schema_exists(db)

        if reset:
            reset_seed_data(db)
            print("Reset: removed seed quotes, moods and weathers.")

        m_new, m_upd, w_new, w_upd = seed_lookups(db)
        print(f"Moods   : {m_new} inserted, {m_upd} updated")
        print(f"Weathers: {w_new} inserted, {w_upd} updated")

        q_new, q_skip = seed_quotes(db)
        print(f"Quotes  : {q_new} inserted, {q_skip} already present")

        total_quotes = db.execute(select(Quote)).scalars().all()
        print(f"Done. {len(total_quotes)} quote(s) now in the library.")


def main() -> None:
    parser = argparse.ArgumentParser(description="Seed Memoir reference data.")
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Delete existing seed rows (system quotes, moods, weathers) before seeding.",
    )
    args = parser.parse_args()
    run(reset=args.reset)


if __name__ == "__main__":
    main()