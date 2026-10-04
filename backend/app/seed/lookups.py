"""Reference data for the moods and weathers lookup tables.

5 moods and 5 weathers, matching `docs/07-ui-design.md`.
Weather #5 is "khác" (other) per the product requirement.
"""

from typing import TypedDict


class LookupSeed(TypedDict):
    id: int
    code: str
    label_vi: str
    color_hex: str
    icon: str
    sort_order: int


# NOTE: ids are assigned explicitly because `moods.id` / `weathers.id` are
# SmallInteger columns, which do not auto-increment on PostgreSQL/SQLite.
# These are static reference tables, so stable ids are safe and desirable.
MOODS: list[LookupSeed] = [
    {"id": 1, "code": "happy", "label_vi": "Vui", "color_hex": "#FFD93D", "icon": "😀", "sort_order": 1},
    {"id": 2, "code": "sad", "label_vi": "Buồn", "color_hex": "#4A90D9", "icon": "😢", "sort_order": 2},
    {"id": 3, "code": "bored", "label_vi": "Chán", "color_hex": "#9E9E9E", "icon": "😑", "sort_order": 3},
    {"id": 4, "code": "neutral", "label_vi": "Bình thường", "color_hex": "#A8D5BA", "icon": "😐", "sort_order": 4},
    {"id": 5, "code": "angry", "label_vi": "Giận", "color_hex": "#E74C3C", "icon": "😠", "sort_order": 5},
]

WEATHERS: list[LookupSeed] = [
    {"id": 1, "code": "sunny", "label_vi": "Nắng", "color_hex": "#FFB300", "icon": "☀️", "sort_order": 1},
    {"id": 2, "code": "cloudy", "label_vi": "Râm", "color_hex": "#90A4AE", "icon": "⛅", "sort_order": 2},
    {"id": 3, "code": "rainy", "label_vi": "Mưa", "color_hex": "#5C9EDB", "icon": "🌧️", "sort_order": 3},
    {"id": 4, "code": "storm", "label_vi": "Bão", "color_hex": "#37474F", "icon": "⛈️", "sort_order": 4},
    {"id": 5, "code": "other", "label_vi": "Khác", "color_hex": "#78909C", "icon": "❔", "sort_order": 5},
]