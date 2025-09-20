from fastapi import FastAPI, Query, Depends, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response
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
    InventoryOut, ReviewOut, ThemeOut, InventoryCreate, MenuCreate, 
    ChangeCreate, MenuResponse
)
from packages.core.services import InventoryService, ReviewService
from packages.core.database import get_db, Inventory, Review, Change, Menu, User, StockStatus
from packages.core.pdf_service import PDFService

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

@app.get("/api/v1/brief/today/pdf")
def get_today_brief_pdf(db: Session = Depends(get_db)):
    """Generate and download today's pre-shift brief as PDF"""
    try:
        # Get brief data (same as the JSON endpoint)
        today = date.today()
        
        eighty_six_items = db.query(Inventory).filter(Inventory.status == StockStatus.EIGHTY_SIX).all()
        low_stock_items = db.query(Inventory).filter(Inventory.status == StockStatus.LOW).all()
        cutoff_date = datetime.utcnow() - timedelta(days=7)
        recent_reviews = db.query(Review).filter(Review.created_at >= cutoff_date).all()
        changes = db.query(Change).filter(Change.is_active == True).all()
        
        # Convert to dictionaries for PDF generation
        brief_data = {
            'date': today.isoformat(),
            'eighty_six_items': [
                {
                    'name': item.menu_item.name if item.menu_item else 'Unknown Item',
                    'item_id': item.item_id,
                    'notes': item.notes or 'No notes'
                }
                for item in eighty_six_items
            ],
            'low_stock_items': [
                {
                    'name': item.menu_item.name if item.menu_item else 'Unknown Item',
                    'item_id': item.item_id,
                    'notes': item.notes or 'No notes'
                }
                for item in low_stock_items
            ],
            'recent_reviews': [
                {
                    'source': review.source,
                    'rating': review.rating,
                    'text': review.text or 'No text',
                    'created_at': review.created_at.isoformat()
                }
                for review in recent_reviews
            ],
            'changes': [
                {
                    'title': change.title,
                    'detail': change.detail or 'No details',
                    'created_by': change.created_by,
                    'created_at': change.created_at.isoformat()
                }
                for change in changes
            ],
            'generated_at': datetime.utcnow().isoformat()
        }
        
        # Generate PDF
        pdf_service = PDFService()
        pdf_bytes = pdf_service.generate_brief_pdf(brief_data)
        
        # Return PDF response
        return Response(
            content=pdf_bytes,
            media_type="application/pdf",
            headers={
                "Content-Disposition": f"attachment; filename=pre-shift-brief-{today.isoformat()}.pdf"
            }
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate PDF: {str(e)}")

# Inventory CRUD endpoints
@app.post("/api/v1/inventory", response_model=InventoryResponse)
def create_inventory_item(item: InventoryCreate, db: Session = Depends(get_db)):
    """Create a new inventory item"""
    # Check if menu item exists
    menu_item = db.query(Menu).filter(Menu.item_id == item.item_id).first()
    if not menu_item:
        raise HTTPException(status_code=404, detail="Menu item not found")
    
    # Create inventory item
    db_item = Inventory(
        item_id=item.item_id,
        status=item.status,
        notes=item.notes,
        expected_back=item.expected_back
    )
    
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    
    return db_item

@app.put("/api/v1/inventory/{item_id}", response_model=InventoryResponse)
def update_inventory_item(item_id: int, item: InventoryCreate, db: Session = Depends(get_db)):
    """Update an inventory item"""
    db_item = db.query(Inventory).filter(Inventory.id == item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Inventory item not found")
    
    # Check if menu item exists
    menu_item = db.query(Menu).filter(Menu.item_id == item.item_id).first()
    if not menu_item:
        raise HTTPException(status_code=404, detail="Menu item not found")
    
    # Update inventory item
    db_item.item_id = item.item_id
    db_item.status = item.status
    db_item.notes = item.notes
    db_item.expected_back = item.expected_back
    db_item.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(db_item)
    
    return db_item

@app.delete("/api/v1/inventory/{item_id}")
def delete_inventory_item(item_id: int, db: Session = Depends(get_db)):
    """Delete an inventory item"""
    db_item = db.query(Inventory).filter(Inventory.id == item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Inventory item not found")
    
    db.delete(db_item)
    db.commit()
    
    return {"message": "Inventory item deleted successfully"}

@app.post("/api/v1/inventory/upload")
def upload_inventory_csv(file: UploadFile = File(...), db: Session = Depends(get_db)):
    """Upload CSV file to update inventory"""
    if not file.filename.endswith('.csv'):
        raise HTTPException(status_code=400, detail="File must be a CSV")
    
    try:
        # Read CSV content
        content = file.file.read().decode('utf-8')
        lines = content.strip().split('\n')
        
        # Skip header row
        data_lines = lines[1:] if len(lines) > 1 else []
        
        updated_count = 0
        for line in data_lines:
            if not line.strip():
                continue
                
            parts = line.split(',')
            if len(parts) >= 2:
                item_id = parts[0].strip()
                status_str = parts[1].strip().lower()
                
                # Map status string to enum
                status_mapping = {
                    'ok': StockStatus.OK,
                    'low': StockStatus.LOW,
                    '86': StockStatus.EIGHTY_SIX,
                    'eighty_six': StockStatus.EIGHTY_SIX
                }
                
                status = status_mapping.get(status_str, StockStatus.OK)
                notes = parts[2].strip() if len(parts) > 2 else None
                
                # Find or create inventory item
                inventory_item = db.query(Inventory).filter(Inventory.item_id == item_id).first()
                if inventory_item:
                    inventory_item.status = status
                    inventory_item.notes = notes
                    inventory_item.updated_at = datetime.utcnow()
                else:
                    inventory_item = Inventory(
                        item_id=item_id,
                        status=status,
                        notes=notes
                    )
                    db.add(inventory_item)
                
                updated_count += 1
        
        db.commit()
        return {"message": f"Successfully updated {updated_count} inventory items"}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to process CSV: {str(e)}")

# Menu CRUD endpoints
@app.get("/api/v1/menu", response_model=List[MenuResponse])
def get_menu_items(db: Session = Depends(get_db)):
    """Get all menu items"""
    menu_items = db.query(Menu).all()
    return menu_items

@app.post("/api/v1/menu", response_model=MenuResponse)
def create_menu_item(item: MenuCreate, db: Session = Depends(get_db)):
    """Create a new menu item"""
    # Check if item already exists
    existing_item = db.query(Menu).filter(Menu.item_id == item.item_id).first()
    if existing_item:
        raise HTTPException(status_code=400, detail="Menu item with this ID already exists")
    
    db_item = Menu(
        item_id=item.item_id,
        name=item.name,
        price=item.price,
        allergy_flags=item.allergy_flags,
        active=item.active
    )
    
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    
    return db_item

@app.put("/api/v1/menu/{item_id}", response_model=MenuResponse)
def update_menu_item(item_id: str, item: MenuCreate, db: Session = Depends(get_db)):
    """Update a menu item"""
    db_item = db.query(Menu).filter(Menu.item_id == item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Menu item not found")
    
    db_item.name = item.name
    db_item.price = item.price
    db_item.allergy_flags = item.allergy_flags
    db_item.active = item.active
    db_item.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(db_item)
    
    return db_item

@app.delete("/api/v1/menu/{item_id}")
def delete_menu_item(item_id: str, db: Session = Depends(get_db)):
    """Delete a menu item"""
    db_item = db.query(Menu).filter(Menu.item_id == item_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Menu item not found")
    
    # Check if there are inventory items for this menu item
    inventory_items = db.query(Inventory).filter(Inventory.item_id == item_id).count()
    if inventory_items > 0:
        raise HTTPException(status_code=400, detail="Cannot delete menu item with existing inventory records")
    
    db.delete(db_item)
    db.commit()
    
    return {"message": "Menu item deleted successfully"}

# Changes CRUD endpoints
@app.post("/api/v1/changes", response_model=ChangeResponse)
def create_change(change: ChangeCreate, db: Session = Depends(get_db)):
    """Create a new change/announcement"""
    # For now, use a default user ID. In a real app, this would come from authentication
    created_by = "user-1"  # Default manager user
    
    db_item = Change(
        title=change.title,
        detail=change.detail,
        effective_from=change.effective_from or datetime.utcnow(),
        created_by=created_by,
        is_active=True
    )
    
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    
    return db_item

@app.put("/api/v1/changes/{change_id}", response_model=ChangeResponse)
def update_change(change_id: str, change: ChangeCreate, db: Session = Depends(get_db)):
    """Update a change/announcement"""
    db_item = db.query(Change).filter(Change.change_id == change_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Change not found")
    
    db_item.title = change.title
    db_item.detail = change.detail
    db_item.effective_from = change.effective_from or db_item.effective_from
    
    db.commit()
    db.refresh(db_item)
    
    return db_item

@app.delete("/api/v1/changes/{change_id}")
def delete_change(change_id: str, db: Session = Depends(get_db)):
    """Delete a change/announcement"""
    db_item = db.query(Change).filter(Change.change_id == change_id).first()
    if not db_item:
        raise HTTPException(status_code=404, detail="Change not found")
    
    db.delete(db_item)
    db.commit()
    
    return {"message": "Change deleted successfully"}