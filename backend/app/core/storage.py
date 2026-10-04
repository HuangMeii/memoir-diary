"""Neon Object Storage helpers (S3-compatible, path-style + SigV4)."""

import boto3
from botocore.config import Config
from botocore.exceptions import BotoCoreError, ClientError

from app.core.config import settings


def is_configured() -> bool:
    return all(
        [
            settings.s3_endpoint_url,
            settings.s3_access_key_id,
            settings.s3_secret_access_key,
        ]
    )


def get_s3_client():
    return boto3.client(
        "s3",
        endpoint_url=settings.s3_endpoint_url,
        region_name=settings.s3_region,
        aws_access_key_id=settings.s3_access_key_id,
        aws_secret_access_key=settings.s3_secret_access_key,
        config=Config(signature_version="s3v4", s3={"addressing_style": "path"}),
    )


def upload_object(key: str, fileobj, content_type: str) -> None:
    client = get_s3_client()
    client.upload_fileobj(
        fileobj,
        settings.s3_bucket,
        key,
        ExtraArgs={"ContentType": content_type},
    )


def delete_object(key: str) -> None:
    client = get_s3_client()
    try:
        client.delete_object(Bucket=settings.s3_bucket, Key=key)
    except (BotoCoreError, ClientError):
        # Best-effort cleanup: ignore if object is already gone.
        pass


def presigned_get_url(key: str, expires_seconds: int = 3600) -> str:
    client = get_s3_client()
    return client.generate_presigned_url(
        "get_object",
        Params={"Bucket": settings.s3_bucket, "Key": key},
        ExpiresIn=expires_seconds,
    )
