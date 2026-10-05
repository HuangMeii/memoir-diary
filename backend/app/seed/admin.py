"""Create or promote the admin account that curates the quote library.

Usage (from the `backend/` directory):

    python -m app.seed.admin                         # reads ADMIN_* from .env
    python -m app.seed.admin --email ... --password ...
    python -m app.seed.admin --promote-only          # only raise existing users

Design notes:
- Idempotent: running it twice never creates a duplicate and never resets a
  password unless one is passed explicitly.
- The password is never printed by the default `.env` path; the account is
  created with the hash, so a shell history leak is not a real credential leak.
- Never demotes the last remaining admin (that would lock everyone out).
"""

import argparse
import getpass

from pydantic import EmailStr, TypeAdapter, ValidationError
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import SessionLocal
from app.core.security import hash_password
from app.models import User
from app.models.user import ROLE_ADMIN

# `.local`/`.test`/`.invalid` are rejected by UserOut's EmailStr, so a row
# created with one would make GET /auth/me fail response validation.
DEFAULT_EMAIL = "admin@memoir.example.com"
DEFAULT_USERNAME = "admin"
DEFAULT_DISPLAY_NAME = "Quản trị viên"


def _validate_email(email: str) -> str:
    """Reject addresses the API's own EmailStr would refuse."""
    try:
        return str(TypeAdapter(EmailStr).validate_python(email))
    except ValidationError:
        raise SystemExit(
            f"Invalid email {email!r}.\n"
            "Use a normal domain, e.g. admin@yourdomain.com "
            "(reserved domains like .local/.test/.invalid are rejected)."
        )


def ensure_admin(
    db: Session,
    email: str,
    username: str,
    password: str | None = None,
    display_name: str = DEFAULT_DISPLAY_NAME,
) -> tuple[User, str]:
    """Ensure an admin account exists. Returns (user, action).

    `action` is "created", "promoted" or "password-updated" so the caller can
    print something meaningful. Existing admins are never touched unless a
    password is explicitly supplied.
    """
    user = db.execute(
        select(User).where(
            (User.email == email) | (User.username == username)
        )
    ).scalars().first()

    if user is None:
        if not password:
            raise SystemExit(
                "User not found and no password supplied.\n"
                "Re-run with --password <value> to create the account."
            )
        user = User(
            email=email,
            username=username,
            password_hash=hash_password(password),
            display_name=display_name,
            is_active=True,
            role=ROLE_ADMIN,
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return user, "created"

    action = "promoted"
    if user.role != ROLE_ADMIN:
        user.role = ROLE_ADMIN
    if password:
        user.password_hash = hash_password(password)
        action = "password-updated" if user.role == ROLE_ADMIN else "promoted"

    user.is_active = True
    db.commit()
    db.refresh(user)
    return user, action


def run(
    email: str,
    username: str,
    password: str | None,
    promote_only: bool,
) -> None:
    email = _validate_email(email)
    with SessionLocal() as db:
        if promote_only:
            # Turn an existing account into the admin instead of creating one.
            user = db.execute(
                select(User).where(
                    (User.email == email) | (User.username == username)
                )
            ).scalars().first()
            if user is None:
                raise SystemExit(
                    f"No user matches email={email!r} or username={username!r}."
                )
            user.role = ROLE_ADMIN
            user.is_active = True
            db.commit()
            db.refresh(user)
            action = "promoted"
        else:
            user, action = ensure_admin(db, email, username, password)

        admin_count = (
            db.execute(select(func.count(User.id)).where(User.role == ROLE_ADMIN)).scalar()
            or 0
        )

    print(f"Admin {action}: {user.username} <{user.email}>")
    print(f"user_id    : {user.id}")
    print(f"role       : {user.role}")
    print(f"active     : {user.is_active}")
    print(f"admins now : {admin_count}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Create/promote the Memoir admin account (kho câu)."
    )
    parser.add_argument("--email", default=settings.admin_email or DEFAULT_EMAIL)
    parser.add_argument("--username", default=settings.admin_username or DEFAULT_USERNAME)
    parser.add_argument("--password", default=settings.admin_password or None)
    parser.add_argument(
        "--promote-only",
        action="store_true",
        help="Only promote an existing account; never create or reset a password.",
    )
    args = parser.parse_args()

    # A password given on the command line is fine, but prefer the prompt when
    # the operator omitted one and the account does not exist yet.
    password = args.password
    if not password and not args.promote_only:
        password = getpass.getpass("Admin password (input hidden): ")
        if len(password) < 8:
            raise SystemExit("Password must be at least 8 characters.")

    run(args.email, args.username, password, args.promote_only)


if __name__ == "__main__":
    main()