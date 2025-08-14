from fastapi.testclient import TestClient
from apps.api.main import app
from apps.api.schemas import InventoryOut, ReviewOut, ThemeOut

client = TestClient(app)

def test_health():
    assert client.get("/health").json()["ok"] is True

def test_inventory_contract():
    data = client.get("/inventory").json()
    assert isinstance(data, list)
    InventoryOut.model_validate(data[0])

def test_reviews_contract():
    data = client.get("/reviews?days=7").json()
    assert isinstance(data, list)
    if data:
        ReviewOut.model_validate(data[0])

def test_themes_contract():
    data = client.get("/themes?days=7").json()
    assert isinstance(data, list)
    if data:
        ThemeOut.model_validate(data[0])