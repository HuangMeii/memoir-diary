"""Pytest fixtures: isolate tests on a dedicated SQLite database.

Sets DATABASE_URL to a separate test database BEFORE importing the app,
then creates the schema from the ORM metadata.
"""

import os
from pathlib import Path

TEST_DB = Path(__file__).resolve().parents[1] / "memoir_test.db"
os.environ["DATABASE_URL"] = f"sqlite:///{TEST_DB.as_posix()}"
os.environ.setdefault("JWT_SECRET", "test-secret")
os.environ.setdefault("AUTO_CREATE_TABLES", "false")

import pytest  # noqa: E402

from app import models  # noqa: E402,F401  (register models)
from app.core.database import Base, engine  # noqa: E402


@pytest.fixture(scope="session", autouse=True)
def _setup_database():
    if TEST_DB.exists():
        TEST_DB.unlink()
    Base.metadata.create_all(bind=engine)
    yield
