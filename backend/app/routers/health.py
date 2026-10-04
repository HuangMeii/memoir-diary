"""Health log CRUD endpoints (steps, workout time, ...)."""

import uuid
from datetime import date

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import HealthLog, User
from app.schemas.misc import HealthLogCreate, HealthLogOut, HealthLogUpdate

router = APIRouter(prefix="/health-logs", tags=["health"])


def _get_owned(db: Session, user: User, log_id: uuid.UUID) -> HealthLog:
    log = db.get(HealthLog, log_id)
    if log is None or log.user_id != user.id:
        raise HTTPException(status_code=404, detail="Health log not found")
    return log


@router.get("", response_model=list[HealthLogOut])
def list_logs(
    date_from: date | None = Query(None, alias="from"),
    date_to: date | None = Query(None, alias="to"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(HealthLog).where(HealthLog.user_id == current_user.id)
    if date_from:
        stmt = stmt.where(HealthLog.log_date >= date_from)
    if date_to:
        stmt = stmt.where(HealthLog.log_date <= date_to)
    stmt = stmt.order_by(HealthLog.log_date.desc())
    return db.execute(stmt).scalars().all()


@router.post("", response_model=HealthLogOut, status_code=status.HTTP_201_CREATED)
def upsert_log(
    payload: HealthLogCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    existing = db.execute(
        select(HealthLog).where(
            HealthLog.user_id == current_user.id,
            HealthLog.log_date == payload.log_date,
        )
    ).scalars().first()
    if existing:
        for field, value in payload.model_dump(exclude_unset=True).items():
            setattr(existing, field, value)
        db.commit()
        db.refresh(existing)
        return existing

    log = HealthLog(user_id=current_user.id, **payload.model_dump())
    db.add(log)
    db.commit()
    db.refresh(log)
    return log


@router.put("/{log_id}", response_model=HealthLogOut)
def update_log(
    log_id: uuid.UUID,
    payload: HealthLogUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    log = _get_owned(db, current_user, log_id)
    for field, value in payload.model_dump(exclude_unset=True).items():
        setattr(log, field, value)
    db.commit()
    db.refresh(log)
    return log


@router.delete("/{log_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_log(
    log_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    log = _get_owned(db, current_user, log_id)
    db.delete(log)
    db.commit()
