import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Diary entry CRUD, mirroring FastAPI `/entries`.
class EntriesEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<DiaryEntry>> list(
    Session session, {
    String? month,
    DateTime? from,
    DateTime? to,
  }) async {
    final userId = currentUserId(session);
    return DiaryEntry.db.find(
      session,
      where: (t) {
        final conditions = <Expression>[t.userId.equals(userId)];
        if (month != null) {
          final (first, last) = monthBounds(month);
          conditions
            ..add(t.entryDate >= first)
            ..add(t.entryDate <= last);
        }
        if (from != null) conditions.add(t.entryDate >= dateOnly(from));
        if (to != null) conditions.add(t.entryDate <= dateOnly(to));
        return conditions.reduce((a, b) => a & b);
      },
      orderBy: (t) => t.entryDate.desc(),
    );
  }

  Future<DiaryEntry?> byDate(Session session, String isoDate) async {
    final userId = currentUserId(session);
    final day = dateOnly(DateTime.parse(isoDate));
    return DiaryEntry.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.entryDate.equals(day),
    );
  }

  Future<DiaryEntry> create(
    Session session, {
    required DateTime entryDate,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
  }) async {
    final userId = currentUserId(session);
    final day = dateOnly(entryDate);
    final existing = await DiaryEntry.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.entryDate.equals(day),
    );
    if (existing != null) {
      existing.moodId = moodId;
      existing.weatherId = weatherId;
      existing.diaryText = diaryText;
      existing.otherPerspective = otherPerspective;
      existing.futureMessage = futureMessage;
      existing.selfCare = selfCare;
      existing.tomorrowHope = tomorrowHope;
      existing.gratitude = gratitude;
      existing.dream = dream;
      existing.updatedAt = DateTime.now().toUtc();
      return DiaryEntry.db.updateRow(session, existing);
    }
    return DiaryEntry.db.insertRow(
      session,
      DiaryEntry(
        userId: userId,
        entryDate: day,
        moodId: moodId,
        weatherId: weatherId,
        diaryText: diaryText,
        otherPerspective: otherPerspective,
        futureMessage: futureMessage,
        selfCare: selfCare,
        tomorrowHope: tomorrowHope,
        gratitude: gratitude,
        dream: dream,
      ),
    );
  }

  Future<DiaryEntry> update(
    Session session, {
    required UuidValue id,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
  }) async {
    final entry = await _owned(session, id);
    entry.moodId = moodId;
    entry.weatherId = weatherId;
    entry.diaryText = diaryText;
    entry.otherPerspective = otherPerspective;
    entry.futureMessage = futureMessage;
    entry.selfCare = selfCare;
    entry.tomorrowHope = tomorrowHope;
    entry.gratitude = gratitude;
    entry.dream = dream;
    entry.updatedAt = DateTime.now().toUtc();
    return DiaryEntry.db.updateRow(session, entry);
  }

  Future<void> delete(Session session, UuidValue id) async {
    final entry = await _owned(session, id);
    // Reflections keep a plain entryId, so clear them explicitly; images are
    // removed by the database through the foreign key cascade.
    await Reflection.db.deleteWhere(
      session,
      where: (t) => t.entryId.equals(id),
    );
    await DiaryEntry.db.deleteRow(session, entry);
  }

  Future<DiaryEntry> _owned(Session session, UuidValue id) async {
    final userId = currentUserId(session);
    final entry = await DiaryEntry.db.findById(session, id);
    ensureOwned(entry != null && entry.userId == userId);
    return entry!;
  }
}
