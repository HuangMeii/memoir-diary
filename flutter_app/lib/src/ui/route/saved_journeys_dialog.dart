import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../tokens.dart';
import 'route_format.dart';

/// Opens the list of saved trips.
Future<void> showSavedJourneys(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_) => const SavedJourneysDialog(),
    );

/// The saved trips, and one of them opened.
///
/// A trip keeps the forecast it was planned with. The review shows that snapshot
/// first, labelled with when it was taken, and offers the latest forecast as a
/// separate block, so the two are never mixed up.
class SavedJourneysDialog extends ConsumerStatefulWidget {
  const SavedJourneysDialog({super.key});

  @override
  ConsumerState<SavedJourneysDialog> createState() =>
      _SavedJourneysDialogState();
}

class _SavedJourneysDialogState extends ConsumerState<SavedJourneysDialog> {
  /// The trip being reviewed, or null while the list is showing.
  String? _openId;

  /// The freshly fetched forecast for the open trip.
  RouteWeatherReport? _fresh;
  bool _loadingFresh = false;
  String? _error;

  Future<void> _refreshForecast(JourneyDetail detail) async {
    setState(() {
      _loadingFresh = true;
      _error = null;
    });
    try {
      final report = await ref.read(routeRepositoryProvider).forecast(
            plan: planFromJourney(detail),
            departureAt: detail.journey.departureAt,
          );
      if (!mounted) return;
      setState(() {
        _fresh = report;
        _loadingFresh = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadingFresh = false;
        _error = '$error';
      });
    }
  }

  Future<void> _delete(Journey journey) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá hành trình'),
        content: Text('Xoá "${journey.title}" khỏi tài khoản? '
            'Nhật ký đã liên kết vẫn được giữ.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Giữ lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(routeRepositoryProvider).deleteJourney(journey.id);
      ref.invalidate(journeysProvider);
      if (!mounted) return;
      setState(() {
        _openId = null;
        _fresh = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = '$error');
    }
  }

  void _open(String id) => setState(() {
        _openId = id;
        _fresh = null;
        _error = null;
      });

  @override
  Widget build(BuildContext context) {
    final id = _openId;

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 640),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: id == null ? _list(context) : _detail(context, id),
        ),
      ),
    );
  }

  Widget _list(BuildContext context) {
    final theme = Theme.of(context);
    final journeys = ref.watch(journeysProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(context, 'Hành trình đã lưu', null),
        const SizedBox(height: 12),
        Expanded(
          child: journeys.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => RouteNote(message: '$error'),
            data: (items) => items.isEmpty
                ? const Center(
                    child: RouteNote(
                      message: 'Chưa có hành trình nào được lưu. Tính một '
                          'hành trình rồi bấm "Lưu vào nhật ký".',
                    ),
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final journey = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          journey.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: MemoirType.body,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${formatClockDay(journey.departureAt)} · '
                          '${formatKm(journey.distanceMeters)} · '
                          '${formatDuration(journey.durationSeconds)} '
                          '(${vehicleLabel(journey.vehicle)})',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: MemoirType.caption,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: 'Xoá',
                          onPressed: () => _delete(journey),
                          icon: const Icon(Icons.delete_outline, size: 18),
                        ),
                        onTap: () => _open(journey.id),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, String title, VoidCallback? onBack) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (onBack != null)
          IconButton(
            tooltip: 'Quay lại',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: MemoirType.label + 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Đóng',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 18),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _detail(BuildContext context, String id) {
    final theme = Theme.of(context);
    final detailAsync = ref.watch(journeyDetailProvider(id));

    return detailAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Column(
        children: [
          _header(
            context,
            'Hành trình đã lưu',
            () => setState(() => _openId = null),
          ),
          Expanded(child: Center(child: RouteNote(message: '$error'))),
        ],
      ),
      data: (detail) {
        final journey = detail.journey;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(
              context,
              journey.title,
              () => setState(() {
                _openId = null;
                _fresh = null;
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${journey.originName} → ${journey.destinationName}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: MemoirType.body,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Khởi hành ${formatClockDay(journey.departureAt)} · '
                    '${formatKm(journey.distanceMeters)} · '
                    '${formatDuration(journey.durationSeconds)} '
                    '(${vehicleLabel(journey.vehicle)})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: MemoirType.caption,
                    ),
                  ),
                  if (journey.isLinkedToEntry)
                    Text(
                      'Đã liên kết với nhật ký ngày '
                      '${formatDay(journey.departureAt)}.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontSize: MemoirType.caption,
                      ),
                    ),
                  if (journey.notes != null && journey.notes!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        journey.notes!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: MemoirType.body,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(child: _readings(context, detail)),
            if (_error != null) ...[
              const SizedBox(height: 8),
              RouteNote(message: 'Không lấy được dự báo mới: $_error'),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _loadingFresh ? null : () => _refreshForecast(detail),
                icon: _loadingFresh
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh, size: 16),
                label: Text(
                  _loadingFresh ? 'Đang lấy…' : 'Cập nhật dự báo mới nhất',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// The two blocks the review compares: the saved snapshot and, once asked for,
  /// the latest forecast. Same row shape in both, so they read side by side.
  Widget _readings(BuildContext context, JourneyDetail detail) {
    final saved = detail.journey.weatherSavedAt;
    final fresh = _fresh;

    return ListView(
      children: [
        _blockTitle(
          context,
          'Bản tóm tắt đã lưu',
          saved == null
              ? 'Chuyến này không lưu kèm dự báo.'
              : 'Chụp lúc ${formatClockDay(saved)}',
        ),
        for (final point in detail.weatherPoints)
          _row(
            context,
            at: point.sampleAt,
            label: point.label,
            group: point.weatherGroup,
            temp: point.tempC,
            rain: point.precipitationMm,
            probability: point.precipitationProbability,
            severity: point.severity ?? RouteSeverity.info,
          ),
        if (fresh != null) ...[
          const SizedBox(height: 16),
          _blockTitle(
            context,
            'Dự báo mới nhất',
            'Lấy lúc ${formatClockDay(fresh.generatedAt)} · '
                '${fresh.samples.length} điểm mẫu',
          ),
          for (final sample in fresh.samples)
            _row(
              context,
              at: sample.arrivalAt,
              label: sample.label,
              group: sample.weatherGroup,
              temp: sample.tempC,
              rain: sample.precipitationMm,
              probability: sample.precipitationProbability,
              severity: sample.severity,
            ),
        ],
      ],
    );
  }

  Widget _blockTitle(BuildContext context, String title, String subtitle) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: MemoirType.body,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: MemoirType.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required DateTime at,
    required String? label,
    required String? group,
    required double? temp,
    required double? rain,
    required int? probability,
    required String severity,
  }) {
    final theme = Theme.of(context);
    final meta = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: MemoirType.caption,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              formatClock(at),
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: MemoirType.caption,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          RouteWeatherIcon(group: group, size: 15),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: meta,
            ),
          ),
          Text(
            '${temp == null ? '—' : '${temp.round()}°C'} · '
            '${probability ?? 0}%'
            '${rain == null ? '' : ' · ${rain.toStringAsFixed(1)}mm'}',
            style: meta,
          ),
          const SizedBox(width: 6),
          RouteSeverityChip(severity: severity),
        ],
      ),
    );
  }
}


