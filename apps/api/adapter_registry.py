from typing import List
from packages.core.ports import InventoryPort, ReviewsPort
from packages.adapters.inventory_mock import InventoryMockAdapter
from packages.adapters.reviews_mock import ReviewsMockAdapter
# Placeholders for future real adapters:
# from adapters.inventory_csv import InventoryCSVAdapter
# from adapters.reviews_google import ReviewsGoogleAdapter
# from adapters.reviews_email import ReviewsEmailAdapter

class AdapterRegistry:
    def __init__(self, flags: List[str]):
        self.flags = set(f.strip().lower() for f in flags)

    def inventory(self) -> InventoryPort:
        # if "csv" in self.flags: return InventoryCSVAdapter(path="data/inbox/inventory.csv")
        # if "toast" in self.flags: return InventoryToastAdapter(...)
        return InventoryMockAdapter()

    def reviews(self) -> ReviewsPort:
        # if "google" in self.flags: return ReviewsGoogleAdapter(location_id=...)
        # if "email" in self.flags: return ReviewsEmailAdapter(...)
        return ReviewsMockAdapter()