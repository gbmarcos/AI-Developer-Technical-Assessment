from ...scrappers.scrape_hn import fetch_hacker_news_top_stories
from fastapi import APIRouter, HTTPException

router = APIRouter()

@router.get("/")
async def hacker_news():
    try:
        return {"headlines": fetch_hacker_news_top_stories()}
    except Exception as e:
        raise HTTPException(status_code=500, detail="Error obteniendo noticias: " + str(e))
