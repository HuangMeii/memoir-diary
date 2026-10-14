import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models.dart';
import '../../data/providers.dart';

/// Shared note mutations with snackbar errors + provider refresh.
Future<void> pinNote(
    BuildContext context, WidgetRef ref, Note note, bool value) async {
  try {
    await ref.read(notesRepositoryProvider).setPinned(note, value);
    refreshNotes(ref);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

Future<void> archiveNote(BuildContext context, WidgetRef ref, Note note) async {
  try {
    await ref.read(notesRepositoryProvider).setArchived(note, !note.isArchived);
    refreshNotes(ref);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

Future<void> trashNote(BuildContext context, WidgetRef ref, Note note) async {
  try {
    await ref.read(notesRepositoryProvider).trash(note.id);
    refreshNotes(ref);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

Future<void> restoreNote(BuildContext context, WidgetRef ref, Note note) async {
  try {
    await ref.read(notesRepositoryProvider).restore(note.id);
    refreshNotes(ref);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}

Future<void> purgeNoteWithConfirm(
    BuildContext context, WidgetRef ref, Note note) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: const Text('Xoá vĩnh viễn?'),
      content: const Text('Ghi chú sẽ mất hẳn và không thể hoàn tác.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(c).pop(false),
            child: const Text('Huỷ')),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Theme.of(c).colorScheme.error),
          onPressed: () => Navigator.of(c).pop(true),
          child: const Text('Xoá vĩnh viễn'),
        ),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await ref.read(notesRepositoryProvider).purge(note.id);
    refreshNotes(ref);
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}
