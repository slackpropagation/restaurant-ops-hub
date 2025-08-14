from .ports import InventoryPort, ReviewsPort
from .domain import InventoryItem, Review
from collections import Counter

class InventoryService:
    def __init__(self, inventory_port: InventoryPort):
        self.port = inventory_port
    def snapshot(self) -> list[InventoryItem]:
        return self.port.fetch_current()

class ReviewService:
    KEYWORDS = ["slow", "cold", "overcooked", "rude", "loud"]
    def __init__(self, reviews_port: ReviewsPort):
        self.port = reviews_port
    def recent(self, days=7) -> list[Review]:
        return self.port.fetch_recent(days)
    def themes(self, days=7):
        texts = [r.text.lower() for r in self.recent(days)]
        counts = Counter({k: sum(k in t for t in texts) for k in self.KEYWORDS})
        return sorted([(k,v) for k,v in counts.items() if v>0], key=lambda x:-x[1])