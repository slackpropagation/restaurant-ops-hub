from fastapi import FastAPI, Query, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime, date, timedelta
import sys
import os

# Add the project root to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), '../../'))

from apps.api.config import get_settings
from apps.api.adapter_registry import AdapterRegistry
from apps.api.schemas import (
    InventoryResponse, ReviewResponse, ChangeResponse, BriefResponse,
    InventoryOut, ReviewOut, ThemeOut
)
from packages.core.services import InventoryService, ReviewService
from packages.core.database import get_db, Inventory, Review, Change, Menu, User, StockStatus

settings = get_settings()
registry = AdapterRegistry(settings.adapters)

app = FastAPI(
    title="Restaurant Ops Hub API", 
    version="0.1.0",
    description="Centralized operations management for restaurants"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173"],  # React dev servers
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Legacy services for backward compatibility
inv_svc = InventoryService(registry.inventory())
rev_svc = ReviewService(registry.reviews())

@app.get("/ping")
def ping():
    """Health check endpoint"""
    return {"message": "pong", "timestamp": datetime.utcnow()}

@app.get("/health")
def health():
    return {"ok": True, "adapters": settings.adapters}

# Legacy endpoints for backward compatibility
@app.get("/inventory", response_model=List[InventoryOut])
def get_inventory():
    return [i.__dict__ | {"status": i.status.value} for i in inv_svc.snapshot()]

@app.get("/reviews", response_model=List[ReviewOut])
def get_reviews(days: int = Query(7, ge=1, le=30)):
    return [r.__dict__ for r in rev_svc.recent(days)]

@app.get("/themes", response_model=List[ThemeOut])
def get_themes(days: int = Query(7, ge=1, le=30)):
    return [{"name": k, "count": v} for k, v in rev_svc.themes(days)]

# New database-backed endpoints
@app.get("/api/v1/inventory", response_model=List[InventoryResponse])
def get_inventory_v1(db: Session = Depends(get_db)):
    """Get current inventory status from database"""
    inventory_items = db.query(Inventory).all()
    return inventory_items

@app.get("/api/v1/reviews", response_model=List[ReviewResponse])
def get_reviews_v1(days: int = Query(7, ge=1, le=30), db: Session = Depends(get_db)):
    """Get recent reviews from database"""
    cutoff_date = datetime.utcnow() - timedelta(days=days)
    reviews = db.query(Review).filter(Review.created_at >= cutoff_date).all()
    return reviews

@app.get("/api/v1/changes", response_model=List[ChangeResponse])
def get_changes(db: Session = Depends(get_db)):
    """Get active changes/announcements"""
    changes = db.query(Change).filter(Change.is_active == True).all()
    return changes

@app.get("/api/v1/brief/today", response_model=BriefResponse)
def get_today_brief(db: Session = Depends(get_db)):
    """Generate today's pre-shift brief"""
    today = date.today()
    
    # Get 86 items
    eighty_six_items = db.query(Inventory).filter(Inventory.status == StockStatus.EIGHTY_SIX).all()
    
    # Get low stock items
    low_stock_items = db.query(Inventory).filter(Inventory.status == StockStatus.LOW).all()
    
    # Get recent reviews (last 7 days)
    cutoff_date = datetime.utcnow() - timedelta(days=7)
    recent_reviews = db.query(Review).filter(Review.created_at >= cutoff_date).all()
    
    # Get active changes
    changes = db.query(Change).filter(Change.is_active == True).all()
    
    return BriefResponse(
        date=today,
        eighty_six_items=eighty_six_items,
        low_stock_items=low_stock_items,
        recent_reviews=recent_reviews,
        changes=changes,
        generated_at=datetime.utcnow()
    )