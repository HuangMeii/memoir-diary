import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/auth_provider.dart';
import '../../core/autosave.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/home_scale.dart';
import '../home/picker_card.dart';
import '../icons.dart';
import '../tokens.dart';
import '../widgets/app_footer.dart';
import '../widgets/app_header.dart';
import '../widgets/entry_images_section.dart';
import 'calendar_screen.dart';

/// Content width of the `JOURNAL-02 · Web` frames: 1280 minus 36 px gutters.
const double kJournalContentWidth = 1208;

/// The two editor columns in the design: 700 px of fields beside 300 px of
/// side cards, with a 24 px gap (700 + 24 + 300 = 1024, centred on 1208).
const double kJournalMainColumnWidth = 700;
const double kJournalSideColumnWidth = 300;
const double kJournalColumnGap = 24;

/// How long the editor waits after the writing pauses before it saves itself.
///
/// The design (`JOURNAL-02 · Web`) pins a `Lưu nhật ký` button in the save bar
/// and a "leave with unsaved changes?" dialog beside it; the editor drops both
/// and saves on its own, so a pause of a few seconds is all the writer does.
const Duration kEntryAutoSaveDelay = Duration(seconds: 4);

/// JOURNAL-02 — the diary editor for one day, like Figma `JOURNAL-02 · Web`
/// (`97:3`, `99:118`, `99:460`, `99:574`, `99:688`, `99:232`) + mobile `99:346`.
class EntryEditorScreen extends ConsumerStatefulWidget {
  const EntryEditorScreen({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends ConsumerState<EntryEditorScreen> {
  final _diary = TextEditingController();
  final _perspective = TextEditingController();
  final _selfCare = TextEditingController();
  final _hope = TextEditingController();
  final _gratitude = TextEditingController();
  final _dream = TextEditingController();
  final _reflection = TextEditingController();
  final _selfMessage = TextEditingController();

  /// The `Nhắn nhủ tương lai` field was taken out of the editor on request.
  ///
  /// The column is still read and written back unchanged, for two reasons: the
  /// server clears any field the client leaves out, so dropping it here would
  /// wipe text people already wrote, and keeping the value around means the
  /// field can come back without losing anything.
  String? _futureMessage;

  int? _moodId;
  int? _weatherId;
  /// Id of the saved entry for [widget.date]; null until the day is saved once.
  /// Photos attach to an entry, so the gallery stays hidden until then.
  String? _entryId;
  bool _loading = true;
  bool _saving = false;

  /// Saves a few seconds after the writing pauses, which is what lets the
  /// editor drop the `Lưu nhật ký` button of the design.
  late final AutosaveDebouncer _autosave = AutosaveDebouncer(
    delay: kEntryAutoSaveDelay,
    onElapsed: _autosaveNow,
  );

  /// The save in flight, if any. A keystroke, a quick pick and leaving the
  /// editor can all ask at once; they share this request instead of racing.
  Future<void>? _inFlight;

  /// Snapshot of the last saved state: what the status line reports on and
  /// what leaving the editor flushes.
  String _baseline = '';

  /// The reflection and the self message are records of their own, so their
  /// ids are remembered: a later autosave edits them instead of adding one
  /// more row every few seconds.
  String? _reflectionId;
  String? _selfMessageId;
  String _savedReflection = '';
  String _savedSelfMessage = '';

  String? _errorMessage;
  DateTime? _savedAt;

  List<TextEditingController> get _allControllers => [
        _diary,
        _perspective,
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
    _autosave.cancel();
    for (final c in _allControllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// Every keystroke restarts the wait, so the entry goes up once the writing
  /// has actually paused rather than on every character.
  void _onChanged() {
    if (_loading || !mounted) return;
    setState(() {});
    _autosave.schedule();
  }

  Future<void> _autosaveNow() async {
    if (!mounted || _loading) return;
    await _save();
    // The writing went on while the request was travelling: give it another
    // quiet period rather than dropping it.
    if (mounted && _dirty) _autosave.schedule();
  }

  bool get _dirty => _snapshot() != _baseline;

  String _snapshot() => [
        _diary.text,
        _perspective.text,
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
      _futureMessage = entry.futureMessage;
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

  /// Saves the page, sharing the request with whoever else asked for one.
  Future<void> _save() {
    final running = _inFlight;
    if (running != null) return running;
    if (!_dirty) return Future<void>.value();
    final future = _saveNow();
    _inFlight = future.whenComplete(() => _inFlight = null);
    return _inFlight!;
  }

  Future<void> _saveNow() async {
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      final iso = dayKey(widget.date);
      final body = <String, dynamic>{
        'entry_date': iso,
        'diary_text': _text(_diary),
        'other_perspective': _text(_perspective),
        // Sent back untouched: the field is gone from the editor, but the
        // server clears whatever the client leaves out.
        'future_message': _futureMessage,
        'self_care': _text(_selfCare),
        'tomorrow_hope': _text(_hope),
        'gratitude': _text(_gratitude),
        'dream': _text(_dream),
        if (_moodId != null) 'mood_id': _moodId,
        if (_weatherId != null) 'weather_id': _weatherId,
      };

      final saved = await ref
          .read(entryRepositoryProvider)
          .saveForDate(iso, body);
      _entryId = saved.id;

      // The reflection and the self message live outside the entry. Each is
      // only touched when its text really changed, and is then edited by the
      // id of the row already stored: saving every few seconds must never
      // leave a trail of near-duplicates.
      final reflection = _reflection.text.trim();
      if (reflection.isNotEmpty && reflection != _savedReflection) {
        _reflectionId = await saveReflection(ref, reflection, id: _reflectionId);
        _savedReflection = reflection;
      }

      // "Câu hỏi gửi gắm tương lai" moved here from the home quote card: it
      // fills the library the daily pairing draws from, so it is stored as a
      // self message rather than on the entry.
      final selfMessage = _selfMessage.text.trim();
      if (selfMessage.isNotEmpty && selfMessage != _savedSelfMessage) {
        _selfMessageId =
            await saveSelfMessage(ref, selfMessage, id: _selfMessageId);
        _savedSelfMessage = selfMessage;
      }

      refreshEntryData(ref);
      if (!mounted) return;
      setState(() {
        _savedAt = DateTime.now();
        _baseline = _snapshot();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMessage = '$e');
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

  /// A tap on a quick-choice tile saves straight away — the `Tự động lưu` the
  /// home dashboard's picker cards promise.
  Future<void> _pick(String field, int? value) async {
    _autosave.cancel();
    setState(() {
      if (field == 'mood') {
        _moodId = value;
      } else {
        _weatherId = value;
      }
    });
    await _flush();
  }

  /// Pushes everything on screen to the server, including whatever arrived
  /// while an earlier request was still travelling. Stops once the page is
  /// clean, or on the first failure: the banner then carries the error and the
  /// writing stays where it is.
  Future<void> _flush() async {
    while (mounted && _dirty) {
      await _save();
      if (_errorMessage != null) return;
    }
  }

  /// Leaves the editor without ever dropping a change: whatever is still
  /// waiting for its quiet period is saved on the way out. When that save
  /// fails the editor stays open on the error banner.
  Future<void> _handleLeave() async {
    _autosave.cancel();
    await _flush();
    if (_errorMessage != null) return;
    if (mounted) Navigator.of(context).pop();
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
        await _handleLeave();
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
                } else if (destination == AppDestination.eventHistory) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CalendarScreen(),
                    ),
                  );
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
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// The status line of the design's sticky save bar (`99:460`) — without the
  /// `Huỷ` and `Lưu nhật ký` buttons: the editor saves by itself, so the bar
  /// only has to say where the writing stands.
  Widget _saveBar(BuildContext context, double scale) {
    final theme = Theme.of(context);
    final status = _saving
        ? 'Đang lưu...'
        : _dirty
            ? 'Sẽ tự động lưu...'
            : _savedAt != null
                ? 'Đã lưu lúc ${_two(_savedAt!.hour)}:${_two(_savedAt!.minute)}'
                : 'Nhật ký tự động lưu sau vài giây.';
    return Container(
      padding: EdgeInsets.symmetric(vertical: MemoirSpace.s4 * scale),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          if (_saving) ...[
            SizedBox(
              width: 14 * scale,
              height: 14 * scale,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: MemoirSpace.s2 * scale),
          ],
          Expanded(
            child: Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The only banner left is the failed save (`99:688`): the editor saves
  /// itself, so there is no "Đã lưu nhật ký" banner to dismiss.
  Widget _bannerView(BuildContext context, double scale) {
    if (_errorMessage == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.only(top: MemoirSpace.s4 * scale),
      padding: EdgeInsets.all(MemoirSpace.s4 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MemoirRadius.card * scale),
        border: Border.all(color: theme.colorScheme.error),
      ),
      child: Row(
        children: [
          Expanded(child: Text('Chưa lưu được: ${_errorMessage!}')),
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
          onTap: _handleLeave,
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

  /// The 300 px side column of Figma `99:189`: day card, the two quick picks,
  /// photos.
  ///
  /// The picks are the same cards the home dashboard shows — `WeatherMoodRow`
  /// keeps them side by side when the column is wide enough and stacked when
  /// it is not — and a tap saves at once, like `Tự động lưu` there.
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
        SizedBox(height: MemoirSpace.s4 * scale),
        WeatherMoodRow(
          weather: _picker(
            title: 'Thời tiết hôm nay',
            items: weathers,
            iconName: (item) => weatherIcon(item.code),
            selectedId: _weatherId,
            onSelected: (id) => _pick('weather', id),
          ),
          mood: _picker(
            title: 'Cảm xúc hôm nay',
            items: moods,
            iconName: (item) => moodIcon(item.code),
            selectedId: _moodId,
            onSelected: (id) => _pick('mood', id),
          ),
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
              // The label yields to the action rather than pushing it out of
              // the 300 px card.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Ảnh kèm theo',
                      style: theme.textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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

  /// One of the two quick picks, built exactly like the home dashboard's card.
  ///
  /// Loading and error keep the same card chrome, so the side column does not
  /// jump while the lookups arrive.
  Widget _picker({
    required String title,
    required AsyncValue<List<LookupItem>> items,
    required String Function(LookupItem item) iconName,
    required int? selectedId,
    required ValueChanged<int?> onSelected,
  }) {
    return items.when(
      loading: () => _pickerShell(title, const LinearProgressIndicator()),
      error: (e, _) => _pickerShell(
        title,
        Text('$e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
      data: (list) => PickerCard(
        title: title,
        items: list,
        iconName: iconName,
        selectedId: selectedId,
        onSelected: onSelected,
      ),
    );
  }

  Widget _pickerShell(String title, Widget child) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(MemoirSpace.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            child,
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