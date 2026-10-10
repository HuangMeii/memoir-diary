import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Schedule (timetable) item CRUD, mirroring FastAPI `/schedule-items`.
class SchedulesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<ScheduleItem>> list(Session session) {
    final userId = currentUserId(session);
    return ScheduleItem.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.startAt,
    );
  }

  Future<ScheduleItem> create(
    Session session, {
    required String title,
    required DateTime startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
  }) {
    return ScheduleItem.db.insertRow(
      session,
      ScheduleItem(
        userId: currentUserId(session),
        title: title,
        startAt: startAt,
        endAt: endAt,
        recurrenceRule: recurrenceRule,
        reminderMinutes: reminderMinutes,
      ),
    );
  }

  Future<ScheduleItem> update(
    Session session, {
    required UuidValue id,
    String? title,
    DateTime? startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
  }) async {
    final item = await _owned(session, id);
    if (title != null) item.title = title;
    if (startAt != null) item.startAt = startAt;
    item.endAt = endAt;
    item.recurrenceRule = recurrenceRule;
    item.reminderMinutes = reminderMinutes;
    return ScheduleItem.db.updateRow(session, item);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final item = await _owned(session, id);
    await ScheduleItem.db.deleteRow(session, item);
  }

  Future<ScheduleItem> _owned(Session session, UuidValue id) async {
    final item = await ScheduleItem.db.findById(session, id);
    ensureOwned(item != null && item.userId == currentUserId(session));
    return item!;
  }
}
