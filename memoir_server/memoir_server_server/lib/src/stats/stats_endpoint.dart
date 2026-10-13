import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Month grids and summary, mirroring FastAPI `/stats`.
class StatsEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<GridCell>> moodGrid(Session session, {required String month}) =>
      _grid(session, month, isMood: true);

  Future<List<GridCell>> weatherGrid(
    Session session, {
    required String month,
  }) => _grid(session, month, isMood: false);

  Future<StatsSummary> summary(Session session, {required String month}) async {
    final userId = currentUserId(session);
    final (first, last) = monthBounds(month);
    final entries = await _monthEntries(session, userId, first, last);

    final moods = {for (final m in await Mood.db.find(session)) m.id: m.code};
    final weathers = {
      for (final w in await Weather.db.find(session)) w.id: w.code,
    };

    final moodCounts = <String, int>{};
    final weatherCounts = <String, int>{};
    for (final entry in entries) {
      final mood = entry.moodId == null ? null : moods[entry.moodId];
      if (mood != null) moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
      final weather = entry.weatherId == null
          ? null
          : weathers[entry.weatherId];
      if (weather != null) {
        weatherCounts[weather] = (weatherCounts[weather] ?? 0) + 1;
      }
    }

    final health = await HealthLog.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) & (t.logDate >= first) & (t.logDate <= last),
    );
    var totalSteps = 0;
    var totalWorkout = 0;
    for (final log in health) {
      totalSteps += log.steps ?? 0;
      totalWorkout += log.workoutMinutes ?? 0;
    }

    return StatsSummary(
      month: month,
      daysLogged: entries.length,
      moodCounts: moodCounts,
      weatherCounts: weatherCounts,
      totalSteps: totalSteps,
      totalWorkoutMinutes: totalWorkout,
    );
  }

  Future<List<GridCell>> _grid(
    Session session,
    String month, {
    required bool isMood,
  }) async {
    final userId = currentUserId(session);
    final (first, last) = monthBounds(month);
    final entries = await _monthEntries(session, userId, first, last);

    final moods = {for (final m in await Mood.db.find(session)) m.id: m};
    final weathers = {for (final w in await Weather.db.find(session)) w.id: w};

    return entries.map((entry) {
      if (isMood) {
        final mood = entry.moodId == null ? null : moods[entry.moodId];
        return GridCell(
          date: entry.entryDate,
          code: mood?.code,
          label: mood?.labelVi,
          color: mood?.colorHex,
        );
      }
      final weather = entry.weatherId == null
          ? null
          : weathers[entry.weatherId];
      return GridCell(
        date: entry.entryDate,
        code: weather?.code,
        label: weather?.labelVi,
        color: weather?.colorHex,
      );
    }).toList();
  }

  Future<List<DiaryEntry>> _monthEntries(
    Session session,
    UuidValue userId,
    DateTime first,
    DateTime last,
  ) {
    return DiaryEntry.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.entryDate >= first) &
          (t.entryDate <= last),
      orderBy: (t) => t.entryDate,
    );
  }
}
