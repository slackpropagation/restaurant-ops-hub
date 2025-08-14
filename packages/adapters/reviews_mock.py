from datetime import datetime, timedelta
from packages.core.domain import Review

def make():
    now = datetime.utcnow()
    return [
        Review("r1","google",2,"Service was slow on patio; drinks took 20 minutes.", now - timedelta(days=1), None),
        Review("r2","google",5,"Steak perfect; server was attentive.", now - timedelta(days=2), None),
        Review("r3","internal",3,"Expo backed up at 7:30; ticket times 20+ minutes.", now - timedelta(days=0), None)
    ]

class ReviewsMockAdapter:
    def fetch_recent(self, days: int = 14):
        return [r for r in make() if (datetime.utcnow()-r.created_at).days <= days]