import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api_client.dart';
import '../../data/providers.dart';
import '../widgets/entry_images_section.dart';
import '../widgets/icon_picker_row.dart';

/// The diary editor for one specific day.
///
/// Every question from the feature list gets its own labelled field so the
/// user can simply fill in whatever applies and leave the rest blank.
class EntryEditorScreen extends ConsumerStatefulWidget {
  const EntryEditorScreen({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends ConsumerState<EntryEditorScreen> {
  final _diary = TextEditingController();
  final _perspective = TextEditingController();
  final _future = TextEditingController();
  final _selfCare = TextEditingController();
  final _hope = TextEditingController();
  final _gratitude = TextEditingController();
  final _dream = TextEditingController();
  final _reflection = TextEditingController();

  int? _moodId;
  int? _weatherId;
  /// Id of the saved entry for [widget.date]; null until the day is saved once.
  /// Photos attach to an entry, so the gallery stays hidden until then.
  String? _entryId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _diary, _perspective, _future, _selfCare,
      _hope, _gratitude, _dream, _reflection,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Loads an existing entry for the day, if there is one.
  Future<void> _load() async {
    final entry = await ref.read(entryByDateProvider(dayKey(widget.date)).future);
    if (!mounted) return;
    if (entry != null) {
      _diary.text = entry.diaryText ?? '';
      _perspective.text = entry.otherPerspective ?? '';
      _future.text = entry.futureMessage ?? '';
      _selfCare.text = entry.selfCare ?? '';
      _hope.text = entry.tomorrowHope ?? '';
      _gratitude.text = entry.gratitude ?? '';
      _dream.text = entry.dream ?? '';
      _moodId = entry.moodId;
      _weatherId = entry.weatherId;
      _entryId = entry.id;
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final iso = widget.date.toIso8601String().substring(0, 10);
      final body = <String, dynamic>{
        'entry_date': iso,
        'diary_text': _text(_diary),
        'other_perspective': _text(_perspective),
        'future_message': _text(_future),
        'self_care': _text(_selfCare),
        'tomorrow_hope': _text(_hope),
        'gratitude': _text(_gratitude),
        'dream': _text(_dream),
        if (_moodId != null) 'mood_id': _moodId,
        if (_weatherId != null) 'weather_id': _weatherId,
      };

      final existing =
          await ref.read(entryByDateProvider(dayKey(widget.date)).future);
      final client = ref.read(apiClientProvider);
      if (existing == null) {
        final created = await client.post('/entries', data: body);
        _entryId = (created as Map<String, dynamic>)['id'] as String?;
      } else {
        await client.put('/entries/${existing.id}', data: body);
        _entryId = existing.id;
      }

      // The reflection is stored separately, linked to today's entry.
      if (_reflection.text.trim().isNotEmpty) {
        await client.post('/reflections', data: {
          'text': _reflection.text.trim(),
          'entry_date': iso,
        });
      }

      refreshEntryData(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu nhật ký')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _text(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    try {
      final entry = await ref.read(entryByDateProvider(dayKey(widget.date)).future);
      if (entry == null) {
        // Images attach to an entry, so save the entry first.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hãy lưu nhật ký trước khi thêm ảnh')),
          );
        }
        return;
      }
      await ref.read(apiClientProvider).uploadImage(
            '/entries/${entry.id}/images',
            file.path,
          );
      // Refetch so the new thumbnail appears without leaving the editor.
      ref.invalidate(entryImagesProvider(entry.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tải ảnh lên')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final moods = ref.watch(moodsProvider);
    final weathers = ref.watch(weathersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Nhật ký ${widget.date.day}/${widget.date.month}/${widget.date.year}'),
        actions: [
          IconButton(
            tooltip: 'Thêm ảnh',
            icon: const Icon(Icons.add_a_photo_outlined),
            onPressed: _pickImage,
          ),
          IconButton(
            tooltip: 'Lưu',
            icon: const Icon(Icons.save_outlined),
            onPressed: _saving || _loading ? null : _save,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        weathers.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('$e'),
                          data: (items) => IconPickerRow(
                            label: 'THỜI TIẾT',
                            items: items,
                            selectedId: _weatherId,
                            onSelected: (id) =>
                                setState(() => _weatherId = id),
                          ),
                        ),
                        const SizedBox(height: 18),
                        moods.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (e, _) => Text('$e'),
                          data: (items) => IconPickerRow(
                            label: 'CẢM XÚC',
                            items: items,
                            selectedId: _moodId,
                            onSelected: (id) => setState(() => _moodId = id),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_entryId != null) ...[
                  EntryImagesSection(entryId: _entryId!),
                  const SizedBox(height: 16),
                ],
                _Field(
                  icon: Icons.book_outlined,
                  label: 'Nội dung nhật ký',
                  controller: _diary,
                  hint: 'Hôm nay đã trải qua thế nào?',
                  lines: 8,
                ),
                _Field(
                  icon: Icons.explore_outlined,
                  label: 'Góc nhìn khác',
                  controller: _perspective,
                  hint: 'Nếu nhìn sự việc này từ góc khác thì sao?',
                ),
                _Field(
                  icon: Icons.mark_email_unread_outlined,
                  label: 'Nhắn nhủ tương lai (hoặc một câu hỏi)',
                  controller: _future,
                  hint: 'Bạn muốn nói gì với chính mình ngày mai?',
                ),
                _Field(
                  icon: Icons.spa_outlined,
                  label: 'Hôm nay bạn đã tự chăm sóc mình thế nào?',
                  controller: _selfCare,
                ),
                _Field(
                  icon: Icons.wb_twilight_outlined,
                  label: 'Bạn hi vọng điều gì vào ngày mai?',
                  controller: _hope,
                ),
                _Field(
                  icon: Icons.favorite_outline,
                  label: 'Bày tỏ lòng biết ơn',
                  controller: _gratitude,
                  hint: 'Điều gì khiến bạn biết ơn hôm nay?',
                ),
                _Field(
                  icon: Icons.nightlight_outlined,
                  label: 'Giấc mơ đã trải qua',
                  controller: _dream,
                ),
                _Field(
                  icon: Icons.psychology_outlined,
                  label: 'Suy nghĩ về 2 câu hôm nay',
                  controller: _reflection,
                  hint: 'Câu từ kho và câu của bạn gợi cho bạn điều gì?',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.check),
                  label: Text(_saving ? 'Đang lưu...' : 'Lưu nhật ký'),
                ),
              ],
            ),
    );
  }
}

/// A labelled text area used by every question in the editor.
class _Field extends StatelessWidget {
  const _Field({
    required this.icon,
    required this.label,
    required this.controller,
    this.hint,
    this.lines = 3,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: lines,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}