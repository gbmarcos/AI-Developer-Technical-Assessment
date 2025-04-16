from fastapi import FastAPI
from app.api.routes import router as api_router

app = FastAPI(
    title="Book & Hacker News API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

app.include_router(api_router)
