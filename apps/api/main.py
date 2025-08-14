from fastapi import FastAPI, Query
from apps.api.config import get_settings
from apps.api.adapter_registry import AdapterRegistry
from core.services import InventoryService, ReviewService

settings = get_settings()
registry = AdapterRegistry(settings.adapters)

app = FastAPI(title="Ops Hub API", version="0.1.0")

inv_svc = InventoryService(registry.inventory())
rev_svc = ReviewService(registry.reviews())

@app.get("/health")
def health():
    return {"ok": True, "adapters": settings.adapters}

@app.get("/inventory")
def get_inventory():
    return [i.__dict__ | {"status": i.status.value} for i in inv_svc.snapshot()]

@app.get("/reviews")
def get_reviews(days: int = Query(7, ge=1, le=30)):
    return [r.__dict__ for r in rev_svc.recent(days)]

@app.get("/themes")
def get_themes(days: int = Query(7, ge=1, le=30)):
    return [{"name": k, "count": v} for k, v in rev_svc.themes(days)]