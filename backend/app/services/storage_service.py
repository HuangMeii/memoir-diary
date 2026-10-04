"""Image upload orchestration (Neon Object Storage)."""

import uuid
from pathlib import Path

from fastapi import UploadFile

from app.core import storage


def build_object_key(entry_id: uuid.UUID, filename: str | None) -> str:
    ext = Path(filename or "").suffix.lower() or ".jpg"
    return f"entries/{entry_id}/{uuid.uuid4().hex}{ext}"


def store_entry_image(entry_id: uuid.UUID, upload: UploadFile) -> tuple[str, int]:
    """Upload a file to object storage; returns (object_key, size_bytes)."""
    key = build_object_key(entry_id, upload.filename)
    size = 0
    # UploadFile.file is a SpooledTemporaryFile (seekable); measure size first.
    upload.file.seek(0, 2)
    size = upload.file.tell()
    upload.file.seek(0)
    storage.upload_object(
        key, upload.file, upload.content_type or "application/octet-stream"
    )
    return key, size
