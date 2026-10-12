import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../tokens.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/entry_images_section.dart';
import '../widgets/icon_picker_row.dart';

/// Content width of the `JOURNAL-02 · Web` frames: 1280 minus 36 px gutters.
const double kJournalContentWidth = 1208;

/// The two editor columns in the design: 700 px of fields beside 300 px of
/// side cards, with a 24 px gap (700 + 24 + 300 = 1024, centred on 1208).
const double kJournalMainColumnWidth = 700;
const double kJournalSideColumnWidth = 300;
const double kJournalColumnGap = 24;

/// JOURNAL-02 — the diary editor for one day, like Figma `JOURNAL-02 · Web`
/// (`97:3`, `99:118`, `99:460`, `99:574`, `99:688`, `99:232`) + mobile `99:346`.
class EntryEditorScreen extends ConsumerStatefulWidget {
  const EntryEditorScreen({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

/// Inline banner under the save bar: saved (`99:574`) or error (`99:688`).
enum _SaveBanner { none, saved, error }

class _EntryEditorScreenState extends ConsumerState<EntryEditorScreen> {
  final _diary = TextEditingController();
  final _perspective = TextEditingController();
  final _future = TextEditingController();
  final _selfCare = TextEditingController();
  final _hope = TextEditingController();
  final _gratitude = TextEditingController();
  final _dream = TextEditingController();
  final _reflection = TextEditingController();
  final _selfMessage = TextEditingController();

  int? _moodId;
  int? _weatherId;
  /// Id of the saved entry for [widget.date]; null until the day is saved once.
  /// Photos attach to an entry, so the gallery stays hidden until then.
  String? _entryId;
  bool _loading = true;
  bool _saving = false;

  /// Snapshot after load/save; leaving dirty asks to confirm (Figma `99:232`).
  String _baseline = '';
  _SaveBanner _banner = _SaveBanner.none;
  String? _errorMessage;
  DateTime? _savedAt;

  List<TextEditingController> get _allControllers => [
        _diary,
        _perspective,
        _future,
        _selfCare,
        _hope,
        _gratitude,
        _dream,
        _reflection,
        _selfMessage,
      ];

  @override
  void initState() {
    super.initState();
    for (final c in _allControllers) {
      c.addListener(_onChanged);
    }
    _load();
  }

  @override
  void dispose() {
    for (final c in _allControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    if (!_loading && mounted) setState(() {});
  }

  bool get _dirty => _snapshot() != _baseline;

  String _snapshot() => [
        _diary.text,
        _perspective.text,
        _future.text,
        _selfCare.text,
        _hope.text,
        _gratitude.text,
        _dream.text,
        _reflection.text,
        _selfMessage.text,
        'mood:${_moodId ?? ''}',
        'weather:${_weatherId ?? ''}',
      ].join('\n');

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
    _baseline = _snapshot();
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _banner = _SaveBanner.none;
      _errorMessage = null;
    });
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
      if (existing == null) {
        final created = await ref.read(entryRepositoryProvider).create(body);
        _entryId = created['id'] as String?;
      } else {
        await ref.read(entryRepositoryProvider).update(existing.id, body);
        _entryId = existing.id;
      }

      // The reflection is stored separately, linked to today's entry.
      if (_reflection.text.trim().isNotEmpty) {
        await ref.read(quoteRepositoryProvider).saveReflection(
          _reflection.text.trim(),
        );
      }

      // "Câu hỏi gửi gắm tương lai" moved here from the home quote card: it
      // fills the library the daily pairing draws from, so it is stored as a
      // self message rather than on the entry.
      if (_selfMessage.text.trim().isNotEmpty) {
        await saveSelfMessage(ref, _selfMessage.text);
      }

      refreshEntryData(ref);
      if (!mounted) return;
      setState(() {
        _banner = _SaveBanner.saved;
        _savedAt = DateTime.now();
        _baseline = _snapshot();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _banner = _SaveBanner.error;
        _errorMessage = '$e';
      });
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
      await ref.read(imageRepositoryProvider).upload(entry.id, file.path);
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

  Future<bool> _confirmLeave() async {
    if (!_dirty || _saving) return true;
    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Rời màn khi chưa lưu?'),
        content: const Text('Bạn có thay đổi chưa lưu. Lưu, bỏ, hay ở lại?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'stay'),
            child: const Text('Tiếp tục'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, 'discard'),
            child: const Text('Bỏ thay đổi'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, 'draft'),
            child: const Text('Lưu bản nháp'),
          ),
        ],
      ),
    );
    if (choice == 'discard') return true;
    if (choice == 'draft') {
      await _save();
      return true;
    }
    return false;
  }

  static String _weekday(DateTime d) => const [
        'Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm',
        'Thứ sáu', 'Thứ bảy', 'Chủ nhật',
      ][d.weekday - 1];

  static String _two(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final displayName =
        ref.watch(authProvider).user?['display_name'] as String?;
    final moods = ref.watch(moodsProvider);
    final weathers = ref.watch(weathersProvider);
    final todayQuote = ref.watch(todayQuoteProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmLeave() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final scale = homeScaleFor(
              constraints.maxWidth,
              designWidth: kMonthDesignWidth,
            );
            final textScale = homeTextScaleFor(
              constraints.maxWidth,
              designWidth: kMonthDesignWidth,
            );
            final gutter = math.max(
              16.0,
              (constraints.maxWidth - kJournalContentWidth * scale) / 2,
            );
            final sideBySide = constraints.maxWidth >=
                (kJournalMainColumnWidth +
                        kJournalColumnGap +
                        kJournalSideColumnWidth +
                        32) *
                scale;
            final media = MediaQuery.of(context);
            return MediaQuery(
              data: media.copyWith(
                textScaler: textScale == 1
                    ? media.textScaler
                    : HomeTextScaler(base: media.textScaler, factor: textScale),
              ),
              child: _body(context, scale, textScale, gutter, sideBySide,
                  today, displayName, moods, weathers, todayQuote),
            );
          },
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    double scale,
    double textScale,
    double gutter,
    bool sideBySide,
    DateTime today,
    String? displayName,
    AsyncValue<List<LookupItem>> moods,
    AsyncValue<List<LookupItem>> weathers,
    AsyncValue<DailyQuotePair> todayQuote,
  ) {
    return HomeScale(
      factor: scale,
      textFactor: textScale,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppHeader(
              date: today,
              initials: initialsOf(displayName),
              name: displayName,
              destination: AppDestination.monthGrid,
              onNavigate: (destination) {
                if (destination == AppDestination.home) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
              showUtilities: sideBySide,
              gutter: gutter,
              onLogout: () => ref.read(authProvider.notifier).logout(),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.fromLTRB(
                        gutter,
                        0,
                        gutter,
                        MemoirSpace.s8 * scale,
                      ),
                      children: [
                        _saveBar(context, scale),
                        _bannerView(context, scale),
                        _intro(context, scale),
                        SizedBox(height: MemoirSpace.s6 * scale),
                        if (sideBySide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: kJournalMainColumnWidth * scale,
                                child: _mainFields(todayQuote),
                              ),
                              SizedBox(width: kJournalColumnGap * scale),
                              SizedBox(
                                width: kJournalSideColumnWidth * scale,
                                child: _sideCards(scale, moods, weathers),
                              ),
                            ],
                          )
                        else ...[
                          _sideCards(scale, moods, weathers),
                          SizedBox(height: MemoirSpace.s6 * scale),
                          _mainFields(todayQuote),
                        ],
                        SizedBox(height: MemoirSpace.s8 * scale),
                        const PrivacyNote(),
                        SizedBox(height: MemoirSpace.s6 * scale),
                        if (!sideBySide)
                          FilledButton.icon(
                            onPressed: _saving ? null : _save,
                            icon: const Icon(Icons.check),
                            label: Text(
                                _saving ? 'Đang lưu...' : 'Lưu nhật ký'),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveBar(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final status = _saving
        ? 'Đang lưu...'
        : _savedAt != null && !_dirty
            ? 'Đã lưu lúc ${_two(_savedAt!.hour)}:${_two(_savedAt!.minute)}'
            : _dirty
                ? 'Có thay đổi chưa lưu.'
                : 'Chưa lưu thay đổi nào. Ghi lại một điều nhỏ rồi bấm Lưu.';
    return Container(
      padding: EdgeInsets.symmetric(vertical: MemoirSpace.s4 * scale),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(status)),
          TextButton(
            onPressed: () async {
              if (await _confirmLeave() && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Huỷ'),
          ),
          SizedBox(width: MemoirSpace.s2 * scale),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Đang lưu...' : 'Lưu nhật ký'),
          ),
        ],
      ),
    );
  }

  Widget _bannerView(BuildContext context, double scale) {
    if (_banner == _SaveBanner.none) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final saved = _banner == _SaveBanner.saved;
    return Container(
      margin: EdgeInsets.only(top: MemoirSpace.s4 * scale),
      padding: EdgeInsets.all(MemoirSpace.s4 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MemoirRadius.card * scale),
        border: Border.all(
            color: saved ? theme.colorScheme.primary : theme.colorScheme.error),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(saved
                ? 'Đã lưu nhật ký'
                : 'Chưa lưu được: ${_errorMessage ?? ''}'),
          ),
          if (saved)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Xem lưới tháng'),
            )
          else
            OutlinedButton(
              onPressed: _saving ? null : _save,
              child: const Text('Thử lại'),
            ),
        ],
      ),
    );
  }

  Widget _intro(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final brand = theme.colorScheme.primary;
    final d = widget.date;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MemoirSpace.s5 * scale),
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 16 * scale, color: brand),
              SizedBox(width: MemoirSpace.s2 * scale),
              Text('Lưới tháng',
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: brand)),
            ],
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Text('TRANG NHẬT KÝ · ${_two(d.day)}.${_two(d.month)}',
            style: theme.textTheme.labelSmall?.copyWith(color: brand)),
        SizedBox(height: MemoirSpace.s2 * scale),
        Text('${_weekday(d)}, ${d.day}.${d.month}',
            style: theme.textTheme.headlineSmall),
        const Text('Một entry cho mỗi ngày — cứ ghi điều nhỏ nhất.'),
      ],
    );
  }

  /// The questions of the editor in the order of Figma `99:152`, with the
  /// "2 câu hôm nay" block just above the reflection field.
  Widget _mainFields(AsyncValue<DailyQuotePair> todayQuote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Field(
            icon: Icons.book_outlined,
            label: 'Nội dung nhật ký',
            controller: _diary,
            hint: 'Hôm nay đã trải qua thế nào?',
            lines: 10),
        _Field(
            icon: Icons.explore_outlined,
            label: 'Góc nhìn khác',
            controller: _perspective,
            hint: 'Nếu nhìn sự việc này từ góc khác thì sao?'),
        _Field(
            icon: Icons.mark_email_unread_outlined,
            label: 'Nhắn nhủ tương lai (hoặc một câu hỏi)',
            controller: _future,
            hint: 'Bạn muốn nói gì với chính mình ngày mai?'),
        _Field(
            icon: Icons.spa_outlined,
            label: 'Hôm nay bạn đã tự chăm sóc mình thế nào?',
            controller: _selfCare),
        _Field(
            icon: Icons.wb_twilight_outlined,
            label: 'Bạn hi vọng điều gì vào ngày mai?',
            controller: _hope),
        _Field(
            icon: Icons.favorite_outline,
            label: 'Bày tỏ lòng biết ơn',
            controller: _gratitude,
            hint: 'Điều gì khiến bạn biết ơn hôm nay?'),
        _Field(
            icon: Icons.nightlight_outlined,
            label: 'Giấc mơ đã trải qua',
            controller: _dream),
        _Field(
            icon: Icons.send_rounded,
            label: 'Câu hỏi gửi gắm tương lai của bạn?',
            controller: _selfMessage,
            hint: 'Ví dụ: Một năm nữa mình đã dám nói chưa?'),
        _todayQuotes(todayQuote),
        _Field(
            icon: Icons.psychology_outlined,
            label: 'Suy nghĩ về 2 câu hôm nay',
            controller: _reflection,
            hint: 'Câu từ kho và câu của bạn gợi cho bạn điều gì?'),
      ],
    );
  }

  /// Figma `100:823` — the pair of the day above the reflection field.
  Widget _todayQuotes(AsyncValue<DailyQuotePair> todayQuote) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: todayQuote.when(
        loading: () => const LinearProgressIndicator(),
        error: (e, _) =>
            Text('$e', style: TextStyle(color: theme.colorScheme.error)),
        data: (pair) {
          final lines = <String>[];
          if (pair.hasQuote) lines.add('1 · “${pair.quoteText}”');
          if (pair.hasSelfMessage) {
            lines.add('2 · Câu gửi gắm: ${pair.selfMessageContent}');
          } else if (pair.hasQuote2) {
            lines.add('2 · ${pair.quote2Text}');
          }
          if (lines.isEmpty) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2 câu hôm nay',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    line,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// The 300 px side column of Figma `99:189`: day card, weather, mood, photos.
  Widget _sideCards(
    double scale,
    AsyncValue<List<LookupItem>> moods,
    AsyncValue<List<LookupItem>> weathers,
  ) {
    final theme = Theme.of(context);
    final d = widget.date;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SideCard(
          title: 'Ngày đang ghi',
          value: '${_weekday(d)}, ${_two(d.day)}.${_two(d.month)}.${d.year}',
          note: _entryId != null
              ? 'Trang này đã có nội dung.'
              : 'Chưa có trang nào cho ngày này.',
        ),
        SizedBox(height: MemoirSpace.s5 * scale),
        _lookupCard(
          title: 'Thời tiết',
          items: weathers,
          selectedId: _weatherId,
          onSelected: (id) => setState(() => _weatherId = id),
        ),
        SizedBox(height: MemoirSpace.s5 * scale),
        _lookupCard(
          title: 'Cảm xúc',
          items: moods,
          selectedId: _moodId,
          onSelected: (id) => setState(() => _moodId = id),
        ),
        SizedBox(height: MemoirSpace.s5 * scale),
        Container(
          padding: EdgeInsets.all(20 * scale),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(MemoirRadius.card * scale),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ảnh kèm theo', style: theme.textTheme.labelMedium),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text('+ Thêm ảnh'),
                  ),
                ],
              ),
              if (_entryId == null)
                Text(
                  'Lưu nhật ký trước khi thêm ảnh cho ngày này.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else
                EntryImagesSection(entryId: _entryId!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lookupCard({
    required String title,
    required AsyncValue<List<LookupItem>> items,
    required int? selectedId,
    required ValueChanged<int?> onSelected,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: items.when(
        loading: () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
        ),
        error: (e, _) =>
            Text('$e', style: TextStyle(color: theme.colorScheme.error)),
        data: (list) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.labelMedium),
            const SizedBox(height: 10),
            IconPickerRow(
              label: '',
              items: list,
              selectedId: selectedId,
              onSelected: onSelected,
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma `Card` — radius 20, padding 20, `surface.card` over `background.page`.
class _SideCard extends StatelessWidget {
  const _SideCard(
      {required this.title, required this.value, required this.note});

  final String title;
  final String value;
  final String note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(MemoirRadius.card),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelMedium),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            note,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
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