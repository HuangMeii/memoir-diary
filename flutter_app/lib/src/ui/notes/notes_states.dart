import 'package:flutter/material.dart';

/// Loading, empty and error states for the notes list.
class NotesLoading extends StatelessWidget {
  const NotesLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class NotesEmpty extends StatelessWidget {
  const NotesEmpty(
      {super.key, required this.trashed, this.onCreate, this.onExit});
  final bool trashed;
  final VoidCallback? onCreate;
  final VoidCallback? onExit;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trashed ? 'Thùng rác trống' : 'Chưa có ghi chú nào',
              style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          if (!trashed)
            FilledButton(
                onPressed: onCreate, child: const Text('Tạo ghi chú đầu tiên'))
          else
            OutlinedButton(
                onPressed: onExit, child: const Text('Quay lại danh sách')),
        ],
      ),
    );
  }
}

class NotesError extends StatelessWidget {
  const NotesError({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 40),
          const SizedBox(height: 8),
          Text('Không tải được ghi chú', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text('$error', style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Tải lại')),
        ],
      ),
    );
  }
}
