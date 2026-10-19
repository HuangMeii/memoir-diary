import '../datasources/backend_data_source.dart';
import '../models.dart';
import '../providers.dart' show dayKey;

/// Typed access to the `health` endpoint family.
///
/// Screens and providers only ever see these methods and the model classes —
/// no `Map<String, dynamic>` or snake_case key escapes this layer.
class HealthRepository {
  const HealthRepository(this._source);

  final BackendDataSource _source;

  /// Daily logs within `[from, to]` (inclusive `YYYY-MM-DD`), newest first.
  ///
  /// Kept unchanged for the old health screen and `monthSummaryProvider`.
  Future<List<HealthLog>> logs({
    required String from,
    required String to,
  }) async {
    final data = await _source.get(
      '/health-logs',
      query: {'from': from, 'to': to},
    );
    return (data as List)
        .map((item) => HealthLog.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Upsert the log for [logDate]; only non-null fields are sent, so a blank
  /// field never wipes a stored value.
  Future<HealthLog> save({
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    String? workoutType,
    String? workoutIntensity,
    int? waterMl,
    double? sleepHours,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    double? weightKg,
    String? note,
  }) async {
    final data = await _source.post(
      '/health-logs',
      data: {
        'log_date': dayKey(logDate),
        if (steps != null) 'steps': steps,
        if (workoutMinutes != null) 'workout_minutes': workoutMinutes,
        if (workoutType != null) 'workout_type': workoutType,
        if (workoutIntensity != null) 'workout_intensity': workoutIntensity,
        if (waterMl != null) 'water_ml': waterMl,
        if (sleepHours != null) 'sleep_hours': sleepHours,
        if (sleepBedtime != null) 'sleep_bedtime': sleepBedtime,
        if (sleepWake != null) 'sleep_wake': sleepWake,
        if (sleepDeepMinutes != null) 'sleep_deep_minutes': sleepDeepMinutes,
        if (sleepQuality != null) 'sleep_quality': sleepQuality,
        if (sleepNote != null) 'sleep_note': sleepNote,
        if (weightKg != null) 'weight_kg': weightKg,
        if (note != null) 'note': note,
      },
    );
    return HealthLog.fromJson(data as Map<String, dynamic>);
  }

  /// Everything the dashboard shows for one day, in a single round trip.
  Future<HealthDayOverview> day(DateTime date) async {
    final data = await _source.get(
      '/health/day',
      query: {'date': dayKey(date)},
    );
    return HealthDayOverview.fromJson(data as Map<String, dynamic>);
  }

  /// One point per day in `[from, to]`; days without data have `value == null`.
  Future<List<HealthTrendPoint>> trends({
    required String from,
    required String to,
    required HealthMetric metric,
  }) async {
    final data = await _source.get(
      '/health/trends',
      query: {'from': from, 'to': to, 'metric': metric.wire},
    );
    return (data as List)
        .map((item) => HealthTrendPoint.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Log one drink and return the refreshed day, so the UI can update without
  /// re-fetching `day(...)`.
  Future<HealthDayOverview> addWater({
    required DateTime logDate,
    required int amountMl,
    DateTime? recordedAt,
    String? note,
  }) async {
    final data = await _source.post(
      '/health/water',
      data: {
        'log_date': dayKey(logDate),
        'amount_ml': amountMl,
        if (recordedAt != null) 'recorded_at': recordedAt.toIso8601String(),
        if (note != null) 'note': note,
      },
    );
    return HealthDayOverview.fromJson(data as Map<String, dynamic>);
  }

  /// Remove one drink and return the refreshed day.
  Future<HealthDayOverview> removeWater(String id) async {
    final data = await _source.delete('/health/water/$id');
    return HealthDayOverview.fromJson(data as Map<String, dynamic>);
  }

  /// Add a timeline milestone and return the refreshed day.
  Future<HealthDayOverview> addActivity({
    required DateTime logDate,
    required String atTime,
    required String title,
    String? detail,
  }) async {
    final data = await _source.post(
      '/health/activity',
      data: {
        'log_date': dayKey(logDate),
        'at_time': atTime,
        'title': title,
        if (detail != null) 'detail': detail,
      },
    );
    return HealthDayOverview.fromJson(data as Map<String, dynamic>);
  }

  /// Remove a timeline milestone and return the refreshed day.
  Future<HealthDayOverview> removeActivity(String id) async {
    final data = await _source.delete('/health/activity/$id');
    return HealthDayOverview.fromJson(data as Map<String, dynamic>);
  }

  /// The saved body profile & goals, or `null` before the user ever saved one
  /// (never creates a row from the client).
  Future<HealthProfile?> profile() async {
    final data = await _source.get('/health/profile');
    return data == null
        ? null
        : HealthProfile.fromJson(data as Map<String, dynamic>);
  }

  /// Create or update the single profile row; `null` fields clear that value.
  Future<HealthProfile> saveProfile({
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
  }) async {
    final data = await _source.put(
      '/health/profile',
      data: {
        if (heightCm != null) 'height_cm': heightCm,
        if (weightGoalKg != null) 'weight_goal_kg': weightGoalKg,
        if (weightStartKg != null) 'weight_start_kg': weightStartKg,
        if (stepsGoal != null) 'steps_goal': stepsGoal,
        if (workoutGoalMinutes != null)
          'workout_goal_minutes': workoutGoalMinutes,
        if (waterGoalMl != null) 'water_goal_ml': waterGoalMl,
        if (sleepGoalHours != null) 'sleep_goal_hours': sleepGoalHours,
      },
    );
    return HealthProfile.fromJson(data as Map<String, dynamic>);
  }
}
