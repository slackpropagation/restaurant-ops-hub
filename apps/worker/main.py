import time, os
from datetime import datetime
# In the future; swap mocks for real adapters based on ENV flags
ADAPTERS = os.getenv("ADAPTERS","mock").split(",")

while True:
    print(datetime.utcnow(),"tick; run scheduled ingestions")
    # pos_ingest(); review_ingest(); schedule_ingest()
    time.sleep(300)