from core.services import InventoryService, ReviewService
from adapters.inventory_mock import InventoryMockAdapter
from adapters.reviews_mock import ReviewsMockAdapter

def test_inventory_snapshot_returns_items():
    svc = InventoryService(InventoryMockAdapter())
    items = svc.snapshot()
    assert len(items) >= 1
    assert all(hasattr(i, "name") for i in items)

def test_review_themes_detect_keywords():
    svc = ReviewService(ReviewsMockAdapter())
    themes = dict(svc.themes(7))
    # With our mock data "slow" should be present
    assert "slow" in themes and themes["slow"] >= 1