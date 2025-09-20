from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime, date
from enum import Enum

class UserRole(str, Enum):
    MANAGER = "manager"
    STAFF = "staff"
    ADMIN = "admin"

class StockStatus(str, Enum):
    OK = "ok"
    LOW = "low"
    EIGHTY_SIX = "86"

# Base schemas
class MenuBase(BaseModel):
    name: str
    price: int  # Price in cents
    allergy_flags: Optional[str] = None
    active: bool = True

class MenuCreate(MenuBase):
    item_id: str

class MenuResponse(MenuBase):
    item_id: str
    created_at: datetime
    updated_at: datetime

class InventoryBase(BaseModel):
    status: StockStatus
    notes: Optional[str] = None
    expected_back: Optional[date] = None

class InventoryCreate(InventoryBase):
    item_id: str

class InventoryResponse(InventoryBase):
    id: int
    item_id: str
    updated_at: datetime
    menu_item: Optional[MenuResponse] = None

class ReviewBase(BaseModel):
    source: str
    rating: int
    text: str
    theme: Optional[str] = None
    url: Optional[str] = None

class ReviewCreate(ReviewBase):
    pass

class ReviewResponse(ReviewBase):
    review_id: str
    created_at: datetime

class ChangeBase(BaseModel):
    title: str
    detail: Optional[str] = None
    effective_from: Optional[datetime] = None

class ChangeCreate(ChangeBase):
    pass

class ChangeResponse(ChangeBase):
    change_id: str
    created_by: str
    created_at: datetime
    is_active: bool

class UserBase(BaseModel):
    name: str
    email: EmailStr
    phone: Optional[str] = None
    role: UserRole

class UserCreate(UserBase):
    pass

class UserResponse(UserBase):
    user_id: str
    created_at: datetime
    updated_at: datetime
    is_active: bool

class ShiftBase(BaseModel):
    starts: datetime
    ends: datetime
    role: str
    section: Optional[str] = None

class ShiftCreate(ShiftBase):
    employee: str

class ShiftResponse(ShiftBase):
    shift_id: str
    employee: str
    created_at: datetime

class AcknowledgementBase(BaseModel):
    user_id: str
    change_id: str

class AcknowledgementCreate(AcknowledgementBase):
    pass

class AcknowledgementResponse(AcknowledgementBase):
    ack_id: str
    acknowledged_at: datetime

# Brief schemas
class BriefResponse(BaseModel):
    date: date
    eighty_six_items: List[InventoryResponse]
    low_stock_items: List[InventoryResponse]
    recent_reviews: List[ReviewResponse]
    changes: List[ChangeResponse]
    generated_at: datetime

# Legacy schemas for backward compatibility
class InventoryOut(BaseModel):
    item_id: str
    name: str
    status: str
    expected_back: Optional[str] = None
    notes: str

class ReviewOut(BaseModel):
    review_id: str
    source: str
    rating: int
    text: str
    created_at: str
    url: Optional[str] = None

class ThemeOut(BaseModel):
    name: str
    count: int