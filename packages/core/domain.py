# packages/core/domain.py
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime, date
from enum import Enum
from typing import Optional

class StockStatus(str, Enum):
    OK = "ok"
    LOW = "low"
    EIGHTY_SIX = "86"

@dataclass
class InventoryItem:
    item_id: str
    name: str
    status: StockStatus
    expected_back: Optional[date] = None
    notes: str = ""
    # default_factory avoids evaluating at import time and is safer across Python versions
    updated_at: datetime = field(default_factory=datetime.utcnow)

@dataclass
class Review:
    review_id: str
    source: str
    rating: int
    text: str
    created_at: datetime
    url: Optional[str] = None

# Be explicit about exports to prevent any name resolution weirdness
__all__ = ["StockStatus", "InventoryItem", "Review"]