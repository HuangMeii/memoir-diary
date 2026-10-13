import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home/home_scale.dart';
import '../home/utility_pill.dart';
import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import '../utilities.dart';

/// Size the Figma tokens do not carry yet, measured from the frames: the
/// account bubble is 34 and the inline icons are 18.
const double _profileSize = 34;
const double _iconSize = 18;

/// Height of the app header.
///
/// Fixed on purpose: the header carries the wordmark, the navigation, the
/// utilities and the account actions, but as chrome on top of the page it does
/// not zoom with the content.
const double kAppHeaderHeight = 84;

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

/// "Chủ nhật, 11.10.2026" — the compact date shown in the app bar.
String shortDate(DateTime date) =>
    '${_weekdays[date.weekday - 1]}, ${_two(date.day)}.${_two(date.month)}.${date.year}';

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

/// The destinations the web header links to, left to right.
///
/// The design adds the row in the `Lưới tháng · Web` frame so the web screens
/// are reachable from any of them.
enum AppDestination {
  home('Trang chủ'),
  monthGrid('Lưới tháng'),
  eventHistory('Lịch sử kiện');

  const AppDestination(this.label);

  final String label;
}

/// The app header: the Memoir wordmark, today's date, the navigation, the
/// utility pills and the account actions, all on one row.
///
/// The design splits this into a "Utility navigation" bar plus an app bar; on
/// the web they are merged into a single bar so the page starts higher up.
/// Narrower headers shed the least important pieces instead of overflowing:
/// first the navigation, then the utilities, then the display name.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.date,
    required this.initials,
    required this.onLogout,
    this.destination = AppDestination.home,
    this.onNavigate,
    this.name,
    this.showUtilities = true,
    this.gutter = MemoirSpace.s5,
  });

  final DateTime date;

  /// Up to two letters shown in the account bubble.
  final String initials;

  final VoidCallback onLogout;

  /// Which navigation entry is the current screen.
  final AppDestination destination;

  /// Called when another destination is tapped; null leaves the navigation
  /// read-only.
  final ValueChanged<AppDestination>? onNavigate;

  /// The signed-in user's display name, shown next to the bubble.
  final String? name;

  /// Whether the utility pills belong in the header.
  ///
  /// The screen decides this from its own layout, so the header never shows an
  /// entry that `UtilitiesSection` also shows at the end of the page.
  final bool showUtilities;

  /// Horizontal padding, normally the content gutter so the wordmark lines up
  /// with the page below it.
  final double gutter;

  /// Header widths at which the least important pieces drop out. Both are the
  /// width *inside* the gutter.
  static const double _navFrom = 880;
  static const double _utilitiesFrom = 720;
  static const double _nameFrom = 960;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final palette = MemoirPalette.of(context);
    final scale = HomeScale.textOf(context);

    return Container(
      height: kAppHeaderHeight,
      color: palette.surfaceCard,
      padding: EdgeInsets.symmetric(horizontal: gutter),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final showNav = width >= _navFrom;
          final showPills = showUtilities && width >= _utilitiesFrom;
          final showName = width >= _nameFrom;

          return Row(
            children: [
              SvgPicture.asset(
                // The mark already carries the design's own colours (light tile
                // + brand-green book); tinting it would flatten both into one
                // solid shape.
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
              // The middle slot holds the navigation and the utility pills when
              // there is room for them, and acts as the spacer when there is
              // not. Each half scrolls inside its own share instead of
              // overflowing, so a second utility (or a font wider than the
              // design's) can never push the navigation out of reach.
              Expanded(
                child: !showNav && !showPills
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          // The navigation gets twice the pills' share: it is the
                          // wider block and the one the reader clicks through.
                          Expanded(
                            flex: 2,
                            child: showNav
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: MemoirSpace.s6 * scale,
                                      ),
                                      child: _Navigation(
                                        active: destination,
                                        onNavigate: onNavigate,
                                        scale: scale,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          // Utilities: the same entries the phone layout keeps
                          // at the end of the page, folded into the header on
                          // wider screens. Right-aligned so they stay next to
                          // the account actions, and reversed so the last pill
                          // is the one that stays visible when the band is
                          // tight.
                          if (showPills)
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (final item in utilityItems) ...[
                                        SizedBox(
                                          width: MemoirSpace.s6 * scale,
                                        ),
                                        UtilityPill(item: item),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              _Account(
                initials: initials,
                name: showName ? name : null,
                onLogout: onLogout,
                scale: scale,
              ),
            ],
          );
        },
      ),
    );
  }
}


/// The `Trang chủ · Lưới tháng · Lịch sử kiện` row the design puts next to the
/// wordmark.
///
/// The current screen is emphasised and not tappable; every other destination
/// calls [onNavigate].
class _Navigation extends StatelessWidget {
  const _Navigation({
    required this.active,
    required this.onNavigate,
    required this.scale,
  });

  final AppDestination active;
  final ValueChanged<AppDestination>? onNavigate;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final destination in AppDestination.values) ...[
          if (destination != AppDestination.values.first)
            SizedBox(width: MemoirSpace.s6 * scale),
          _destination(
            context,
            destination,
            (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
              fontSize: MemoirType.label,
              color: destination == active
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight:
                  destination == active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _destination(
    BuildContext context,
    AppDestination destination,
    TextStyle style,
  ) {
    final tappable = destination != active && onNavigate != null;

    Widget child = Padding(
      padding: EdgeInsets.symmetric(vertical: MemoirSpace.s2 * scale),
      child: Text(destination.label, style: style),
    );
    if (tappable) {
      child = InkWell(
        borderRadius: BorderRadius.circular(MemoirRadius.control * scale),
        onTap: () => onNavigate!(destination),
        child: child,
      );
    }

    return Semantics(
      selected: destination == active,
      button: tappable,
      child: child,
    );
  }
}

/// The account bubble, the display name and the logout action.
class _Account extends StatelessWidget {
  const _Account({
    required this.initials,
    required this.name,
    required this.onLogout,
    required this.scale,
  });

  final String initials;
  final String? name;
  final VoidCallback onLogout;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final muted = theme.colorScheme.onSurfaceVariant;
    final brand = theme.colorScheme.primary;
    final displayName = name?.trim();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        if (displayName != null && displayName.isNotEmpty) ...[
          SizedBox(width: MemoirSpace.s2 * scale),
          Text(
            displayName,
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
    );
  }
}

