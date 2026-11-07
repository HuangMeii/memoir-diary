/// Formatting helpers for the "Đi chợ thông minh" screen.
///
/// Nguồn thiết kế: `ui-figma/dicho/memoir_i_ch_th_ng_minh_y_chu_i_si_u_th` —
/// every amount and distance in the frame is printed the same way.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/dicho_shopping.dart';

final NumberFormat _vnd = NumberFormat.decimalPattern('vi');

/// "353.000 đ" — the grouping the design uses for money.
String formatVnd(int amount) => '${_vnd.format(amount)} đ';

/// "450 m" below one kilometre, "1.8 km" above it, as in the store tiles.
String formatDistance(double kilometres) => kilometres < 1
    ? '${(kilometres * 1000).round()} m'
    : '${kilometres.toStringAsFixed(1)} km';

/// "8 phút" — the second half of the store tile caption.
String formatMinutes(int minutes) => '$minutes phút';

/// Icon of a basket row, the Material stand-in for the design's Symbols
/// (`water_bottle`, `egg`, `grain`, `eco`, `liquor`).
IconData dichoCategoryIcon(ShoppingCategory category) => switch (category) {
      ShoppingCategory.dairy => Icons.local_drink_outlined,
      ShoppingCategory.eggs => Icons.egg_outlined,
      ShoppingCategory.grain => Icons.rice_bowl_outlined,
      ShoppingCategory.vegetable => Icons.eco_outlined,
      ShoppingCategory.oil => Icons.water_drop_outlined,
      ShoppingCategory.other => Icons.shopping_basket_outlined,
    };

/// Parses "38.000", "38 000" or "38000" typed into the price field.
int parseVnd(String raw) {
  final digits = raw.replaceAll(RegExp('[^0-9]'), '');
  return int.tryParse(digits) ?? 0;
}
