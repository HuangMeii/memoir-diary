"""add user role

Adds `users.role` so the quote library (kho câu) can be curated by an admin
account instead of every user.

Revision ID: 8f3c1d2b4a57
Revises: a2cf6f516ed4
Create Date: 2026-10-05

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '8f3c1d2b4a57'
down_revision: Union[str, None] = 'a2cf6f516ed4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # server_default first: the 7 existing rows must not violate NOT NULL.
    op.add_column(
        'users',
        sa.Column(
            'role',
            sa.String(length=20),
            nullable=False,
            server_default='user',
        ),
    )
    op.create_index(op.f('ix_users_role'), 'users', ['role'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_users_role'), table_name='users')
    op.drop_column('users', 'role')