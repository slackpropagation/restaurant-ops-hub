# packages/core/database.py
from sqlalchemy import create_engine, Column, String, Integer, DateTime, Date, Boolean, Text, ForeignKey, Enum
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from sqlalchemy.dialects.postgresql import UUID
from datetime import datetime, date
from enum import Enum as PyEnum
import uuid

Base = declarative_base()

class UserRole(str, PyEnum):
    MANAGER = "manager"
    STAFF = "staff"
    ADMIN = "admin"

class StockStatus(str, PyEnum):
    OK = "ok"
    LOW = "low"
    EIGHTY_SIX = "86"

class Menu(Base):
    __tablename__ = "menus"
    
    item_id = Column(String, primary_key=True)
    name = Column(String, nullable=False)
    price = Column(Integer)  # Price in cents
    allergy_flags = Column(Text)  # JSON string of allergy flags
    active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    inventory_items = relationship("Inventory", back_populates="menu_item")

class Inventory(Base):
    __tablename__ = "inventory"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    item_id = Column(String, ForeignKey("menus.item_id"), nullable=False)
    status = Column(Enum(StockStatus), nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    notes = Column(Text)
    expected_back = Column(Date)
    
    # Relationships
    menu_item = relationship("Menu", back_populates="inventory_items")

class Review(Base):
    __tablename__ = "reviews"
    
    review_id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    source = Column(String, nullable=False)  # "google", "yelp", etc.
    rating = Column(Integer, nullable=False)
    text = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    theme = Column(String)  # Extracted theme from sentiment analysis
    url = Column(String)
    
class Change(Base):
    __tablename__ = "changes"
    
    change_id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    title = Column(String, nullable=False)
    detail = Column(Text)
    effective_from = Column(DateTime, default=datetime.utcnow)
    created_by = Column(String, ForeignKey("users.user_id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    is_active = Column(Boolean, default=True)
    
    # Relationships
    creator = relationship("User", back_populates="created_changes")
    acknowledgements = relationship("Acknowledgement", back_populates="change")

class Shift(Base):
    __tablename__ = "shifts"
    
    shift_id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    starts = Column(DateTime, nullable=False)
    ends = Column(DateTime, nullable=False)
    role = Column(String, nullable=False)
    employee = Column(String, ForeignKey("users.user_id"), nullable=False)
    section = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="shifts")

class User(Base):
    __tablename__ = "users"
    
    user_id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    role = Column(Enum(UserRole), nullable=False)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False)
    phone = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active = Column(Boolean, default=True)
    
    # Relationships
    created_changes = relationship("Change", back_populates="creator")
    shifts = relationship("Shift", back_populates="user")
    acknowledgements = relationship("Acknowledgement", back_populates="user")

class Acknowledgement(Base):
    __tablename__ = "acknowledgements"
    
    ack_id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String, ForeignKey("users.user_id"), nullable=False)
    change_id = Column(String, ForeignKey("changes.change_id"), nullable=False)
    acknowledged_at = Column(DateTime, default=datetime.utcnow)
    
    # Relationships
    user = relationship("User", back_populates="acknowledgements")
    change = relationship("Change", back_populates="acknowledgements")

# Database connection setup
def get_database_url():
    import os
    from dotenv import load_dotenv
    load_dotenv()
    
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432")
    db_name = os.getenv("DB_NAME", "restaurant_ops")
    db_user = os.getenv("DB_USER", "postgres")
    db_password = os.getenv("DB_PASSWORD", "postgres")
    
    return f"postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

def create_engine_and_session():
    engine = create_engine(get_database_url())
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    return engine, SessionLocal

def get_db():
    """Dependency to get database session"""
    engine, SessionLocal = create_engine_and_session()
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
