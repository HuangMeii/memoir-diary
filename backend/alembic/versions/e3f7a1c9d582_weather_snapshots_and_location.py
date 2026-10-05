"""weather snapshots and per-user location

Revision ID: e3f7a1c9d582
Revises: c1d5e7f9a204
Create Date: 2026-10-05

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'e3f7a1c9d582'
down_revision: Union[str, None] = 'c1d5e7f9a204'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column('users', sa.Column('weather_lat', sa.Float(), nullable=True))
    op.add_column('users', sa.Column('weather_lon', sa.Float(), nullable=True))
    op.add_column(
        'users',
        sa.Column('weather_location_name', sa.String(length=100), nullable=True),
    )

    op.create_table(
        'weather_snapshots',
        sa.Column('id', sa.Uuid(), nullable=False),
        sa.Column('user_id', sa.Uuid(), nullable=False),
        sa.Column('forecast_date', sa.Date(), nullable=False),
        sa.Column('weather_code', sa.SmallInteger(), nullable=False),
        sa.Column('weather_id', sa.SmallInteger(), nullable=True),
        sa.Column('temp_min', sa.Float(), nullable=True),
        sa.Column('temp_max', sa.Float(), nullable=True),
        sa.Column('temp_avg', sa.Float(), nullable=True),
        sa.Column('precipitation_mm', sa.Float(), nullable=True),
        sa.Column('fetched_at', sa.DateTime(timezone=True), nullable=False),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['weather_id'], ['weathers.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('user_id', 'forecast_date', name='uq_weather_user_date')
    )
    op.create_index(
        op.f('ix_weather_snapshots_user_id'), 'weather_snapshots', ['user_id']
    )
    op.create_index(
        op.f('ix_weather_snapshots_forecast_date'),
        'weather_snapshots',
        ['forecast_date'],
    )


def downgrade() -> None:
    op.drop_index(op.f('ix_weather_snapshots_forecast_date'), table_name='weather_snapshots')
    op.drop_index(op.f('ix_weather_snapshots_user_id'), table_name='weather_snapshots')
    op.drop_table('weather_snapshots')
    op.drop_column('users', 'weather_location_name')
    op.drop_column('users', 'weather_lon')
    op.drop_column('users', 'weather_lat')