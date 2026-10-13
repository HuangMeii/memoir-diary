import 'package:flutter/material.dart';

import '../tokens.dart';
import 'home_scale.dart';

/// Weekday names in the order [DateTime.weekday] uses them.
const List<String> _weekdays = [
  'Thứ hai',
  'Thứ ba',
  'Thứ tư',
  'Thứ năm',
  'Thứ sáu',
  'Thứ bảy',
  'Chủ nhật',
];

/// "Chủ nhật, ngày 11 tháng 10 năm 2026" — the date the greeting spells out.
String longDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ngày ${date.day} tháng ${date.month} năm ${date.year}';

/// The greeting block that opens today's overview.
class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    super.key,
    required this.date,
    required this.userName,
    required this.onRefresh,
  });

  final DateTime date;

  /// The signed-in user's display name, when the session has one.
  final String? userName;

  /// Reloads today's data; wired to the design's "Làm mới" button.
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final scale = HomeScale.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'TỔNG QUAN HÔM NAY',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: MemoirType.overlineLetterSpacing,
              ),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh, size: 16 * scale),
              label: const Text('Làm mới'),
            ),
          ],
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        Text(
          userName == null || userName!.isEmpty
              ? 'Chào bạn,'
              : 'Chào $userName,',
          // The design's "Friendly greeting" frame is 1024×46, which is the
          // page heading step (36/46) rather than the editorial one.
          style: theme.textTheme.headlineSmall?.copyWith(
            color: on,
            fontSize: MemoirType.headingPage,
            height: MemoirType.headingPageLineHeight / MemoirType.headingPage,
          ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          'Một ngày mới, một chút thời gian cho mình.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: muted,
            fontSize: MemoirType.body,
          ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        Text(
          longDate(date),
          style: theme.textTheme.bodySmall?.copyWith(
            color: muted,
            fontSize: MemoirType.caption,
          ),
        ),
      ],
    );
  }
}
