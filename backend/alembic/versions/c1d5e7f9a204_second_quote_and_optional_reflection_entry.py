"""allow a second quote and an optional entry on reflections

daily_quotes gains `quote_id_2` so a day that showed two library quotes
(used when the user has too few self messages to pair up) can be looked
back on. reflections.entry_id becomes nullable so a thought can be
saved straight from the quote card, without a diary entry.

Revision ID: c1d5e7f9a204
Revises: 8f3c1d2b4a57
Create Date: 2026-10-05

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'c1d5e7f9a204'
down_revision: Union[str, None] = '8f3c1d2b4a57'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        'daily_quotes',
        sa.Column('quote_id_2', sa.Uuid(), nullable=True),
    )
    op.create_foreign_key(
        'fk_daily_quotes_quote_id_2',
        'daily_quotes',
        'quotes',
        ['quote_id_2'],
        ['id'],
        ondelete='SET NULL',
    )
    # Existing rows keep their entry; the column only becomes optional.
    op.alter_column(
        'reflections',
        'entry_id',
        existing_type=sa.Uuid(),
        nullable=True,
    )


def downgrade() -> None:
    op.alter_column(
        'reflections',
        'entry_id',
        existing_type=sa.Uuid(),
        nullable=False,
    )
    op.drop_constraint('fk_daily_quotes_quote_id_2', 'daily_quotes', type_='foreignkey')
    op.drop_column('daily_quotes', 'quote_id_2')