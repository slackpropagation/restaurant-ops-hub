from datetime import datetime, timedelta, date
from packages.core.domain import InventoryItem, StockStatus

def make():
    now = datetime.utcnow()
    return [
        InventoryItem("i1","Branzino", StockStatus.EIGHTY_SIX, now.date()+timedelta(days=2), "Supplier delay", now),
        InventoryItem("i2","Assyrtiko", StockStatus.LOW, now.date()+timedelta(days=1), "8 bottles left", now),
        InventoryItem("i3","Hummus", StockStatus.OK, None, "", now)
    ]

class InventoryMockAdapter:
    def fetch_current(self):
        return make()