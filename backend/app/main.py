from app.api.endpoints.init import init_scrape
from fastapi import FastAPI
from app.api.routes import router as api_router
from app.services.redis_client import r

app = FastAPI(
    title="Book & Hacker News API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

app.include_router(api_router)

async def check_and_init_db():
    if r.dbsize() < 5:
        await init_scrape()  

@app.on_event("startup")
async def startup_event():
    await check_and_init_db()