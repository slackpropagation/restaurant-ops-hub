import time
from datetime import datetime

if __name__ == "__main__":
    while True:
        print(datetime.utcnow(), "tick; run scheduled ingestions")
        # pos_ingest(); review_ingest(); schedule_ingest()
        time.sleep(300)