import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Weekly goal / todo CRUD, mirroring FastAPI `/todos`.
class TodosEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Todo>> list(Session session, {String? weekLabel}) {
    final userId = currentUserId(session);
    return Todo.db.find(
      session,
      where: (t) {
        var expr = t.userId.equals(userId);
        if (weekLabel != null) expr = expr & t.weekLabel.equals(weekLabel);
        return expr;
      },
      orderBy: (t) => t.createdAt,
    );
  }

  Future<Todo> create(
    Session session, {
    required String title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
  }) {
    return Todo.db.insertRow(
      session,
      Todo(
        userId: currentUserId(session),
        title: title,
        notes: notes,
        dueDate: dueDate == null ? null : dateOnly(dueDate),
        weekLabel: weekLabel,
        priority: priority ?? 2,
      ),
    );
  }

  Future<Todo> update(
    Session session, {
    required UuidValue id,
    String? title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
    bool? isDone,
  }) async {
    final todo = await _owned(session, id);
    if (title != null) todo.title = title;
    todo.notes = notes;
    todo.dueDate = dueDate == null ? null : dateOnly(dueDate);
    if (weekLabel != null) todo.weekLabel = weekLabel;
    if (priority != null) todo.priority = priority;
    if (isDone != null) {
      todo.isDone = isDone;
      todo.completedAt = isDone ? DateTime.now().toUtc() : null;
    }
    return Todo.db.updateRow(session, todo);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final todo = await _owned(session, id);
    await Todo.db.deleteRow(session, todo);
  }

  Future<Todo> _owned(Session session, UuidValue id) async {
    final todo = await Todo.db.findById(session, id);
    ensureOwned(todo != null && todo.userId == currentUserId(session));
    return todo!;
  }
}
