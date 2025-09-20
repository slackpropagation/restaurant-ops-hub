#!/usr/bin/env python3
"""
Simple API without PDF dependencies for testing
"""
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response
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
                    'change_id': change.change_id,
                    'title': change.title,
                    'detail': change.detail or 'No details',
                    'created_by': change.created_by,
                    'created_at': change.created_at.isoformat()
                }
                for change in changes
            ],
            'generated_at': datetime.utcnow().isoformat()
        }
        
        # Generate PDF using a simple HTML template
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Pre-Shift Brief - {today.strftime('%B %d, %Y')}</title>
            <style>
                body {{ font-family: Arial, sans-serif; margin: 20px; }}
                .header {{ text-align: center; margin-bottom: 30px; }}
                .section {{ margin-bottom: 25px; }}
                .section h2 {{ color: #333; border-bottom: 2px solid #333; padding-bottom: 5px; }}
                .item {{ margin: 10px 0; padding: 10px; border-left: 4px solid #e74c3c; background: #f8f9fa; }}
                .low-stock {{ border-left-color: #f39c12; }}
                .review {{ margin: 10px 0; padding: 10px; border-left: 4px solid #3498db; background: #f8f9fa; }}
                .change {{ margin: 10px 0; padding: 10px; border-left: 4px solid #9b59b6; background: #f8f9fa; }}
                .no-items {{ color: #666; font-style: italic; }}
            </style>
        </head>
        <body>
            <div class="header">
                <h1>Pre-Shift Brief</h1>
                <p>Generated on {today.strftime('%B %d, %Y')} at {datetime.utcnow().strftime('%I:%M %p')}</p>
            </div>
            
            <div class="section">
                <h2>🚫 86 Items ({len(brief_data['eighty_six_items'])})</h2>
                {''.join([f'<div class="item"><strong>{item["name"]}</strong> ({item["item_id"]})<br><em>{item["notes"]}</em></div>' for item in brief_data['eighty_six_items']]) if brief_data['eighty_six_items'] else '<div class="no-items">No items are currently 86\'d</div>'}
            </div>
            
            <div class="section">
                <h2>⚠️ Low Stock Items ({len(brief_data['low_stock_items'])})</h2>
                {''.join([f'<div class="item low-stock"><strong>{item["name"]}</strong> ({item["item_id"]})<br><em>{item["notes"]}</em></div>' for item in brief_data['low_stock_items']]) if brief_data['low_stock_items'] else '<div class="no-items">All items are well stocked</div>'}
            </div>
            
            <div class="section">
                <h2>⭐ Recent Reviews ({len(brief_data['recent_reviews'])})</h2>
                {''.join([f'<div class="review"><strong>{review["source"]}</strong> - {"⭐" * review["rating"]}<br>{review["text"]}<br><small>{review["created_at"]}</small></div>' for review in brief_data['recent_reviews']]) if brief_data['recent_reviews'] else '<div class="no-items">No recent reviews</div>'}
            </div>
            
            <div class="section">
                <h2>📢 Changes & Announcements ({len(brief_data['changes'])})</h2>
                {''.join([f'<div class="change"><strong>{change["title"]}</strong><br>{change["detail"]}<br><small>By {change["created_by"]} on {change["created_at"]}</small></div>' for change in brief_data['changes']]) if brief_data['changes'] else '<div class="no-items">No active changes</div>'}
            </div>
        </body>
        </html>
        """
        
        # For now, return the HTML content as a simple text response
        # In a real implementation, you'd use WeasyPrint or similar to generate actual PDF
        return Response(
            content=html_content,
            media_type="text/html",
            headers={
                "Content-Disposition": f"attachment; filename=pre-shift-brief-{today.isoformat()}.html"
            }
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate PDF: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
