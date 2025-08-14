from pydantic import BaseModel
from typing import Optional

class InventoryOut(BaseModel):
    item_id: str
    name: str
    status: str
    expected_back: Optional[str] = None
    notes: str

class ReviewOut(BaseModel):
    review_id: str
    source: str
    rating: int
    text: str
    created_at: str
    url: Optional[str] = None

class ThemeOut(BaseModel):
    name: str
    count: int