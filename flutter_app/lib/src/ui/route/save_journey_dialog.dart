import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../tokens.dart';
import 'route_format.dart';

/// Modal that writes a planned route into the journal (`ROUTE-02`).
///
/// The trip is always stored on the account; the switch decides whether the
/// departure day's diary entry is written (or updated) as well. Nothing is
/// guessed: the summary that goes into the entry is shown first and stays
/// editable.
class SaveJourneyDialog extends ConsumerStatefulWidget {
  const SaveJourneyDialog({
    super.key,
    required this.plan,
    required this.report,
    required this.departureAt,
    required this.vehicle,
    required this.defaultTitle,
    required this.defaultEntryText,
    required this.scale,
  });

  final RoutePlan plan;
  final RouteWeatherReport report;
  final DateTime departureAt;
  final String vehicle;
  final String defaultTitle;

  /// The weather summary the trip would write into the diary entry.
  final String defaultEntryText;

  final double scale;

  @override
  ConsumerState<SaveJourneyDialog> createState() => _SaveJourneyDialogState();
}

class _SaveJourneyDialogState extends ConsumerState<SaveJourneyDialog> {
  late final TextEditingController _title =
      TextEditingController(text: widget.defaultTitle);
  late final TextEditingController _entryText =
      TextEditingController(text: widget.defaultEntryText);
  final TextEditingController _notes = TextEditingController();

  bool _writeEntry = true;
  bool _saving = false;

  /// Null while nothing has failed.
  String? _error;

  String get _isoDate {
    final date = widget.departureAt.toLocal();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  void dispose() {
    _title.dispose();
    _entryText.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final notes = _notes.text.trim();
      final entryText = _entryText.text.trim();
      final detail = await ref.read(routeRepositoryProvider).saveJourney(
            title: _title.text,
            vehicle: widget.vehicle,
            departureAt: widget.departureAt,
            stops: widget.plan.stops,
            plan: widget.plan,
            weatherSamples: widget.report.samples,
            notes: notes.isEmpty ? null : notes,
            createEntry: _writeEntry,
            entryText: entryText.isEmpty ? null : entryText,
          );
      ref.invalidate(journeysProvider);
      ref.invalidate(entryByDateProvider(_isoDate));
      if (!mounted) return;
      Navigator.of(context).pop(detail);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = '$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = widget.scale;
    final existing = ref.watch(entryByDateProvider(_isoDate));

    return AlertDialog(
      title: Text(
        'Lưu vào nhật ký',
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: MemoirType.label + 3,
        ),
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Tên chuyến đi',
                  isDense: true,
                ),
              ),
              SizedBox(height: MemoirSpace.s3 * scale),
              Text(
                'Chặng: ${formatKm(widget.plan.distanceMeters)} · '
                '${formatDuration(widget.plan.durationSeconds)} · '
                'khởi hành ${formatClockDay(widget.departureAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: MemoirType.body,
                ),
              ),
              SizedBox(height: MemoirSpace.s2 * scale),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _writeEntry,
                onChanged:
                    _saving ? null : (value) => setState(() => _writeEntry = value),
                title: Text(
                  'Ghi vào nhật ký ngày khởi hành',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: MemoirType.body,
                  ),
                ),
                subtitle: Text(
                  existing.maybeWhen(
                    data: (entry) => entry == null
                        ? 'Sẽ tạo nhật ký mới cho ngày này.'
                        : 'Đã có nhật ký ngày này, nội dung sẽ được thêm vào.',
                    orElse: () => 'Nhật ký của ngày khởi hành.',
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: MemoirType.caption,
                  ),
                ),
              ),
              if (_writeEntry) ...[
                TextField(
                  controller: _entryText,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: 'Thời tiết đính kèm (sửa được)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: MemoirSpace.s3 * scale),
              ],
              TextField(
                controller: _notes,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú chuyến đi',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: MemoirSpace.s2 * scale),
              RouteNote(
                icon: Icons.photo_outlined,
                message: 'Mở nhật ký sau khi lưu để thêm ảnh chuyến đi.',
                scale: scale,
              ),
              if (_error != null) ...[
                SizedBox(height: MemoirSpace.s3 * scale),
                Text(
                  'Không lưu được: $_error',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontSize: MemoirType.body,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Huỷ bỏ'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.bookmark_add_outlined, size: 16),
          label: Text(_saving ? 'Đang lưu…' : 'Xác nhận lưu'),
        ),
      ],
    );
  }
}

