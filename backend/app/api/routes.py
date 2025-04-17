from fastapi import APIRouter
from .endpoints import books, hackernews, init

router = APIRouter()
router.include_router(init.router, prefix="/init", tags=["Init"])
router.include_router(books.router, prefix="/books", tags=["Books"])
router.include_router(hackernews.router, prefix="/headlines", tags=["HackerNews"])
