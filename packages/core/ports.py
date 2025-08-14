from typing import List, Protocol
from .domain import InventoryItem, Review

class InventoryPort(Protocol):
    def fetch_current(self) -> List[InventoryItem]: ...

class ReviewsPort(Protocol):
    def fetch_recent(self, days: int = 14) -> List[Review]: ...

class SchedulePort(Protocol):
    def fetch_shifts(self, day_offset: int = 0): ...

class POSPort(Protocol):
    def fetch_ticket_times(self, since_hours: int = 24): ...