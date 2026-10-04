"""Image upload / retrieval endpoints (Neon Object Storage)."""

import uuid

from fastapi import APIRouter, Depends, File, Form, HTTPException, UploadFile, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core import storage
from app.core.database import get_db
from app.core.deps import get_current_user
from app.models import DiaryEntry, EntryImage, User
from app.schemas.entry import ImageOut
from app.services import storage_service

router = APIRouter(tags=["images"])


def _owned_entry(db: Session, user: User, entry_id: uuid.UUID) -> DiaryEntry:
    entry = db.get(DiaryEntry, entry_id)
    if entry is None or entry.user_id != user.id:
        raise HTTPException(status_code=404, detail="Entry not found")
    return entry


def _owned_image(db: Session, user: User, image_id: uuid.UUID) -> EntryImage:
    image = db.get(EntryImage, image_id)
    entry = db.get(DiaryEntry, image.entry_id) if image else None
    if image is None or entry is None or entry.user_id != user.id:
        raise HTTPException(status_code=404, detail="Image not found")
    return image


@router.post(
    "/entries/{entry_id}/images",
    response_model=ImageOut,
    status_code=status.HTTP_201_CREATED,
)
def upload_image(
    entry_id: uuid.UUID,
    file: UploadFile = File(...),
    caption: str | None = Form(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    _owned_entry(db, current_user, entry_id)
    if not storage.is_configured():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Object storage is not configured",
        )
    object_key, size = storage_service.store_entry_image(entry_id, file)
    image = EntryImage(
        entry_id=entry_id,
        object_key=object_key,
        content_type=file.content_type or "application/octet-stream",
        size_bytes=size,
        caption=caption,
    )
    db.add(image)
    db.commit()
    db.refresh(image)
    return image


@router.get("/entries/{entry_id}/images", response_model=list[ImageOut])
def list_images(
    entry_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    _owned_entry(db, current_user, entry_id)
    stmt = (
        select(EntryImage)
        .where(EntryImage.entry_id == entry_id)
        .order_by(EntryImage.created_at)
    )
    return db.execute(stmt).scalars().all()


@router.get("/images/{image_id}/url")
def get_image_url(
    image_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    image = _owned_image(db, current_user, image_id)
    if not storage.is_configured():
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Object storage is not configured",
        )
    return {"url": storage.presigned_get_url(image.object_key)}


@router.delete("/images/{image_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_image(
    image_id: uuid.UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    image = _owned_image(db, current_user, image_id)
    if storage.is_configured():
        storage.delete_object(image.object_key)
    db.delete(image)
    db.commit()
