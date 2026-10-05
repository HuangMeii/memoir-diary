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
    #: Refresh tokens are long-lived; access tokens stay short and are renewed
    #: silently through POST /auth/refresh.
    refresh_token_expire_days: int = 30

    # Admin bootstrap (dùng bởi `python -m app.seed.admin`).
    # Để trống thì script dùng email/username mặc định và hỏi mật khẩu.
    admin_email: str | None = None
    admin_username: str | None = None
    admin_password: str | None = None

    # Weather forecast (Open-Meteo). Free and needs no API key; set
    # `weather_api_enabled` to false to turn the feature off entirely.
    weather_api_url: str = "https://api.open-meteo.com/v1/forecast"
    weather_api_enabled: bool = True
    weather_timeout_seconds: float = 5.0
    weather_cache_ttl_minutes: int = 30
    weather_forecast_days: int = 7
    weather_default_lat: float = 21.0285
    weather_default_lon: float = 105.8542

    # CORS (comma separated)
    cors_origins: str = "http://localhost:8080,http://127.0.0.1:8080"

    @property
    def cors_origins_list(self) -> list[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
