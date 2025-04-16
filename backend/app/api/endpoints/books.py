from fastapi import APIRouter, Query

router = APIRouter()

@router.get("/search")
async def search_books(title: str = Query(None), category: str = Query(None)):
    return {"message": f"Searching books with title={title}, category={category}"}

@router.get("/")
async def get_books(category: str = None):
    return {"message": f"Retrieving books in category: {category}"}
