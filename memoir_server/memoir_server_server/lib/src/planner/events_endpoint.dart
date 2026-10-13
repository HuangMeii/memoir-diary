import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Special event CRUD, mirroring FastAPI `/events`.
class EventsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Event>> list(Session session, {DateTime? from, DateTime? to}) {
    final userId = currentUserId(session);
    return Event.db.find(
      session,
      where: (t) {
        final conditions = <Expression>[t.userId.equals(userId)];
        if (from != null) conditions.add(t.startAt >= from);
        if (to != null) conditions.add(t.startAt <= to);
        return conditions.reduce((a, b) => a & b);
      },
      orderBy: (t) => t.startAt,
    );
  }

  Future<Event> create(
    Session session, {
    required String title,
    required DateTime startAt,
    String? description,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
  }) {
    return Event.db.insertRow(
      session,
      Event(
        userId: currentUserId(session),
        title: title,
        description: description,
        startAt: startAt,
        endAt: endAt,
        location: location,
        isAllDay: isAllDay ?? false,
        reminderMinutes: reminderMinutes,
      ),
    );
  }

  Future<Event> update(
    Session session, {
    required UuidValue id,
    String? title,
    String? description,
    DateTime? startAt,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
  }) async {
    final event = await _owned(session, id);
    if (title != null) event.title = title;
    event.description = description;
    if (startAt != null) event.startAt = startAt;
    event.endAt = endAt;
    event.location = location;
    if (isAllDay != null) event.isAllDay = isAllDay;
    event.reminderMinutes = reminderMinutes;
    return Event.db.updateRow(session, event);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final event = await _owned(session, id);
    await Event.db.deleteRow(session, event);
  }

  Future<Event> _owned(Session session, UuidValue id) async {
    final event = await Event.db.findById(session, id);
    ensureOwned(event != null && event.userId == currentUserId(session));
    return event!;
  }
}
