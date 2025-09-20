"""Initial migration - create all tables

Revision ID: 001_initial
Revises: 
Create Date: 2024-01-15 16:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '001_initial'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create users table
    op.create_table('users',
        sa.Column('user_id', sa.String(), nullable=False),
        sa.Column('role', sa.Enum('manager', 'staff', 'admin', name='userrole'), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('email', sa.String(), nullable=False),
        sa.Column('phone', sa.String(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=True),
        sa.PrimaryKeyConstraint('user_id'),
        sa.UniqueConstraint('email')
    )

    # Create menus table
    op.create_table('menus',
        sa.Column('item_id', sa.String(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('price', sa.Integer(), nullable=True),
        sa.Column('allergy_flags', sa.Text(), nullable=True),
        sa.Column('active', sa.Boolean(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint('item_id')
    )

    # Create inventory table
    op.create_table('inventory',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('item_id', sa.String(), nullable=False),
        sa.Column('status', sa.Enum('ok', 'low', '86', name='stockstatus'), nullable=False),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.Column('notes', sa.Text(), nullable=True),
        sa.Column('expected_back', sa.Date(), nullable=True),
        sa.ForeignKeyConstraint(['item_id'], ['menus.item_id'], ),
        sa.PrimaryKeyConstraint('id')
    )

    # Create reviews table
    op.create_table('reviews',
        sa.Column('review_id', sa.String(), nullable=False),
        sa.Column('source', sa.String(), nullable=False),
        sa.Column('rating', sa.Integer(), nullable=False),
        sa.Column('text', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('theme', sa.String(), nullable=True),
        sa.Column('url', sa.String(), nullable=True),
        sa.PrimaryKeyConstraint('review_id')
    )

    # Create changes table
    op.create_table('changes',
        sa.Column('change_id', sa.String(), nullable=False),
        sa.Column('title', sa.String(), nullable=False),
        sa.Column('detail', sa.Text(), nullable=True),
        sa.Column('effective_from', sa.DateTime(), nullable=True),
        sa.Column('created_by', sa.String(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('is_active', sa.Boolean(), nullable=True),
        sa.ForeignKeyConstraint(['created_by'], ['users.user_id'], ),
        sa.PrimaryKeyConstraint('change_id')
    )

    # Create shifts table
    op.create_table('shifts',
        sa.Column('shift_id', sa.String(), nullable=False),
        sa.Column('starts', sa.DateTime(), nullable=False),
        sa.Column('ends', sa.DateTime(), nullable=False),
        sa.Column('role', sa.String(), nullable=False),
        sa.Column('employee', sa.String(), nullable=False),
        sa.Column('section', sa.String(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['employee'], ['users.user_id'], ),
        sa.PrimaryKeyConstraint('shift_id')
    )

    # Create acknowledgements table
    op.create_table('acknowledgements',
        sa.Column('ack_id', sa.String(), nullable=False),
        sa.Column('user_id', sa.String(), nullable=False),
        sa.Column('change_id', sa.String(), nullable=False),
        sa.Column('acknowledged_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['change_id'], ['changes.change_id'], ),
        sa.ForeignKeyConstraint(['user_id'], ['users.user_id'], ),
        sa.PrimaryKeyConstraint('ack_id')
    )


def downgrade() -> None:
    op.drop_table('acknowledgements')
    op.drop_table('shifts')
    op.drop_table('changes')
    op.drop_table('reviews')
    op.drop_table('inventory')
    op.drop_table('menus')
    op.drop_table('users')
    
    # Drop enums
    op.execute('DROP TYPE IF EXISTS stockstatus')
    op.execute('DROP TYPE IF EXISTS userrole')
