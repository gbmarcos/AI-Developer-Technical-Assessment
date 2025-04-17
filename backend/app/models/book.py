from pydantic import BaseModel

class Book(BaseModel):
    title: str
    price: float
    category: str
    image_url: str