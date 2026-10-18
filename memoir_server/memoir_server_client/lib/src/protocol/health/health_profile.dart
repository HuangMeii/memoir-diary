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

/// Health body measurements and daily goals. One row per user.
abstract class HealthProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthProfile._({
    this.id,
    required this.userId,
    this.heightCm,
    this.weightGoalKg,
    this.weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) : stepsGoal = stepsGoal ?? 8000,
       workoutGoalMinutes = workoutGoalMinutes ?? 60,
       waterGoalMl = waterGoalMl ?? 2000,
       sleepGoalHours = sleepGoalHours ?? 8.0,
       updatedAt = updatedAt ?? DateTime.now();

  factory HealthProfile({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) = _HealthProfileImpl;

  factory HealthProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      heightCm: jsonSerialization['heightCm'] as int?,
      weightGoalKg: (jsonSerialization['weightGoalKg'] as num?)?.toDouble(),
      weightStartKg: (jsonSerialization['weightStartKg'] as num?)?.toDouble(),
      stepsGoal: jsonSerialization['stepsGoal'] as int?,
      workoutGoalMinutes: jsonSerialization['workoutGoalMinutes'] as int?,
      waterGoalMl: jsonSerialization['waterGoalMl'] as int?,
      sleepGoalHours: (jsonSerialization['sleepGoalHours'] as num?)?.toDouble(),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue userId;

  /// Body metrics; height feeds BMI/BMR, so it is stored once.
  int? heightCm;

  double? weightGoalKg;

  double? weightStartKg;

  /// Daily goals shown on the dashboard hero cards.
  int stepsGoal;

  int workoutGoalMinutes;

  int waterGoalMl;

  double sleepGoalHours;

  DateTime updatedAt;

  /// Returns a shallow copy of this [HealthProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthProfile copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (heightCm != null) 'heightCm': heightCm,
      if (weightGoalKg != null) 'weightGoalKg': weightGoalKg,
      if (weightStartKg != null) 'weightStartKg': weightStartKg,
      'stepsGoal': stepsGoal,
      'workoutGoalMinutes': workoutGoalMinutes,
      'waterGoalMl': waterGoalMl,
      'sleepGoalHours': sleepGoalHours,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (heightCm != null) 'heightCm': heightCm,
      if (weightGoalKg != null) 'weightGoalKg': weightGoalKg,
      if (weightStartKg != null) 'weightStartKg': weightStartKg,
      'stepsGoal': stepsGoal,
      'workoutGoalMinutes': workoutGoalMinutes,
      'waterGoalMl': waterGoalMl,
      'sleepGoalHours': sleepGoalHours,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthProfileImpl extends HealthProfile {
  _HealthProfileImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         heightCm: heightCm,
         weightGoalKg: weightGoalKg,
         weightStartKg: weightStartKg,
         stepsGoal: stepsGoal,
         workoutGoalMinutes: workoutGoalMinutes,
         waterGoalMl: waterGoalMl,
         sleepGoalHours: sleepGoalHours,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HealthProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    Object? heightCm = _Undefined,
    Object? weightGoalKg = _Undefined,
    Object? weightStartKg = _Undefined,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) {
    return HealthProfile(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      heightCm: heightCm is int? ? heightCm : this.heightCm,
      weightGoalKg: weightGoalKg is double? ? weightGoalKg : this.weightGoalKg,
      weightStartKg: weightStartKg is double?
          ? weightStartKg
          : this.weightStartKg,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      workoutGoalMinutes: workoutGoalMinutes ?? this.workoutGoalMinutes,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      sleepGoalHours: sleepGoalHours ?? this.sleepGoalHours,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
