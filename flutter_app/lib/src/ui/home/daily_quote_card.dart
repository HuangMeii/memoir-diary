import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_exception.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../icons.dart';
import '../theme.dart';
import '../tokens.dart';
import 'home_scale.dart';

/// The design's "Câu nói hôm nay" card.
///
/// The quote is drawn once a day and stored server-side, so reopening the app
/// shows the same line. The card also carries the design's error state: when
/// the pair cannot be fetched it offers "Thử lại" instead of a raw message.
///
/// TODO(design): the botanical sprig next to the quote needs its own Figma
/// export; assets/illustrations only ships the brand mark and the login art.
class DailyQuoteCard extends ConsumerWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = MemoirPalette.of(context);
    final pair = ref.watch(todayQuoteProvider);
    final scale = HomeScale.of(context);

    return Card(
      color: palette.surfaceIllustration,
      child: Padding(
        padding: EdgeInsets.all(MemoirSpace.s6 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'CÂU NÓI HÔM NAY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontSize: MemoirType.overlineEditorial,
                      letterSpacing: MemoirType.overlineEditorialLetterSpacing,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Đổi câu khác',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.refresh,
                    size: 18 * scale,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () async {
                    try {
                      await reshuffleTodayQuote(ref);
                    } on ApiException catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                ),
                const MemoirIcon('quote', size: 18),
              ],
            ),
            SizedBox(height: MemoirSpace.s2 * scale),
            pair.when(
              loading: () => Padding(
                padding: EdgeInsets.symmetric(vertical: MemoirSpace.s5 * scale),
                child: const LinearProgressIndicator(),
              ),
              error: (e, _) => _ErrorState(ref: ref),
              data: (data) => _QuoteBody(data: data),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteBody extends StatelessWidget {
  const _QuoteBody({required this.data});

  final DailyQuotePair data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);

    if (!data.hasQuote) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: MemoirSpace.s5 * scale),
        child: Text(
          'Chưa có câu nào hôm nay. Bấm nút đổi câu để lấy một câu mới.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.body,
          ),
        ),
      );
    }

    // When the user has fewer than 10 self messages the server pairs two
    // library quotes (quote + quote2). Show them as 1 large + 1 small so
    // the second line is never hidden.
    final secondQuote = data.hasQuote2
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 24),
              Text(
                'Câu thứ hai dành cho bạn',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: MemoirType.caption,
                  letterSpacing: MemoirType.overlineEditorialLetterSpacing,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '“${data.quote2Text}”',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: MemoirType.body,
                  height: 1.5,
                ),
              ),
              if ((data.quote2Author ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '— ${data.quote2Author}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: MemoirType.caption,
                  ),
                ),
              ],
            ],
          )
        : null;

    final note = data.hasSelfMessage
        ? 'Lời nhắn của bạn: “${data.selfMessageContent}”'
        : data.hasQuote2
            ? 'Cả hai câu đều từ kho — viết thêm lời nhắn để ngày mai ghép câu của bạn'
            : 'Một lời nhắn dành cho hôm nay';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '“${data.quoteText}”',
          style: TextStyle(
            fontFamily: serifFamily,
            fontSize: MemoirType.headingEditorial,
            height: 1.3,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: MemoirSpace.s3 * scale),
        Text(
          note,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.body,
          ),
        ),
        if (secondQuote != null) ...[
          SizedBox(height: MemoirSpace.s2 * scale),
          secondQuote,
        ],
      ],
    );
  }
}

/// "Chưa tải được câu nói hôm nay" with a retry, as in the design's `Quote lỗi`
/// frame.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = HomeScale.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chưa tải được câu nói hôm nay',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontSize: MemoirType.body,
          ),
        ),
        SizedBox(height: MemoirSpace.s2 * scale),
        Text(
          'Một chút gián đoạn thôi. Bạn vẫn có thể viết và lưu ngày của mình.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: MemoirType.body,
          ),
        ),
        SizedBox(height: MemoirSpace.s4 * scale),
        OutlinedButton(
          onPressed: () => ref.invalidate(todayQuoteProvider),
          child: const Text('Thử lại'),
        ),
      ],
    );
  }
}
