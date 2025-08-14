# Empty file; marks apps/worker as a Python package.
```python
from fastapi import FastAPI, Query
from packages.core.services import InventoryService, ReviewService
from packages.adapters.inventory_mock import InventoryMockAdapter
from packages.adapters.reviews_mock import ReviewsMockAdapter

app = FastAPI(title="Ops Hub API")
inv_svc = InventoryService(InventoryMockAdapter())
rev_svc = ReviewService(ReviewsMockAdapter())

@app.get("/inventory")
def get_inventory():
    return [i.__dict__ | {"status": i.status.value} for i in inv_svc.snapshot()]

@app.get("/reviews")
def get_reviews(days: int = Query(7, ge=1, le=30)):
    return [r.__dict__ for r in rev_svc.recent(days)]

@app.get("/themes")
def get_themes(days: int = Query(7, ge=1, le=30)):
    return [{"name": k, "count": v} for k,v in rev_svc.themes(days)]

@app.get("/health")
def health():
    return {"ok": True}