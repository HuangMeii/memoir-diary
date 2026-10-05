"""Password hashing (bcrypt) and JWT helpers."""

from datetime import datetime, timedelta, timezone

import bcrypt
from jose import jwt
from jose.exceptions import JWTError

from app.core.config import settings

# bcrypt only considers the first 72 bytes of a password.
_BCRYPT_MAX_BYTES = 72

#: `type` claim on every token we issue. Checking it is what stops a long-lived
#: refresh token from being replayed as an access token on the whole API.
TOKEN_TYPE_ACCESS = "access"
TOKEN_TYPE_REFRESH = "refresh"


def hash_password(password: str) -> str:
    pw = password.encode("utf-8")[:_BCRYPT_MAX_BYTES]
    return bcrypt.hashpw(pw, bcrypt.gensalt()).decode("utf-8")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    try:
        pw = plain_password.encode("utf-8")[:_BCRYPT_MAX_BYTES]
        return bcrypt.checkpw(pw, hashed_password.encode("utf-8"))
    except (ValueError, TypeError):
        return False


def create_access_token(subject: str, expires_minutes: int | None = None) -> str:
    expire = datetime.now(timezone.utc) + timedelta(
        minutes=expires_minutes or settings.access_token_expire_minutes
    )
    payload = {
        "sub": str(subject),
        "exp": expire,
        "type": TOKEN_TYPE_ACCESS,
    }
    return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)


def create_refresh_token(subject: str, expires_days: int | None = None) -> str:
    """Long-lived token accepted only by `/auth/refresh`.

    It is stateless: nothing is stored, so revoking it individually would need a
    new table. Deactivating the account is what actually cuts a session short,
    and both `/auth/refresh` and every request re-check `is_active`.
    """
    expire = datetime.now(timezone.utc) + timedelta(
        days=expires_days or settings.refresh_token_expire_days
    )
    payload = {
        "sub": str(subject),
        "exp": expire,
        "type": TOKEN_TYPE_REFRESH,
    }
    return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)


def decode_token(token: str, expected_type: str = TOKEN_TYPE_ACCESS) -> dict:
    """Decode a token and require it to be of [expected_type].

    Tokens issued before the `type` claim existed have none; they are access
    tokens, so they still pass. Anything that *is* tagged must match.
    """
    payload = jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
    token_type = payload.get("type", TOKEN_TYPE_ACCESS)
    if token_type != expected_type:
        raise JWTError(f"expected a {expected_type} token, got {token_type}")
    return payload


def decode_access_token(token: str) -> dict:
    return decode_token(token, TOKEN_TYPE_ACCESS)


def decode_refresh_token(token: str) -> dict:
    return decode_token(token, TOKEN_TYPE_REFRESH)
