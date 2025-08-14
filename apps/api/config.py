from dataclasses import dataclass
from typing import List, Optional
import os
from dotenv import load_dotenv

# Load local .env if present
ENV_PATH = os.path.join(os.path.dirname(__file__), ".env")
if os.path.exists(ENV_PATH):
    load_dotenv(ENV_PATH, override=False)

@dataclass(frozen=True)
class Settings:
    adapters: List[str]
    next_public_api: str
    google_location_id: Optional[str]
    imap_url: Optional[str]
    imap_user: Optional[str]
    imap_pass: Optional[str]

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