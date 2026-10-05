"""Application configuration loaded from environment / .env file."""

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env", env_file_encoding="utf-8", extra="ignore"
    )

    # App
    app_name: str = "Memoir API"
    api_v1_prefix: str = "/api/v1"
    debug: bool = False
    # Dev convenience: create tables on startup. Keep false in production (use Alembic).
    auto_create_tables: bool = False

    # Database
    database_url: str = "sqlite:///./memoir_dev.db"

    # Object storage (Neon Object Storage, S3-compatible)
    s3_endpoint_url: str | None = None
    s3_region: str = "aws-us-east-1"
    s3_access_key_id: str | None = None
    s3_secret_access_key: str | None = None
    s3_bucket: str = "diary-images"

    # Auth
    jwt_secret: str = "change-me-in-production"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 60

    # Admin bootstrap (dùng bởi `python -m app.seed.admin`).
    # Để trống thì script dùng email/username mặc định và hỏi mật khẩu.
    admin_email: str | None = None
    admin_username: str | None = None
    admin_password: str | None = None

    # CORS (comma separated)
    cors_origins: str = "http://localhost:8080,http://127.0.0.1:8080"

    @property
    def cors_origins_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
