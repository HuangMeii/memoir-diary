/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Daily health tracking. One row per user per day.
abstract class HealthLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthLog._({
    this.id,
    required this.userId,
    required this.logDate,
    this.steps,
    this.workoutMinutes,
    this.waterMl,
    this.sleepHours,
    this.weightKg,
    this.note,
    this.workoutType,
    this.workoutIntensity,
    this.sleepBedtime,
    this.sleepWake,
    this.sleepDeepMinutes,
    this.sleepQuality,
    this.sleepNote,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory HealthLog({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
    String? workoutType,
    String? workoutIntensity,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    DateTime? createdAt,
  }) = _HealthLogImpl;

  factory HealthLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthLog(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      logDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['logDate'],
      ),
      steps: jsonSerialization['steps'] as int?,
      workoutMinutes: jsonSerialization['workoutMinutes'] as int?,
      waterMl: jsonSerialization['waterMl'] as int?,
      sleepHours: (jsonSerialization['sleepHours'] as num?)?.toDouble(),
      weightKg: (jsonSerialization['weightKg'] as num?)?.toDouble(),
      note: jsonSerialization['note'] as String?,
      workoutType: jsonSerialization['workoutType'] as String?,
      workoutIntensity: jsonSerialization['workoutIntensity'] as String?,
      sleepBedtime: jsonSerialization['sleepBedtime'] as String?,
      sleepWake: jsonSerialization['sleepWake'] as String?,
      sleepDeepMinutes: jsonSerialization['sleepDeepMinutes'] as int?,
      sleepQuality: jsonSerialization['sleepQuality'] as String?,
      sleepNote: jsonSerialization['sleepNote'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue userId;

  DateTime logDate;

  int? steps;

  int? workoutMinutes;

  int? waterMl;

  double? sleepHours;

  double? weightKg;

  String? note;

  /// Workout (ghi nhận nhanh tập luyện)
  String? workoutType;

  String? workoutIntensity;

  /// Sleep (ghi nhận nhanh giấc ngủ)
  String? sleepBedtime;

  String? sleepWake;

  int? sleepDeepMinutes;

  String? sleepQuality;

  String? sleepNote;

  DateTime createdAt;

  /// Returns a shallow copy of this [HealthLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthLog copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    DateTime? logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
    String? workoutType,
    String? workoutIntensity,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthLog',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      if (steps != null) 'steps': steps,
      if (workoutMinutes != null) 'workoutMinutes': workoutMinutes,
      if (waterMl != null) 'waterMl': waterMl,
      if (sleepHours != null) 'sleepHours': sleepHours,
      if (weightKg != null) 'weightKg': weightKg,
      if (note != null) 'note': note,
      if (workoutType != null) 'workoutType': workoutType,
      if (workoutIntensity != null) 'workoutIntensity': workoutIntensity,
      if (sleepBedtime != null) 'sleepBedtime': sleepBedtime,
      if (sleepWake != null) 'sleepWake': sleepWake,
      if (sleepDeepMinutes != null) 'sleepDeepMinutes': sleepDeepMinutes,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (sleepNote != null) 'sleepNote': sleepNote,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthLog',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      if (steps != null) 'steps': steps,
      if (workoutMinutes != null) 'workoutMinutes': workoutMinutes,
      if (waterMl != null) 'waterMl': waterMl,
      if (sleepHours != null) 'sleepHours': sleepHours,
      if (weightKg != null) 'weightKg': weightKg,
      if (note != null) 'note': note,
      if (workoutType != null) 'workoutType': workoutType,
      if (workoutIntensity != null) 'workoutIntensity': workoutIntensity,
      if (sleepBedtime != null) 'sleepBedtime': sleepBedtime,
      if (sleepWake != null) 'sleepWake': sleepWake,
      if (sleepDeepMinutes != null) 'sleepDeepMinutes': sleepDeepMinutes,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (sleepNote != null) 'sleepNote': sleepNote,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthLogImpl extends HealthLog {
  _HealthLogImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
    String? workoutType,
    String? workoutIntensity,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         logDate: logDate,
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
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthLog copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? logDate,
    Object? steps = _Undefined,
    Object? workoutMinutes = _Undefined,
    Object? waterMl = _Undefined,
    Object? sleepHours = _Undefined,
    Object? weightKg = _Undefined,
    Object? note = _Undefined,
    Object? workoutType = _Undefined,
    Object? workoutIntensity = _Undefined,
    Object? sleepBedtime = _Undefined,
    Object? sleepWake = _Undefined,
    Object? sleepDeepMinutes = _Undefined,
    Object? sleepQuality = _Undefined,
    Object? sleepNote = _Undefined,
    DateTime? createdAt,
  }) {
    return HealthLog(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      steps: steps is int? ? steps : this.steps,
      workoutMinutes: workoutMinutes is int?
          ? workoutMinutes
          : this.workoutMinutes,
      waterMl: waterMl is int? ? waterMl : this.waterMl,
      sleepHours: sleepHours is double? ? sleepHours : this.sleepHours,
      weightKg: weightKg is double? ? weightKg : this.weightKg,
      note: note is String? ? note : this.note,
      workoutType: workoutType is String? ? workoutType : this.workoutType,
      workoutIntensity: workoutIntensity is String?
          ? workoutIntensity
          : this.workoutIntensity,
      sleepBedtime: sleepBedtime is String? ? sleepBedtime : this.sleepBedtime,
      sleepWake: sleepWake is String? ? sleepWake : this.sleepWake,
      sleepDeepMinutes: sleepDeepMinutes is int?
          ? sleepDeepMinutes
          : this.sleepDeepMinutes,
      sleepQuality: sleepQuality is String? ? sleepQuality : this.sleepQuality,
      sleepNote: sleepNote is String? ? sleepNote : this.sleepNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
