from fastapi import APIRouter, HTTPException
from ...scrappers.scrape_books import scrape_books


router = APIRouter()

@router.post("/init")
async def init_scrape():
    try:
        scrape_books()  
        return {"message": "Scrapping started"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error starting scraping: {str(e)}")