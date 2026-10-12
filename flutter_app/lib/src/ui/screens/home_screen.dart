import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth_provider.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../home/daily_quote_card.dart';
import '../home/dashboard_columns.dart';
import '../home/home_header.dart';
import '../home/home_scale.dart';
import '../home/journal_prompt_card.dart';
import '../home/month_activity_card.dart';
import '../home/picker_card.dart';
import '../home/saved_bar.dart';
import '../home/shortcut_cards.dart';
import '../icons.dart';
import '../tokens.dart';
import '../widgets/app_footer.dart';
import 'entry_editor.dart';

/// Content width of the web layout: the design's 1024 px dashboard centred on
/// an 1120 px page with 48 px gutters.
///
/// Every size here is in design pixels; [homeScaleFor] decides how far the
/// whole thing is zoomed up to fill the window.
const double kHomeContentWidth = 1024;

/// Home = today's overview, laid out like the design's `HOME-01 · Web` frames.
///
/// A wide screen gets the header — which carries the utilities — and two
/// dashboard columns: the main column records today (quick picks, quote,
/// writing rhythm) and the secondary one holds everything that navigates away
/// (the journal invitation and the shortcuts). Narrow screens stack the same
/// blocks in one column.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Message of the "saved" bar, or null while the bar is hidden.
  String? _saved;
  Timer? _savedTimer;

  @override
  void dispose() {
    _savedTimer?.cancel();
    super.dispose();
  }

  void _showSaved(String message) {
    _savedTimer?.cancel();
    setState(() => _saved = message);
    _savedTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _saved = null);
    });
  }

  void _hideSaved() {
    _savedTimer?.cancel();
    setState(() => _saved = null);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final auth = ref.watch(authProvider);
    // Watched before the data providers below so a guarded provider never runs
    // while the stored token is still being read.
    ref.watch(authReadyProvider);

    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final moods = ref.watch(moodsProvider);
    final weathers = ref.watch(weathersProvider);
    final entry = ref.watch(entryByDateProvider(dayKey(today)));
    final displayName = auth.user?['display_name'] as String?;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Zoom the design so the 1120 px Figma frame fills the window. At
          // 1536 px that is 1.37, which removes the wide empty gutters.
          final scale = homeScaleFor(constraints.maxWidth);
          // The type only follows part of the way (1.1x cap), so the same
          // window does not render a 17.8 px body and a 49 px greeting.
          final textScale = homeTextScaleFor(constraints.maxWidth);
          final horizontal = math.max(
            16.0,
            (constraints.maxWidth - kHomeContentWidth * scale) / 2,
          );
          final contentWidth = constraints.maxWidth - 2 * horizontal;
          final wide = contentWidth >= kDashboardBreakpoint * scale;
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
                  children: [
                    HomeHeader(
                      date: today,
                      initials: initialsOf(displayName),
                      name: displayName,
                      showUtilities: wide,
                      gutter: horizontal,
                      onLogout: () => ref.read(authProvider.notifier).logout(),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async => refreshEntryData(ref),
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(
                            horizontal,
                            MemoirSpace.s6 * scale,
                            horizontal,
                            MemoirSpace.s8 * scale,
                          ),
                          children: [
                            HomeGreeting(
                              date: today,
                              userName: displayName,
                              onRefresh: () => refreshEntryData(ref),
                            ),
                            SizedBox(height: MemoirSpace.s5 * scale),
                            DashboardColumns(
                              main: _mainColumn(
                                context,
                                today,
                                entry,
                                weathers,
                                moods,
                              ),
                              side: _sideColumn(context, today, entry),
                            ),
                            if (!wide) ...[
                              SizedBox(height: MemoirSpace.s8 * scale),
                              // The header only carries the utilities on a wide
                              // screen; the narrow layout keeps them here.
                              const UtilitiesSection(),
                            ],
                            SizedBox(height: MemoirSpace.s6 * scale),
                            const HomeTagline(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  /// The recording half of the dashboard: quick picks, the saved bar, the
  /// daily quote and this month's writing rhythm.
  Widget _mainColumn(
    BuildContext context,
    DateTime today,
    AsyncValue<DiaryEntry?> entry,
    AsyncValue<List<LookupItem>> weathers,
    AsyncValue<List<LookupItem>> moods,
  ) {
    final scale = HomeScale.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WeatherMoodRow(
          weather: weathers.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => ErrorText('$e'),
            data: (items) => PickerCard(
              title: 'Thời tiết hôm nay',
              items: items,
              iconName: (item) => weatherIcon(item.code),
              selectedId: entry.valueOrNull?.weatherId,
              onSelected: (id) => _pick(context, field: 'weather', value: id),
            ),
          ),
          mood: moods.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => ErrorText('$e'),
            data: (items) => PickerCard(
              title: 'Cảm xúc hôm nay',
              items: items,
              iconName: (item) => moodIcon(item.code),
              selectedId: entry.valueOrNull?.moodId,
              onSelected: (id) => _pick(context, field: 'mood', value: id),
            ),
          ),
        ),
        if (_saved != null) ...[
          SizedBox(height: MemoirSpace.s3 * scale),
          SavedBar(message: _saved!, onClose: _hideSaved),
        ],
        SizedBox(height: MemoirSpace.s4 * scale),
        const DailyQuoteCard(),
        SizedBox(height: MemoirSpace.s4 * scale),
        MonthActivityCard(month: DateTime(today.year, today.month)),
      ],
    );
  }

  /// The navigation half: the invitation to today's page and the shortcuts.
  Widget _sideColumn(
    BuildContext context,
    DateTime today,
    AsyncValue<DiaryEntry?> entry,
  ) {
    final scale = HomeScale.of(context);
    final written = (entry.valueOrNull?.diaryText ?? '').trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        JournalPromptCard(
          date: today,
          written: written,
          onOpen: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => EntryEditorScreen(date: today),
            ),
          ),
        ),
        SizedBox(height: MemoirSpace.s6 * scale),
        const ShortcutCards(),
      ],
    );
  }

  /// Saves the quick mood/weather pick straight away.
  ///
  /// There is no `PUT /entries/by-date/...` route: the API only exposes
  /// `GET /entries/by-date/{date}`, `POST /entries` and `PUT /entries/{id}`,
  /// so the day is created first when it is missing.
  ///
  /// [field] names the half that changed and [value] is its new id (`null`
  /// clears it). The whole entry is sent because the server assigns every
  /// field it receives, so a partial body would clear the rest.
  Future<void> _pick(
    BuildContext context, {
    required String field,
    required int? value,
  }) async {
    final today = DateTime.now();
    final iso = dayKey(today);
    try {
      final existing = await ref.read(entryByDateProvider(iso).future);
      final body = <String, dynamic>{
        'mood_id': field == 'mood' ? value : existing?.moodId,
        'weather_id': field == 'weather' ? value : existing?.weatherId,
        'diary_text': existing?.diaryText,
        'other_perspective': existing?.otherPerspective,
        'future_message': existing?.futureMessage,
        'self_care': existing?.selfCare,
        'tomorrow_hope': existing?.tomorrowHope,
        'gratitude': existing?.gratitude,
        'dream': existing?.dream,
      };
      if (existing == null) {
        await ref.read(entryRepositoryProvider).create(
              {'entry_date': iso, ...body},
            );
      } else {
        await ref.read(entryRepositoryProvider).update(existing.id, body);
      }
      refreshEntryData(ref);
      if (mounted) _showSaved('Đã lưu cảm xúc và thời tiết hôm nay');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}

/// The muted line that closes the page.
class HomeTagline extends StatelessWidget {
  const HomeTagline({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final scale = HomeScale.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 14 * scale, color: muted),
        SizedBox(width: MemoirSpace.custom6 * scale),
        Text(
          'Một không gian riêng, dành cho bạn.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: muted,
            fontSize: MemoirType.caption,
          ),
        ),
      ],
    );
  }
}

/// Renders API errors inline instead of throwing an unhandled exception.
class ErrorText extends StatelessWidget {
  const ErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
    );
  }
}

