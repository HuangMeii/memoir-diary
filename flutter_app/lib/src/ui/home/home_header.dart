import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../icons.dart';
import '../theme.dart';
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

String _two(int value) => value.toString().padLeft(2, '0');

/// Header sizes the Figma tokens do not carry yet (measured from the
/// "HOME-01 · Mobile" frames: account bubble 34, inline icons 18).
const double _profileSize = 34;
const double _iconSize = 18;

/// "Chủ nhật, 11.10.2026" — the compact date shown in the app bar.
String shortDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${_two(date.day)}.${_two(date.month)}.${date.year}';

/// "Chủ nhật, ngày 11 tháng 10 năm 2026" — the date the greeting spells out.
String longDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ngày ${date.day} tháng ${date.month} năm ${date.year}';

/// First letters of a display name, e.g. "Minh An" → "MA".
String initialsOf(String? displayName) {
  final words = (displayName ?? '')
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'M';
  return words.take(2).map((word) => word[0].toUpperCase()).join();
}

/// Height of the home header, matching the design's 80 px app bar.
const double kHomeHeaderHeight = 80;

/// Home header: the Memoir wordmark, today's date, the account initials, the
/// display name and the logout action.
///
/// It is a plain container rather than a [Scaffold] app bar so the utility bar
/// can sit directly above it and both span the full width.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.date,
    required this.initials,
    required this.onLogout,
    this.name,
  });

  final DateTime date;

  /// Up to two letters shown in the account bubble.
  final String initials;

  /// The signed-in user's display name, shown next to the bubble.
  final String? name;

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final brand = theme.colorScheme.primary;
    final palette = MemoirPalette.of(context);
    final scale = HomeScale.of(context);

    return Container(
      height: kHomeHeaderHeight * scale,
      color: palette.surfaceCard,
      padding: EdgeInsets.symmetric(horizontal: MemoirSpace.s5 * scale),
      child: Row(
        children: [
          SvgPicture.asset(
            // The mark already carries the design's own colours (light tile +
            // brand-green book); tinting it would flatten both into one solid
            // shape.
            'assets/illustrations/brand-mark.svg',
            height: MemoirComponent.mobileBrandMarkHeight * scale,
          ),
          SizedBox(width: MemoirSpace.s2 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Memoir',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: on,
                  fontSize: MemoirType.brand,
                ),
              ),
              Text(
                shortDate(date),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: muted,
                  fontSize: MemoirType.caption,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Account bubble: the signed-in user's initials.
          Semantics(
            label: 'Tài khoản $initials',
            child: Container(
              width: _profileSize * scale,
              height: _profileSize * scale,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Text(
                initials,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: on,
                  fontSize: MemoirType.caption,
                ),
              ),
            ),
          ),
          if (name != null && name!.trim().isNotEmpty) ...[
            SizedBox(width: MemoirSpace.s2 * scale),
            Text(
              name!.trim(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: on,
                fontSize: MemoirType.label,
              ),
            ),
          ],
          SizedBox(width: MemoirSpace.s4 * scale),
          TextButton.icon(
            onPressed: onLogout,
            icon: MemoirIcon('log-out', size: _iconSize * scale, color: brand),
            label: Text(
              'Đăng xuất',
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted,
                fontSize: MemoirType.caption,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
