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

/// Shows one quote from the library + one of the user's own messages.
class QuotePairCard extends ConsumerWidget {
  const QuotePairCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pair = ref.watch(randomPairProvider);

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
                  tooltip: 'Câu khác',
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => ref.invalidate(randomPairProvider),
                ),
              ],
            ),
            const SizedBox(height: 8),
            pair.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => ErrorText('$e'),
              data: (data) {
                final quote = data?['quote'];
                final mine = data?['self_message'];
                // An empty body means the user has not written any self message
                // yet, which is normal for a new account. Only the library quote
                // is guaranteed, so render each side independently.
                if (quote == null && mine == null) {
                  return Text(
                    'Chưa có câu nào. Bấm nút làm mới hoặc kiểm tra kết nối.',
                    style: theme.textTheme.bodySmall,
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (quote != null) ...[
                      Text('“${quote['text']}”',
                          style: theme.textTheme.bodyMedium),
                      Text(
                        '— ${quote['author'] ?? 'Thư viện'}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (quote != null && mine != null) const Divider(height: 24),
                    if (mine != null)
                      Text('💌 Của bạn: “${mine['content']}”',
                          style: theme.textTheme.bodyMedium)
                    else
                      Text(
                        'Bạn chưa có lời nhắn nào để ghép cặp.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => showReflectionDialog(context, ref),
              icon: const Icon(Icons.psychology_outlined, size: 18),
              label: const Text('Suy nghĩ của bạn về 2 câu này?'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lets the user record what they think about the two quotes above.
void showReflectionDialog(BuildContext context, WidgetRef ref) {
  final controller = TextEditingController();
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Suy nghĩ của bạn'),
      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Viết suy nghĩ...'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: () async {
            if (controller.text.trim().isEmpty) return;
            try {
              await ref
                  .read(apiClientProvider)
                  .post('/reflections', data: {'text': controller.text.trim()});
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            } catch (e) {
              if (!dialogContext.mounted) return;
              ScaffoldMessenger.of(dialogContext)
                  .showSnackBar(SnackBar(content: Text('$e')));
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    ),
  );
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