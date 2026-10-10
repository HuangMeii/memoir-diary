import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// Health log CRUD, mirroring FastAPI `/health-logs`.
class HealthEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<HealthLog>> list(
    Session session, {
    required DateTime from,
    required DateTime to,
  }) {
    final userId = currentUserId(session);
    final first = dateOnly(from);
    final last = dateOnly(to);
    return HealthLog.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) & (t.logDate >= first) & (t.logDate <= last),
      orderBy: (t) => t.logDate,
    );
  }

  /// Upserts the day's log, so the form can be submitted repeatedly.
  Future<HealthLog> save(
    Session session, {
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
  }) async {
    final userId = currentUserId(session);
    final day = dateOnly(logDate);
    final existing = await HealthLog.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.logDate.equals(day),
    );
    if (existing == null) {
      return HealthLog.db.insertRow(
        session,
        HealthLog(
          userId: userId,
          logDate: day,
          steps: steps,
          workoutMinutes: workoutMinutes,
          waterMl: waterMl,
          sleepHours: sleepHours,
          weightKg: weightKg,
          note: note,
        ),
      );
    }
    existing.steps = steps;
    existing.workoutMinutes = workoutMinutes;
    existing.waterMl = waterMl;
    existing.sleepHours = sleepHours;
    existing.weightKg = weightKg;
    existing.note = note;
    return HealthLog.db.updateRow(session, existing);
  }
}
