"""FastAPI application entrypoint."""

from contextlib import asynccontextmanager

from fastapi import APIRouter, FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app import __version__
from app.core.config import settings
from app.core.database import Base, engine
from app import models  # noqa: F401  (register all ORM models on Base.metadata)
from app.routers import (
    auth,
    entries,
    events,
    health,
    images,
    lookups,
    notes,
    quotes,
    reflections,
    schedules,
    self_messages,
    stats,
    todos,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    if settings.auto_create_tables:
        Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title=settings.app_name,
    version=__version__,
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health", tags=["system"])
def health_check():
    return {"status": "ok", "app": settings.app_name, "version": __version__}


api = APIRouter(prefix=settings.api_v1_prefix)
api.include_router(auth.router)
api.include_router(lookups.router)
api.include_router(entries.router)
api.include_router(images.router)
api.include_router(quotes.router)
api.include_router(self_messages.router)
api.include_router(reflections.router)
api.include_router(notes.router)
api.include_router(todos.router)
api.include_router(events.router)
api.include_router(schedules.router)
api.include_router(health.router)
api.include_router(stats.router)
app.include_router(api)
