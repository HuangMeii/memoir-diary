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

    /// New fields (H1-S1): workout.
    String? workoutType,
    String? workoutIntensity,

    /// New fields (H1-S1): sleep.
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
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
          workoutType: workoutType,
          workoutIntensity: workoutIntensity,
          sleepBedtime: sleepBedtime,
          sleepWake: sleepWake,
          sleepDeepMinutes: sleepDeepMinutes,
          sleepQuality: sleepQuality,
          sleepNote: sleepNote,
        ),
      );
    }
    existing.steps = steps;
    existing.workoutMinutes = workoutMinutes;
    existing.waterMl = waterMl;
    existing.sleepHours = sleepHours;
    existing.weightKg = weightKg;
    existing.note = note;
    existing.workoutType = workoutType;
    existing.workoutIntensity = workoutIntensity;
    existing.sleepBedtime = sleepBedtime;
    existing.sleepWake = sleepWake;
    existing.sleepDeepMinutes = sleepDeepMinutes;
    existing.sleepQuality = sleepQuality;
    existing.sleepNote = sleepNote;
    return HealthLog.db.updateRow(session, existing);
  }

  /// Everything the dashboard needs for one day, in a single round trip.
  Future<HealthDayOverview> dayOverview(
    Session session, {
    required DateTime date,
  }) async {
    final userId = currentUserId(session);
    final day = dateOnly(date);

    final log = await HealthLog.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.logDate.equals(day),
    );

    final water = await HealthWaterEntry.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.logDate.equals(day),
      orderBy: (t) => t.recordedAt,
    );

    final activities = await HealthActivity.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.logDate.equals(day),
      orderBy: (t) => t.atTime,
    );

    final profile = await HealthProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    return HealthDayOverview(
      date: day,
      log: log,
      water: water,
      activities: activities,
      profile: profile,
    );
  }

  /// Chuỗi xu hướng theo metric, luôn đủ số ngày của kỳ (ngày trống ⇒ `value == null`).
  Future<List<HealthTrendPoint>> trends(
    Session session, {
    required DateTime from,
    required DateTime to,
    required String metric,
  }) async {
    final userId = currentUserId(session);
    final validMetrics = {'steps', 'workout', 'water', 'sleep', 'weight'};
    if (!validMetrics.contains(metric)) {
      throw ApiException(
        message: 'Invalid metric: $metric',
        code: 'badRequest',
      );
    }

    final profile = await HealthProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    double? goal;
    if (profile == null) {
      switch (metric) {
        case 'steps':
          goal = 8000;
        case 'workout':
          goal = 60;
        case 'water':
          goal = 2000;
        case 'sleep':
          goal = 8;
        case 'weight':
          goal = null;
      }
    } else {
      switch (metric) {
        case 'steps':
          goal = profile.stepsGoal.toDouble();
        case 'workout':
          goal = profile.workoutGoalMinutes.toDouble();
        case 'water':
          goal = profile.waterGoalMl.toDouble();
        case 'sleep':
          goal = profile.sleepGoalHours;
        case 'weight':
          goal = profile.weightGoalKg;
      }
    }

    // Xây dựng dãy ngày theo múi giờ Việt Nam (UTC+7).
    final fromVn = dateOnlyVn(from);
    final toVn = dateOnlyVn(to);
    final days = <DateTime>[];
    var d = fromVn;
    while (!d.isAfter(toVn)) {
      days.add(d);
      d = d.add(const Duration(days: 1));
    }

    final result = <HealthTrendPoint>[];
    for (final day in days) {
      final (startUtc, endUtc) = vnDayRangeUtc(day);
      final row = await HealthLog.db.findFirstRow(
        session,
        where: (t) =>
            t.userId.equals(userId) &
            (t.logDate >= startUtc) &
            (t.logDate < endUtc),
      );

      double? value;
      if (row != null) {
        switch (metric) {
          case 'steps':
            value = row.steps?.toDouble();
          case 'workout':
            value = row.workoutMinutes?.toDouble();
          case 'water':
            value = row.waterMl?.toDouble();
          case 'sleep':
            value = row.sleepHours;
          case 'weight':
            value = row.weightKg;
        }
      }

      result.add(
        HealthTrendPoint(
          date: day,
          value: value,
          goal: goal,
        ),
      );
    }
    return result;
  }

  /// Thêm một lần uống nước, rồi tính lại tổng nước của ngày vào `health_logs.waterMl`.
  Future<HealthDayOverview> waterAdd(
    Session session, {
    required DateTime logDate,
    required int amountMl,
    DateTime? recordedAt,
    String? note,
  }) async {
    final userId = currentUserId(session);
    final day = dateOnly(logDate);
    final recorded = recordedAt ?? DateTime.now();

    await HealthWaterEntry.db.insertRow(
      session,
      HealthWaterEntry(
        userId: userId,
        logDate: day,
        amountMl: amountMl,
        recordedAt: recorded,
        note: note,
      ),
    );

    return _recalcWaterAndOverview(session, userId, day);
  }

  /// Xoá một lần uống nước (chủ sở hữu chỉ), tính lại tổng và trả nội dung ngày.
  Future<HealthDayOverview> waterRemove(
    Session session, {
    required UuidValue id,
  }) async {
    final userId = currentUserId(session);
    final entry = await HealthWaterEntry.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.userId.equals(userId),
    );
    if (entry == null) {
      throw ApiException(message: 'Not found', code: 'notFound');
    }
    final day = dateOnly(entry.logDate);
    await HealthWaterEntry.db.deleteRow(session, entry);
    return _recalcWaterAndOverview(session, userId, day);
  }

  /// Thêm một mốc hoạt động (chủ sở hữu chỉ), rồi trả lại nội dung ngày.
  Future<HealthDayOverview> activityAdd(
    Session session, {
    required DateTime logDate,
    required String atTime,
    required String title,
    String? detail,
  }) async {
    final userId = currentUserId(session);
    final day = dateOnly(logDate);
    await HealthActivity.db.insertRow(
      session,
      HealthActivity(
        userId: userId,
        logDate: day,
        atTime: atTime,
        title: title,
        detail: detail,
        kind: 'note',
      ),
    );
    return dayOverview(session, date: day);
  }

  /// Xoá một mốc hoạt động (chủ sở hữu chỉ), rồi trả lại nội dung ngày.
  Future<HealthDayOverview> activityRemove(
    Session session, {
    required UuidValue id,
  }) async {
    final userId = currentUserId(session);
    final entry = await HealthActivity.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id) & t.userId.equals(userId),
    );
    if (entry == null) {
      throw ApiException(message: 'Not found', code: 'notFound');
    }
    final day = dateOnly(entry.logDate);
    await HealthActivity.db.deleteRow(session, entry);
    return dayOverview(session, date: day);
  }

  /// Lấy thông số cơ thể & mục tiêu của user hiện tại.
  Future<HealthProfile?> profileGet(Session session) async {
    final userId = currentUserId(session);
    return HealthProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  /// Lưu/cập nhật thông số cơ thể & mục tiêu (1 hàng / user).
  Future<HealthProfile> profileSave(
    Session session, {
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
  }) async {
    final userId = currentUserId(session);
    final existing = await HealthProfile.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    if (existing == null) {
      return HealthProfile.db.insertRow(
        session,
        HealthProfile(
          userId: userId,
          heightCm: heightCm,
          weightGoalKg: weightGoalKg,
          weightStartKg: weightStartKg,
          stepsGoal: stepsGoal ?? 8000,
          workoutGoalMinutes: workoutGoalMinutes ?? 60,
          waterGoalMl: waterGoalMl ?? 2000,
          sleepGoalHours: sleepGoalHours ?? 8,
        ),
      );
    }
    existing.heightCm = heightCm ?? existing.heightCm;
    existing.weightGoalKg = weightGoalKg ?? existing.weightGoalKg;
    existing.weightStartKg = weightStartKg ?? existing.weightStartKg;
    existing.stepsGoal = stepsGoal ?? existing.stepsGoal;
    existing.workoutGoalMinutes =
        workoutGoalMinutes ?? existing.workoutGoalMinutes;
    existing.waterGoalMl = waterGoalMl ?? existing.waterGoalMl;
    existing.sleepGoalHours = sleepGoalHours ?? existing.sleepGoalHours;
    return HealthProfile.db.updateRow(session, existing);
  }

  // ── private helpers ──
  Future<HealthDayOverview> _recalcWaterAndOverview(
    Session session,
    UuidValue userId,
    DateTime day,
  ) async {
    final entries = await HealthWaterEntry.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.logDate.equals(day),
    );
    final total = entries.fold<int>(0, (sum, e) => sum + e.amountMl);

    final existing = await HealthLog.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.logDate.equals(day),
    );
    if (existing == null) {
      await HealthLog.db.insertRow(
        session,
        HealthLog(
          userId: userId,
          logDate: day,
          waterMl: total,
        ),
      );
    } else {
      existing.waterMl = total;
      await HealthLog.db.updateRow(session, existing);
    }
    return dayOverview(session, date: day);
  }
}

/// Chuyển đổi [value] sang ngày theo múi giờ Việt Nam (UTC+7).
DateTime dateOnlyVn(DateTime value) {
  final vn = value.add(const Duration(hours: 7));
  return DateTime.utc(vn.year, vn.month, vn.day);
}

/// Khoảng UTC của một ngày VN [vnDate] (00:00 VN → 23:59 VN).
(DateTime, DateTime) vnDayRangeUtc(DateTime vnDate) {
  final startUtc = DateTime.utc(
    vnDate.year,
    vnDate.month,
    vnDate.day,
  ).subtract(const Duration(hours: 7));
  final endUtc = startUtc.add(const Duration(days: 1));
  return (startUtc, endUtc);
}
