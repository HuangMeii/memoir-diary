"""Authentication endpoints: register, login, refresh, me."""

import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from jose import JWTError
from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.database import get_db
from app.core.deps import get_current_user
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_refresh_token,
    hash_password,
    verify_password,
)
from app.models import User
from app.schemas.auth import (
    RefreshRequest,
    RegisterResponse,
    Token,
    UserCreate,
    UserOut,
)

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/register", response_model=RegisterResponse, status_code=status.HTTP_201_CREATED)
def register(payload: UserCreate, db: Session = Depends(get_db)) -> RegisterResponse:
    existing = db.execute(
        select(User).where(
            or_(User.email == payload.email, User.username == payload.username)
        )
    ).scalars().first()
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email or username already registered",
        )

    user = User(
        email=payload.email,
        username=payload.username,
        password_hash=hash_password(payload.password),
        display_name=payload.display_name,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token(str(user.id))
    return RegisterResponse(
        **UserOut.model_validate(user).model_dump(),
        access_token=token,
        refresh_token=create_refresh_token(str(user.id)),
    )


@router.post("/login", response_model=Token)
def login(
    form: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db),
) -> Token:
    user = db.execute(
        select(User).where(
            or_(User.email == form.username, User.username == form.username)
        )
    ).scalars().first()
    if (
        user is None
        or not user.is_active
        or not verify_password(form.password, user.password_hash)
    ):
        # One message for all three failures: telling a caller whether the
        # account exists or is disabled would leak that information.
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email/username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    token = create_access_token(str(user.id))
    return Token(
        access_token=token,
        refresh_token=create_refresh_token(str(user.id)),
        expires_in=settings.access_token_expire_minutes * 60,
    )


@router.post("/refresh", response_model=Token)
def refresh(
    payload: RefreshRequest,
    db: Session = Depends(get_db),
) -> Token:
    """Issue a fresh access token from a valid refresh token.

    `decode_refresh_token` rejects an access token sent here, so the two cannot
    be swapped. The account is re-loaded and re-checked: a deactivated user must
    not be able to keep renewing their session with an old refresh token.
    """
    try:
        subject = decode_refresh_token(payload.refresh_token).get("sub")
        if subject is None:
            raise ValueError("no subject")
        user_id = uuid.UUID(str(subject))
    except (JWTError, ValueError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token",
            headers={"WWW-Authenticate": "Bearer"},
        ) from None

    user = db.get(User, user_id)
    if user is None or not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return Token(
        access_token=create_access_token(str(user.id)),
        expires_in=settings.access_token_expire_minutes * 60,
    )


@router.get("/me", response_model=UserOut)
def me(current_user: User = Depends(get_current_user)) -> User:
    return current_user
