import 'package:flutter/material.dart';

import '../theme.dart';

/// Note colour swatches from the Figma editor top bar (`taoghichu`).
///
/// [bg] paints the picker dot; [value] is what a tap stores on the note. The
/// olive swatch stores the accent `#3d654c` — the dot colour Figma shows in
/// the editor meta strip (`'Màu ghi chú: Xanh ô liu nhạt'`).
const noteColorSwatches =
    <({String bg, String value, String name, bool outlined})>[
  (bg: '#e3ece4', value: '#3d654c', name: 'Xanh ô liu nhạt', outlined: false),
  (bg: '#fdf8e2', value: '#fdf8e2', name: 'Vàng mơ dịu', outlined: false),
  (bg: '#f3edf7', value: '#f3edf7', name: 'Tím sương', outlined: false),
  (bg: '#fbfdf9', value: '#fbfdf9', name: 'Giấy nguyên bản', outlined: true),
];

/// Vietnamese label for the meta line; unknown colours fall back to their hex.
String noteColorName(String? hex) {
  if (hex == null || hex.isEmpty) return 'Chưa chọn màu';
  final target = hex.toLowerCase();
  for (final s in noteColorSwatches) {
    if (s.value.toLowerCase() == target || s.bg.toLowerCase() == target) {
      return s.name;
    }
  }
  return hex;
}

/// Top bar: back, breadcrumb, autosave chip, colour dots, pin, tags, link, save.
class EditorTopBar extends StatelessWidget {
  const EditorTopBar({
    super.key,
    required this.onBack,
    required this.saving,
    required this.savedAt,
    required this.color,
    required this.onColorChanged,
    required this.isPinned,
    required this.onTogglePin,
    required this.onAddTag,
    required this.onLink,
    required this.onSave,
  });

  final VoidCallback onBack;
  final bool saving;
  final DateTime? savedAt;
  final String? color;
  final ValueChanged<String> onColorChanged;
  final bool isPinned;
  final VoidCallback onTogglePin;
  final VoidCallback onAddTag;
  final VoidCallback onLink;
  final VoidCallback onSave;

  String get _saveLabel {
    if (saving) return 'Đang lưu…';
    final at = savedAt;
    if (at == null) return 'Chưa lưu';
    final hh = at.hour.toString().padLeft(2, '0');
    final mm = at.minute.toString().padLeft(2, '0');
    return 'Đã lưu tự động lúc $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border:
            Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: LayoutBuilder(builder: (context, c) {
        final wide = c.maxWidth >= 720;
        return Row(children: [
          _back(theme),
          if (wide) ...[
            const SizedBox(width: 12),
            Container(
                width: 1, height: 16, color: theme.colorScheme.outlineVariant),
            const SizedBox(width: 12),
            _breadcrumb(theme),
          ],
          const Spacer(),
          if (wide) _saveChip(theme),
          const Spacer(),
          _actions(context, theme, wide),
        ]);
      }),
    );
  }

  Widget _back(ThemeData theme) => TextButton.icon(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back, size: 18),
        label: const Text('Quay lại danh sách'),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      );

  Widget _breadcrumb(ThemeData theme) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Ghi chú', style: theme.textTheme.bodySmall),
          const SizedBox(width: 6),
          Text('/',
              style: TextStyle(
                  color: theme.colorScheme.outlineVariant, fontSize: 12)),
          const SizedBox(width: 6),
          Text(
            'Đang soạn thảo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );

  Widget _saveChip(ThemeData theme) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          color: theme.colorScheme.surface,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: saving
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(_saveLabel, style: theme.textTheme.bodySmall),
        ]),
      );

  Widget _actions(BuildContext context, ThemeData theme, bool wide) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLowest,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: .6),
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              for (final s in noteColorSwatches)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _swatch(theme, s),
                ),
            ]),
          ),
          const SizedBox(width: 8),
          _pin(theme),
          if (wide) ...[const SizedBox(width: 8), _tag(theme)],
          const SizedBox(width: 8),
          _link(wide),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onSave,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Lưu & Đóng'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
          ),
        ],
      );

  Widget _swatch(
    ThemeData theme,
    ({String bg, String value, String name, bool outlined}) s,
  ) {
    final selected = (color ?? '').toLowerCase() == s.value.toLowerCase();
    // Figma: 1px accent border + 2px ring (blur 0) at 20% when selected; the
    // paper swatch keeps a permanent outline so it reads against white.
    final ring = theme.colorScheme.primary;
    return Tooltip(
      message: s.name,
      child: GestureDetector(
        onTap: () => onColorChanged(s.value),
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: colorFromHex(s.bg),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected
                  ? ring
                  : s.outlined
                      ? theme.colorScheme.outlineVariant
                      : Colors.transparent,
              width: 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: ring.withValues(alpha: .2),
                      blurRadius: 0,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  Widget _pin(ThemeData theme) => IconButton(
        onPressed: onTogglePin,
        tooltip: isPinned ? 'Bỏ ghim' : 'Ghim ghi chú',
        visualDensity: VisualDensity.compact,
        style: IconButton.styleFrom(
          backgroundColor: isPinned
              ? theme.colorScheme.secondaryContainer.withValues(alpha: .45)
              : Colors.transparent,
        ),
        icon: Icon(
          isPinned ? Icons.push_pin : Icons.push_pin_outlined,
          size: 20,
          color: isPinned
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      );

  Widget _tag(ThemeData theme) => OutlinedButton.icon(
        onPressed: onAddTag,
        icon: const Icon(Icons.add, size: 16),
        label: const Text('Thêm thẻ'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      );

  Widget _link(bool wide) => Builder(builder: (context) {
        final theme = Theme.of(context);
        return OutlinedButton.icon(
          onPressed: onLink,
          icon: const Icon(Icons.book, size: 18),
          label: Text(wide ? 'Liên kết với nhật ký' : 'Liên kết'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            foregroundColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: .07),
            side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: .3)),
          ),
        );
      });
}
