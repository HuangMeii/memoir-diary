import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api_client.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// Thumbnail grid of the photos attached to a diary entry.
///
/// Reads go through presigned URLs that expire, so the grid refetches whenever
/// [entryImagesProvider] is invalidated (after an upload or a delete).
class EntryImagesSection extends ConsumerWidget {
  const EntryImagesSection({super.key, required this.entryId});

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final images = ref.watch(entryImagesProvider(entryId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.photo_library_outlined,
                size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'ẢNH KÈM THEO',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        images.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('$e', style: TextStyle(color: theme.colorScheme.error)),
          data: (items) => items.isEmpty
              ? Text(
                  'Chưa có ảnh nào. Bấm biểu tượng máy ảnh trên thanh trên cùng để thêm.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final view in items)
                      _Thumbnail(image: view),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Thumbnail extends ConsumerWidget {
  const _Thumbnail({required this.image});

  final EntryImageView image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 104,
      height: 104,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            // Presigned URLs are time-limited, so surface failures per tile.
            child: Image.network(
              image.url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(Icons.broken_image_outlined,
                    color: theme.colorScheme.onSurfaceVariant),
              ),
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : Container(color: theme.colorScheme.surfaceContainerHighest),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton.filledTonal(
              iconSize: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 28, height: 28),
              tooltip: 'Xoá ảnh',
              icon: const Icon(Icons.close),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xoá ảnh?'),
        content: const Text('Ảnh sẽ bị xoá khỏi bộ nhớ và không thể khôi phục.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xoá'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(apiClientProvider).delete('/images/${image.id}');
      ref.invalidate(entryImagesProvider(image.image.entryId));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xoá ảnh')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}