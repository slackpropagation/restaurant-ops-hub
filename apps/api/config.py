from dataclasses import dataclass
from typing import List
import os
from dotenv import load_dotenv

# load .env if present
load_dotenv(os.path.join(os.path.dirname(__file__), ".env"), override=False)

@dataclass(frozen=True)
class Settings:
    adapters: List[str]
    next_public_api: str
    google_location_id: str | None
    imap_url: str | None
    imap_user: str | None
    imap_pass: str | None

def get_settings() -> Settings:
    adapters = [a.strip() for a in os.getenv("ADAPTERS", "mock").split(",") if a.strip()]
    return Settings(
        adapters=adapters,
        next_public_api=os.getenv("NEXT_PUBLIC_API", "http://localhost:8000"),
        google_location_id=os.getenv("GOOGLE_LOCATION_ID"),
        imap_url=os.getenv("IMAP_URL"),
        imap_user=os.getenv("IMAP_USER"),
        imap_pass=os.getenv("IMAP_PASS"),
    )