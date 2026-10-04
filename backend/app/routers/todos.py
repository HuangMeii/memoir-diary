"""Todo (weekly goal) CRUD endpoints."""

import uuid
from datetime import UTC, datetime

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import Todo, User
from app.schemas.misc import TodoCreate, TodoOut, TodoUpdate

router = APIRouter(prefix="/todos", tags=["todos"])


def _get_owned(db: Session, user: User, todo_id: uuid.UUID) -> Todo:
    todo = db.get(Todo, todo_id)
    if todo is None or todo.user_id != user.id:
        raise HTTPException(status_code=404, detail="Todo not found")
    return todo


@router.get("", response_model=list[TodoOut])
def list_todos(
    week: str | None = Query(None, description="Week label, e.g. 2026-W15"),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    stmt = select(Todo).where(Todo.user_id == current_user.id)
    if week:
        stmt = stmt.where(Todo.week_label == week)
    stmt = stmt.order_by(Todo.is_done, Todo.priority, Todo.due_date)
    return db.execute(stmt).scalars().all()


@router.post("", response_model=TodoOut, status_code=status.HTTP_201_CREATED)
def create_todo(
    payload: TodoCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    todo = Todo(user_id=current_user.id, **payload.model_dump())
    db.add(todo)
    db.commit()
    db.refresh(todo)
    return todo


@router.put("/{todo_id}", response_model=TodoOut)
def update_todo(
    todo_id: uuid.UUID,
    payload: TodoUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    todo = _get_owned(db, current_user, todo_id)
    data = payload.model_dump(exclude_unset=True)
    if "is_done" in data:
        todo.completed_at = datetime.now(UTC) if data["is_done"] else None
    for field, value in data.items():
        setattr(todo, field, value)
    db.commit()
    db.refresh(todo)
    return todo


@router.patch("/{todo_id}/done", response_model=TodoOut)
def mark_done(
    todo_id: uuid.UUID,
    is_done: bool = True,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    todo = _get_owned(db, current_user, todo_id)
    todo.is_done = is_done
    todo.completed_at = datetime.now(UTC) if is_done else None
    db.commit()
    db.refresh(todo)
    return todo


@router.delete("/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_todo(
    todo_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    todo = _get_owned(db, current_user, todo_id)
    db.delete(todo)
    db.commit()
