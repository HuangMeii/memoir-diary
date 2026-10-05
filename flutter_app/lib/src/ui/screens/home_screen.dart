import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import '../../core/auth_provider.dart';
import '../../data/providers.dart';
import 'entry_editor.dart';
import 'health_screen.dart';
import 'month_grids_screen.dart';
import 'notes_screen.dart';
import 'planner_screen.dart';
import 'quote_history_screen.dart';
import '../widgets/icon_picker_row.dart';

/// Home = today's overview: quick mood/weather pick, the daily quote pair,
/// and shortcuts into the editor, grids and the other journals.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    final auth = ref.watch(authProvider);
    // Watched before the data providers below so a guarded provider never runs
    // while the stored token is still being read.
    ref.watch(authReadyProvider);

    // Nothing can be loaded correctly before the session is known: rendering
    // early fires unauthenticated requests that come back 401 and paint an
    // error flash before the token arrives. Returning here, before the watches
    // below, is what keeps those providers from running in the first place.
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final moods = ref.watch(moodsProvider);
    final weathers = ref.watch(weathersProvider);
    final entry = ref.watch(entryByDateProvider(dayKey(today)));
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memoir'),
        actions: [
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => refreshEntryData(ref),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Text(
              user != null && user['display_name'] != null
                  ? 'Xin chào, ${user['display_name']} 👋'
                  : 'Xin chào 👋',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              'Hôm nay ${today.day}/${today.month}/${today.year}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    weathers.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => ErrorText('$e'),
                      data: (items) => IconPickerRow(
                        label: 'THỜI TIẾT',
                        items: items,
                        selectedId: entry.valueOrNull?.weatherId,
                        onSelected: (id) => _pick(context, ref, weather: id),
                      ),
                    ),
                    const SizedBox(height: 18),
                    moods.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => ErrorText('$e'),
                      data: (items) => IconPickerRow(
                        label: 'CẢM XÚC',
                        items: items,
                        selectedId: entry.valueOrNull?.moodId,
                        onSelected: (id) => _pick(context, ref, mood: id),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            const QuotePairCard(),
            const SizedBox(height: 14),
            const ShortcutGrid(),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => EntryEditorScreen(date: today),
              )),
              icon: const Icon(Icons.edit_note),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Viết nhật ký hôm nay',
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Saves the quick mood/weather pick straight away.
  ///
  /// There is no `PUT /entries/by-date/...` route: the API only exposes
  /// `GET /entries/by-date/{date}`, `POST /entries` and
  /// `PUT /entries/{entry_id}`. So create the day first when it is missing.
  Future<void> _pick(
    BuildContext context,
    WidgetRef ref, {
    int? mood,
    int? weather,
  }) async {
    final today = DateTime.now();
    final iso = dayKey(today);
    final patch = <String, dynamic>{
      if (mood != null) 'mood_id': mood,
      if (weather != null) 'weather_id': weather,
    };
    try {
      final client = ref.read(apiClientProvider);
      final existing = await ref.read(entryByDateProvider(iso).future);
      if (existing == null) {
        await client.post('/entries', data: {'entry_date': iso, ...patch});
      } else {
        await client.put('/entries/${existing.id}', data: patch);
      }
      refreshEntryData(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Đã lưu')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}

/// Shows what the app drew for today, plus the two boxes the user writes in.
///
/// The pair comes from `/daily-quotes/today`, so it is stored rather than
/// redrawn: reopening the app later the same day shows the same quote, and the
/// history screen can show what was actually displayed.
///
/// What gets drawn depends on how many self messages the user has saved. With
/// fewer than [minSelfMessagesToPair] the server sends two library quotes; from
/// that point on it sends one quote next to one of the user's own.
class QuotePairCard extends ConsumerStatefulWidget {
  const QuotePairCard({super.key});

  @override
  ConsumerState<QuotePairCard> createState() => _QuotePairCardState();
}

class _QuotePairCardState extends ConsumerState<QuotePairCard> {
  final _message = TextEditingController();
  final _thought = TextEditingController();
  bool _savingMessage = false;
  bool _savingThought = false;

  @override
  void dispose() {
    _message.dispose();
    _thought.dispose();
    super.dispose();
  }

  Future<void> _submitMessage() async {
    if (_savingMessage || _message.text.trim().isEmpty) return;
    setState(() => _savingMessage = true);
    try {
      await saveSelfMessage(ref, _message.text);
      _message.clear();
      if (mounted) _toast('Đã lưu vào kho câu gửi gắm 🌱');
    } catch (e) {
      if (mounted) _toast('$e');
    } finally {
      if (mounted) setState(() => _savingMessage = false);
    }
  }

  Future<void> _submitThought() async {
    if (_savingThought || _thought.text.trim().isEmpty) return;
    setState(() => _savingThought = true);
    try {
      await saveReflection(ref, _thought.text);
      _thought.clear();
      if (mounted) _toast('Đã lưu suy nghĩ 💭');
    } catch (e) {
      if (mounted) _toast('$e');
    } finally {
      if (mounted) setState(() => _savingThought = false);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pair = ref.watch(todayQuoteProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('💬 Câu hôm nay', style: theme.textTheme.titleSmall),
                const Spacer(),
                IconButton(
                  tooltip: 'Xem lịch sử',
                  icon: const Icon(Icons.history, size: 20),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const QuoteHistoryScreen(),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Đổi câu khác',
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () async {
                    try {
                      await reshuffleTodayQuote(ref);
                    } on ApiException catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$e')),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            pair.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => ErrorText('$e'),
              data: (data) {
                // An empty body means nothing was drawn yet, which happens for a
                // brand new account with an empty library. Render each side
                // independently so one missing piece does not blank the card.
                if (!data.hasQuote && !data.hasQuote2 && !data.hasSelfMessage) {
                  return Text(
                    'Chưa có câu nào. Bấm nút làm mới hoặc kiểm tra kết nối.',
                    style: theme.textTheme.bodySmall,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.hasQuote) _QuoteBlock(data.quoteText!, data.quoteAuthor),
                    if (data.hasQuote && (data.hasQuote2 || data.hasSelfMessage))
                      const Divider(height: 20),
                    // Only set on days that drew two library quotes.
                    if (data.hasQuote2)
                      _QuoteBlock(data.quote2Text!, data.quote2Author),
                    if (data.hasQuote2 && data.hasSelfMessage)
                      const Divider(height: 20),
                    if (data.hasSelfMessage)
                      Text('💌 Của bạn: “${data.selfMessageContent}”',
                          style: theme.textTheme.bodyMedium),
                  ],
                );
              },
            ),
            const SizedBox(height: 14),
            _InlineInput(
              label: 'Câu hỏi gửi gắm tương lai của bạn?',
              hint: 'Ví dụ: Một năm nữa mình đã dám nói chưa?',
              controller: _message,
              saving: _savingMessage,
              icon: Icons.send_rounded,
              onSubmit: _submitMessage,
            ),
            const SizedBox(height: 10),
            _InlineInput(
              label: 'Suy nghĩ của bạn về câu hôm nay?',
              hint: 'Viết suy nghĩ ngay tại đây...',
              controller: _thought,
              saving: _savingThought,
              icon: Icons.psychology_outlined,
              onSubmit: _submitThought,
            ),
          ],
        ),
      ),
    );
  }
}

/// One quote plus its author, styled the same everywhere on the card.
class _QuoteBlock extends StatelessWidget {
  const _QuoteBlock(this.text, this.author);

  final String text;
  final String? author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('“$text”', style: theme.textTheme.bodyMedium),
        Text(
          '— ${author ?? 'Thư viện'}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// A labelled box with a save button: typing and submitting happen here
/// instead of in a dialog that covers the quotes being thought about.
class _InlineInput extends StatelessWidget {
  const _InlineInput({
    required this.label,
    required this.hint,
    required this.controller,
    required this.saving,
    required this.icon,
    required this.onSubmit,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool saving;
  final IconData icon;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: hint,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Lưu',
              icon: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon),
              onPressed: saving ? null : () => onSubmit(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Navigation tiles to the other parts of the journal.
class ShortcutGrid extends StatelessWidget {
  const ShortcutGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, Widget)>[
      (Icons.calendar_month, 'Lưới tháng', const MonthGridsScreen()),
      (Icons.sticky_note_2_outlined, 'Ghi chú', const NotesScreen()),
      (Icons.checklist, 'Todo & Sự kiện', const PlannerScreen()),
      (Icons.monitor_heart_outlined, 'Sức khoẻ', const HealthScreen()),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 42) / 2,
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => item.$3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.$1, size: 26),
                    const SizedBox(height: 10),
                    Text(item.$2, style: Theme.of(context).textTheme.titleSmall),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
