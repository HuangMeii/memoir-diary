import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../home/home_scale.dart';
import '../tokens.dart';
import '../widgets/app_header.dart';

const double kDichoDesignWidth = 1280;
const double kDichoContentWidth = 1208;
const double kDichoColumnGap = MemoirSpace.s7;
const double kDichoTwoColumnMinWidth = 1024;
const double kDichoMapStackedHeight = 360;

class DichoScreen extends ConsumerStatefulWidget {
  const DichoScreen({super.key});
  @override
  ConsumerState<DichoScreen> createState() => _DichoScreenState();
}

class _DichoScreenState extends ConsumerState<DichoScreen> {
  int _selectedDeparture = 1;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    ref.watch(authReadyProvider);
    final displayName = auth.user?['display_name'] as String?;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scale = homeScaleFor(constraints.maxWidth);
          final textScale = homeTextScaleFor(constraints.maxWidth);
          final twoColumn = constraints.maxWidth >= kDichoTwoColumnMinWidth;
          final media = MediaQuery.of(context);

          return MediaQuery(
            data: media.copyWith(
              textScaler: textScale == 1
                  ? media.textScaler
                  : HomeTextScaler(base: media.textScaler, factor: textScale),
            ),
            child: HomeScale(
              factor: scale,
              textFactor: textScale,
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppHeader(
                      date: DateTime.now(),
                      initials: initialsOf(displayName),
                      name: displayName,
                      onLogout: () =>
                          ref.read(authProvider.notifier).logout(),
                    ),
                    const SizedBox(height: MemoirSpace.s3 * scale),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_back, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Trang chủ',
                                  style: _captionStyle(context),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6 * scale),
                            child: Text(
                              '/',
                              style: _captionStyle(context).copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Text(
                              'Tiện ích',
                              style: _captionStyle(context).copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6 * scale),
                            child: Text(
                              '/',
                              style: _captionStyle(context).copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                          Text(
                            'Đi chợ',
                            style: _captionStyle(context).copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          if (twoColumn) ...[
                            _actionPill(context, 'Hành trình đã lưu',
                                Icons.history, scale),
                            SizedBox(width: MemoirSpace.s2 * scale),
                            _actionPill(context, 'So sánh giờ khởi hành',
                                Icons.compare_arrows, scale),
                            SizedBox(width: MemoirSpace.s2 * scale),
                            _actionPill(context, 'Lưu vào nhật ký',
                                Icons.bookmark_add, scale, primary: true),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: MemoirSpace.s4 * scale),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đi chợ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontFamily: 'Lora',
                                  fontSize: MemoirType.heading1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                ),
                          ),
                          SizedBox(height: MemoirSpace.s1 * scale),
                          Text(
                            'Lộ trình và dự báo thời tiết dọc đường',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  fontSize: MemoirType.body,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: MemoirSpace.s5 * scale),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16 * scale),
                        child: twoColumn
                            ? Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: _plannerColumn(context, scale),
                                  ),
                                  SizedBox(width: kDichoColumnGap),
                                  Expanded(
                                    flex: 8,
                                    child: _mapColumn(context, scale),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(
                                    child: _plannerColumn(context, scale),
                                  ),
                                  SizedBox(height: kDichoColumnGap),
                                  Expanded(
                                    child: _mapColumn(context, scale),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: MemoirSpace.s4 * scale),
                    _departureComparison(context, scale),
                    const SizedBox(height: MemoirSpace.s5 * scale),
                    _footerDisclaimer(context, scale),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle _captionStyle(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: MemoirType.caption,
          ) ??
          const TextStyle();

  Widget _actionPill(BuildContext context, String label, IconData icon,
      double scale, {bool primary = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 6 * scale),
      decoration: BoxDecoration(
        color: primary
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(MemoirRadius.pill),
        border: primary
            ? Border.all(color: theme.colorScheme.primary)
            : Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16 * scale, color: theme.colorScheme.primary),
          SizedBox(width: MemoirSpace.s1 * scale),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: MemoirType.caption,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _plannerColumn(BuildContext context, double scale) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s5 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quản lý lộ trình',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontFamily: 'Lora',
                    fontSize: MemoirType.headingEditorial,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: MemoirSpace.s4 * scale),
            _placeholderField(context, scale, 'Điểm xuất phát', 'Nhập địa điểm…'),
            SizedBox(height: MemoirSpace.s3 * scale),
            _placeholderField(context, scale, 'Điểm đến', 'Nhập địa điểm…'),
            SizedBox(height: MemoirSpace.s3 * scale),
            _placeholderField(context, scale, 'Thời gian dừng', '0 phút'),
            SizedBox(height: MemoirSpace.s4 * scale),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Tính tuyến'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(0, 36 * scale),
                      padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                    ),
                  ),
                ),
                SizedBox(width: MemoirSpace.s2 * scale),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Thêm điểm dừng'),
                    style: FilledButton.styleFrom(
                      minimumSize: Size(0, 36 * scale),
                      padding: EdgeInsets.symmetric(horizontal: 12 * scale),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapColumn(BuildContext context, double scale) {
    return Container(
      height: kDichoMapStackedHeight * scale,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map, size: 48 * scale,
                color: Theme.of(context).colorScheme.outlineVariant),
            SizedBox(height: MemoirSpace.s2 * scale),
            Text(
              'Bản đồ lộ trình',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: MemoirType.body,
                  ),
            ),
            SizedBox(height: MemoirSpace.s1 * scale),
            Text(
              'DC-03 sẽ vẽ bản đồ thật',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    fontSize: MemoirType.caption,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderField(BuildContext context, double scale,
      String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: MemoirType.caption,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: MemoirSpace.s1 * scale),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.outlineVariant,
              fontSize: MemoirType.body,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MemoirRadius.control),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MemoirRadius.control),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MemoirRadius.control),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12 * scale, vertical: 10 * scale),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: MemoirType.body,
          ),
        ),
      ],
    );
  }