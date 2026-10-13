import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import 'home_screen.dart' show ErrorText;


/// Lets the user browse the pairs that were stored for past days.
///
/// Only days the app actually stored a row for appear here: the server writes a
/// row the first time `/daily-quotes/today` is called, so a gap in the list means
/// the app was not opened that day, not that the quote was lost.
class QuoteHistoryScreen extends ConsumerStatefulWidget {
  const QuoteHistoryScreen({super.key});

  @override
  ConsumerState<QuoteHistoryScreen> createState() =>
      _QuoteHistoryScreenState();
}

class _QuoteHistoryScreenState extends ConsumerState<QuoteHistoryScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  String get _key => monthKey(_month);

  void _shift(int delta) {
    setState(() => _month = DateTime(_month.year, _month.month + delta));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = ref.watch(quoteHistoryProvider(_key));
    final isCurrentMonth = _month.year == DateTime.now().year &&
        _month.month == DateTime.now().month;

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử câu nói')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Tháng trước',
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _shift(-1),
              ),
              Text(
                'Tháng ${_month.month}/${_month.year}',
                style: theme.textTheme.titleMedium,
              ),
              IconButton(
                tooltip: isCurrentMonth ? 'Đã ở tháng hiện tại' : 'Tháng sau',
                icon: const Icon(Icons.chevron_right),
                onPressed: isCurrentMonth ? null : () => _shift(1),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: rows.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: ErrorText('$e')),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Tháng này chưa có câu nào được lưu.\n'
                        'Mở app hằng ngày để câu được ghi lại.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _HistoryTile(pair: items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.pair});

  final DailyQuotePair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = pair.date;
    final now = DateTime.now();
    final isToday = d.year == now.year && d.month == now.month && d.day == now.day;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${d.day}/${d.month}/${d.year}${isToday ? ' · hôm nay' : ''}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (pair.quoteId != null)
                  Tooltip(
                    message: 'ID câu: ${pair.quoteId}',
                    child: Icon(Icons.bookmark_border,
                        size: 16, color: theme.colorScheme.onSurfaceVariant),
                  ),
                if (pair.quoteId2 != null)
                  Tooltip(
                    message: 'ID câu 2: ${pair.quoteId2}',
                    child: Icon(Icons.bookmark,
                        size: 16, color: theme.colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (pair.hasQuote)
              Text('“${pair.quoteText}”', style: theme.textTheme.bodyMedium)
            else
              Text(
                '(Câu đã bị xoá khỏi kho)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (pair.hasQuote && (pair.quoteAuthor ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('— ${pair.quoteAuthor}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
            ],
            // Days that drew two library quotes carry the second one here.
            if (pair.hasQuote2) ...[
              const Divider(height: 20),
              Text('“${pair.quote2Text}”', style: theme.textTheme.bodyMedium),
              if ((pair.quote2Author ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('— ${pair.quote2Author}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
              ],
            ],
            if (pair.hasSelfMessage) ...[
              const Divider(height: 20),
              Text('💌 Của bạn: “${pair.selfMessageContent}”',
                  style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}

