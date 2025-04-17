from fastapi import APIRouter, HTTPException
import redis.exceptions
from ...services.redis_client import r
from ...models.book import Book
from ...models.search_request import SearchRequest
import json

router = APIRouter()



@router.post("/search", response_model=list[dict])
async def search_books(body: SearchRequest):
    books = []
    try:
        for key in r.scan_iter("book:*"):
            data = json.loads(r.get(key))
            if (
                body.query.lower() in data["title"].lower()
                or body.query.lower() == data["category"].lower()
            ):
                books.append(data)
        return books
    except redis.exceptions.RedisError as e:
        raise HTTPException(status_code=503, detail="Error con Redis: " + str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/", response_model=list[Book])
async def get_books(category: str = ""):
    books = []
    try:
        for key in r.scan_iter("book:*"):
            data = json.loads(r.get(key))
            if not category or category.lower() in data["category"].lower():
                books.append(data)
        return books
    except redis.exceptions.RedisError as e:
        raise HTTPException(status_code=503, detail="Error con Redis: " + str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))