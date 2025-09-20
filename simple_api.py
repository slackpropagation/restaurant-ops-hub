#!/usr/bin/env python3
"""
Simple API without PDF dependencies for testing
"""
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from datetime import datetime, date, timedelta
import sys
import os

# Add the project root to the Python path
sys.path.append(os.path.join(os.path.dirname(__file__), '.'))

from packages.core.database import get_db, Inventory, Review, Change, Menu, StockStatus

app = FastAPI(
    title="Restaurant Ops Hub API", 
    version="0.1.0",
    description="Centralized operations management for restaurants"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/ping")
def ping():
    """Health check endpoint"""
    return {"message": "pong", "timestamp": datetime.utcnow()}

@app.get("/health")
def health():
    return {"ok": True, "message": "API is running"}

@app.get("/api/v1/inventory")
def get_inventory(db: Session = Depends(get_db)):
    """Get current inventory status from database"""
    inventory_items = db.query(Inventory).all()
    return [
        {
            "id": item.id,
            "item_id": item.item_id,
            "status": item.status.value if hasattr(item.status, 'value') else str(item.status),
            "notes": item.notes,
            "expected_back": item.expected_back.isoformat() if item.expected_back else None,
            "updated_at": item.updated_at.isoformat() if item.updated_at else None
        }
        for item in inventory_items
    ]

@app.get("/api/v1/reviews")
def get_reviews(days: int = 7, db: Session = Depends(get_db)):
    """Get recent reviews from database"""
    cutoff_date = datetime.utcnow() - timedelta(days=days)
    reviews = db.query(Review).filter(Review.created_at >= cutoff_date).all()
    return [
        {
            "id": review.id,
            "source": review.source,
            "rating": review.rating,
            "text": review.text,
            "created_at": review.created_at.isoformat() if review.created_at else None
        }
        for review in reviews
    ]

@app.get("/api/v1/changes")
def get_changes(db: Session = Depends(get_db)):
    """Get active changes/announcements"""
    changes = db.query(Change).filter(Change.is_active == True).all()
    return [
        {
            "change_id": change.change_id,
            "title": change.title,
            "detail": change.detail,
            "effective_from": change.effective_from.isoformat() if change.effective_from else None,
            "created_by": change.created_by,
            "is_active": change.is_active,
            "created_at": change.created_at.isoformat() if change.created_at else None
        }
        for change in changes
    ]

@app.get("/api/v1/brief/today")
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
    
    return {
        "date": today.isoformat(),
        "eighty_six_items": [
            {
                "id": item.id,
                "item_id": item.item_id,
                "status": item.status.value if hasattr(item.status, 'value') else str(item.status),
                "notes": item.notes or "No notes",
                "expected_back": item.expected_back.isoformat() if item.expected_back else None,
                "updated_at": item.updated_at.isoformat() if item.updated_at else None,
                "menu_item": {
                    "item_id": item.menu_item.item_id if item.menu_item else item.item_id,
                    "name": item.menu_item.name if item.menu_item else "Unknown Item",
                    "price": item.menu_item.price if item.menu_item else 0,
                    "allergy_flags": item.menu_item.allergy_flags if item.menu_item else None,
                    "active": item.menu_item.active if item.menu_item else True
                } if item.menu_item else None
            }
            for item in eighty_six_items
        ],
        "low_stock_items": [
            {
                "id": item.id,
                "item_id": item.item_id,
                "status": item.status.value if hasattr(item.status, 'value') else str(item.status),
                "notes": item.notes or "No notes",
                "expected_back": item.expected_back.isoformat() if item.expected_back else None,
                "updated_at": item.updated_at.isoformat() if item.updated_at else None,
                "menu_item": {
                    "item_id": item.menu_item.item_id if item.menu_item else item.item_id,
                    "name": item.menu_item.name if item.menu_item else "Unknown Item",
                    "price": item.menu_item.price if item.menu_item else 0,
                    "allergy_flags": item.menu_item.allergy_flags if item.menu_item else None,
                    "active": item.menu_item.active if item.menu_item else True
                } if item.menu_item else None
            }
            for item in low_stock_items
        ],
        "recent_reviews": [
            {
                "id": review.id,
                "source": review.source,
                "rating": review.rating,
                "text": review.text or "No text",
                "created_at": review.created_at.isoformat() if review.created_at else None
            }
            for review in recent_reviews
        ],
        "changes": [
            {
                "change_id": change.change_id,
                "title": change.title,
                "detail": change.detail or "No details",
                "created_by": change.created_by,
                "created_at": change.created_at.isoformat() if change.created_at else None
            }
            for change in changes
        ],
        "generated_at": datetime.utcnow().isoformat()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
