from typing import Optional
from core.ports import InventoryPort, ReviewsPort

# Adapters (mocks now; real ones later)
from adapters.inventory_mock import InventoryMockAdapter
from adapters.reviews_mock import ReviewsMockAdapter

# Example placeholders for later:
# from adapters.inventory_csv import InventoryCSVAdapter
# from adapters.reviews_google import ReviewsGoogleAdapter
# from adapters.reviews_email import ReviewsEmailAdapter

class AdapterRegistry:
    def __init__(self, flags: list[str]):
        self.flags = set(flags)

    def inventory(self) -> InventoryPort:
        # later: if "toast" in self.flags: return InventoryToastAdapter(...)
        # elif "csv" in self.flags: return InventoryCSVAdapter(path="data/inbox/inventory.csv")
        return InventoryMockAdapter()

    def reviews(self) -> ReviewsPort:
        # later:
        # if "google" in self.flags: return ReviewsGoogleAdapter(location_id=...)
        # if "email" in self.flags: return ReviewsEmailAdapter(imap_url=..., creds=...)
        return ReviewsMockAdapter()