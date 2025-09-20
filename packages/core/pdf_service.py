# packages/core/pdf_service.py
from datetime import datetime, date
from typing import List, Dict, Any
from weasyprint import HTML, CSS
from weasyprint.text.fonts import FontConfiguration
import io
import base64

class PDFService:
    """Service for generating PDF documents"""
    
    def __init__(self):
        self.font_config = FontConfiguration()
    
    def generate_brief_pdf(self, brief_data: Dict[str, Any]) -> bytes:
        """Generate a PDF for the pre-shift brief"""
        
        html_content = self._create_brief_html(brief_data)
        css_content = self._get_brief_css()
        
        # Create HTML document
        html_doc = HTML(string=html_content)
        css_doc = CSS(string=css_content, font_config=self.font_config)
        
        # Generate PDF
        pdf_bytes = html_doc.write_pdf(stylesheets=[css_doc])
        
        return pdf_bytes
    
    def _create_brief_html(self, brief_data: Dict[str, Any]) -> str:
        """Create HTML content for the brief"""
        
        date_str = brief_data.get('date', date.today().strftime('%Y-%m-%d'))
        generated_at = brief_data.get('generated_at', datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
        
        eighty_six_items = brief_data.get('eighty_six_items', [])
        low_stock_items = brief_data.get('low_stock_items', [])
        recent_reviews = brief_data.get('recent_reviews', [])
        changes = brief_data.get('changes', [])
        
        html = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <title>Pre-Shift Brief - {date_str}</title>
        </head>
        <body>
            <div class="header">
                <h1>🍽️ Restaurant Ops Hub</h1>
                <h2>Pre-Shift Brief - {date_str}</h2>
                <p class="generated">Generated: {generated_at}</p>
            </div>
            
            <div class="content">
                {self._create_86_section(eighty_six_items)}
                {self._create_low_stock_section(low_stock_items)}
                {self._create_reviews_section(recent_reviews)}
                {self._create_changes_section(changes)}
            </div>
            
            <div class="footer">
                <p>Restaurant Ops Hub - Pre-Shift Brief</p>
            </div>
        </body>
        </html>
        """
        
        return html
    
    def _create_86_section(self, items: List[Dict]) -> str:
        """Create HTML for 86 items section"""
        if not items:
            return """
            <div class="section">
                <h3 class="section-title success">✅ 86 Items (0)</h3>
                <p class="no-items">No items are currently 86'd</p>
            </div>
            """
        
        items_html = ""
        for item in items:
            items_html += f"""
            <div class="item-card danger">
                <div class="item-name">{item.get('name', 'Unknown Item')}</div>
                <div class="item-id">{item.get('item_id', 'N/A')}</div>
                <div class="item-notes">{item.get('notes', 'No notes')}</div>
            </div>
            """
        
        return f"""
        <div class="section">
            <h3 class="section-title danger">🚫 86 Items ({len(items)})</h3>
            <div class="items-grid">
                {items_html}
            </div>
        </div>
        """
    
    def _create_low_stock_section(self, items: List[Dict]) -> str:
        """Create HTML for low stock items section"""
        if not items:
            return """
            <div class="section">
                <h3 class="section-title success">✅ Low Stock Items (0)</h3>
                <p class="no-items">All items are well stocked</p>
            </div>
            """
        
        items_html = ""
        for item in items:
            items_html += f"""
            <div class="item-card warning">
                <div class="item-name">{item.get('name', 'Unknown Item')}</div>
                <div class="item-id">{item.get('item_id', 'N/A')}</div>
                <div class="item-notes">{item.get('notes', 'No notes')}</div>
            </div>
            """
        
        return f"""
        <div class="section">
            <h3 class="section-title warning">⚠️ Low Stock Items ({len(items)})</h3>
            <div class="items-grid">
                {items_html}
            </div>
        </div>
        """
    
    def _create_reviews_section(self, reviews: List[Dict]) -> str:
        """Create HTML for reviews section"""
        if not reviews:
            return """
            <div class="section">
                <h3 class="section-title">📝 Recent Reviews (0)</h3>
                <p class="no-items">No recent reviews</p>
            </div>
            """
        
        reviews_html = ""
        for review in reviews:
            rating = review.get('rating', 0)
            stars = "★" * rating + "☆" * (5 - rating)
            created_at = review.get('created_at', '')
            if created_at:
                try:
                    dt = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
                    created_at = dt.strftime('%Y-%m-%d %H:%M')
                except:
                    pass
            
            reviews_html += f"""
            <div class="review-card">
                <div class="review-header">
                    <div class="stars">{stars}</div>
                    <div class="source">{review.get('source', 'Unknown')}</div>
                    <div class="date">{created_at}</div>
                </div>
                <div class="review-text">{review.get('text', 'No text')}</div>
            </div>
            """
        
        return f"""
        <div class="section">
            <h3 class="section-title">📝 Recent Reviews ({len(reviews)})</h3>
            <div class="reviews-list">
                {reviews_html}
            </div>
        </div>
        """
    
    def _create_changes_section(self, changes: List[Dict]) -> str:
        """Create HTML for changes section"""
        if not changes:
            return """
            <div class="section">
                <h3 class="section-title">📢 Changes & Announcements (0)</h3>
                <p class="no-items">No active changes</p>
            </div>
            """
        
        changes_html = ""
        for change in changes:
            created_at = change.get('created_at', '')
            if created_at:
                try:
                    dt = datetime.fromisoformat(created_at.replace('Z', '+00:00'))
                    created_at = dt.strftime('%Y-%m-%d %H:%M')
                except:
                    pass
            
            changes_html += f"""
            <div class="change-card">
                <div class="change-title">{change.get('title', 'Untitled')}</div>
                <div class="change-detail">{change.get('detail', 'No details')}</div>
                <div class="change-meta">
                    <span class="created-by">By {change.get('created_by', 'Unknown')}</span>
                    <span class="created-at">{created_at}</span>
                </div>
            </div>
            """
        
        return f"""
        <div class="section">
            <h3 class="section-title">📢 Changes & Announcements ({len(changes)})</h3>
            <div class="changes-list">
                {changes_html}
            </div>
        </div>
        """
    
    def _get_brief_css(self) -> str:
        """Get CSS styles for the brief"""
        return """
        @page {
            size: A4;
            margin: 1in;
        }
        
        body {
            font-family: 'Helvetica', 'Arial', sans-serif;
            line-height: 1.6;
            color: #333;
            margin: 0;
            padding: 0;
        }
        
        .header {
            text-align: center;
            border-bottom: 3px solid #2563eb;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #2563eb;
            margin: 0;
            font-size: 28px;
        }
        
        .header h2 {
            color: #374151;
            margin: 10px 0;
            font-size: 24px;
        }
        
        .generated {
            color: #6b7280;
            font-size: 14px;
            margin: 0;
        }
        
        .content {
            margin-bottom: 30px;
        }
        
        .section {
            margin-bottom: 30px;
            page-break-inside: avoid;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            padding: 10px;
            border-radius: 5px;
        }
        
        .section-title.danger {
            background-color: #fef2f2;
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }
        
        .section-title.warning {
            background-color: #fffbeb;
            color: #d97706;
            border-left: 4px solid #d97706;
        }
        
        .section-title.success {
            background-color: #f0fdf4;
            color: #16a34a;
            border-left: 4px solid #16a34a;
        }
        
        .section-title:not(.danger):not(.warning):not(.success) {
            background-color: #f3f4f6;
            color: #374151;
            border-left: 4px solid #6b7280;
        }
        
        .no-items {
            color: #6b7280;
            font-style: italic;
            margin: 10px 0;
        }
        
        .items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 15px;
        }
        
        .item-card {
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }
        
        .item-card.danger {
            background-color: #fef2f2;
            border-color: #fecaca;
        }
        
        .item-card.warning {
            background-color: #fffbeb;
            border-color: #fed7aa;
        }
        
        .item-name {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .item-id {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .item-notes {
            color: #374151;
            font-size: 14px;
        }
        
        .reviews-list, .changes-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .review-card, .change-card {
            padding: 15px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            background-color: #f9fafb;
        }
        
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .stars {
            color: #fbbf24;
            font-size: 16px;
        }
        
        .source, .date {
            color: #6b7280;
            font-size: 14px;
        }
        
        .review-text {
            color: #374151;
            font-size: 14px;
        }
        
        .change-title {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 8px;
            color: #374151;
        }
        
        .change-detail {
            color: #4b5563;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .change-meta {
            display: flex;
            justify-content: space-between;
            color: #6b7280;
            font-size: 12px;
        }
        
        .footer {
            text-align: center;
            color: #6b7280;
            font-size: 12px;
            border-top: 1px solid #e5e7eb;
            padding-top: 20px;
            margin-top: 30px;
        }
        """
