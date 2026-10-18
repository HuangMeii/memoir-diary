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
import 'package:memoir_server_client/src/protocol/protocol.dart' as _itoi32v3;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../health/health_activity.dart' as _iwh4b4v7;
import '../health/health_log.dart' as _i8ee25fm;
import '../health/health_profile.dart' as _i79m2hrp;
import '../health/health_water_entry.dart' as _idbnyu4z;

/// Everything the dashboard needs for one day, in a single round trip.
abstract class HealthDayOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthDayOverview._({
    required this.date,
    this.log,
    required this.water,
    required this.activities,
    this.profile,
  });

  factory HealthDayOverview({
    required DateTime date,
    _i8ee25fm.HealthLog? log,
    required List<_idbnyu4z.HealthWaterEntry> water,
    required List<_iwh4b4v7.HealthActivity> activities,
    _i79m2hrp.HealthProfile? profile,
  }) = _HealthDayOverviewImpl;

  factory HealthDayOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthDayOverview(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      log: jsonSerialization['log'] == null
          ? null
          : _itoi32v3.Protocol().deserialize<_i8ee25fm.HealthLog>(
              jsonSerialization['log'],
            ),
      water: _itoi32v3.Protocol().deserialize<List<_idbnyu4z.HealthWaterEntry>>(
        jsonSerialization['water'],
      ),
      activities: _itoi32v3.Protocol()
          .deserialize<List<_iwh4b4v7.HealthActivity>>(
            jsonSerialization['activities'],
          ),
      profile: jsonSerialization['profile'] == null
          ? null
          : _itoi32v3.Protocol().deserialize<_i79m2hrp.HealthProfile>(
              jsonSerialization['profile'],
            ),
    );
  }

  DateTime date;

  /// Null when nothing has been logged for the day yet.
  _i8ee25fm.HealthLog? log;

  List<_idbnyu4z.HealthWaterEntry> water;

  List<_iwh4b4v7.HealthActivity> activities;

  /// Null until the user saves body metrics or goals.
  _i79m2hrp.HealthProfile? profile;

  /// Returns a shallow copy of this [HealthDayOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthDayOverview copyWith({
    DateTime? date,
    _i8ee25fm.HealthLog? log,
    List<_idbnyu4z.HealthWaterEntry>? water,
    List<_iwh4b4v7.HealthActivity>? activities,
    _i79m2hrp.HealthProfile? profile,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthDayOverview',
      'date': date.toJson(),
      if (log != null) 'log': log?.toJson(),
      'water': water.toJson(valueToJson: (v) => v.toJson()),
      'activities': activities.toJson(valueToJson: (v) => v.toJson()),
      if (profile != null) 'profile': profile?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthDayOverview',
      'date': date.toJson(),
      if (log != null) 'log': log?.toJsonForProtocol(),
      'water': water.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'activities': activities.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (profile != null) 'profile': profile?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthDayOverviewImpl extends HealthDayOverview {
  _HealthDayOverviewImpl({
    required DateTime date,
    _i8ee25fm.HealthLog? log,
    required List<_idbnyu4z.HealthWaterEntry> water,
    required List<_iwh4b4v7.HealthActivity> activities,
    _i79m2hrp.HealthProfile? profile,
  }) : super._(
         date: date,
         log: log,
         water: water,
         activities: activities,
         profile: profile,
       );

  /// Returns a shallow copy of this [HealthDayOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthDayOverview copyWith({
    DateTime? date,
    Object? log = _Undefined,
    List<_idbnyu4z.HealthWaterEntry>? water,
    List<_iwh4b4v7.HealthActivity>? activities,
    Object? profile = _Undefined,
  }) {
    return HealthDayOverview(
      date: date ?? this.date,
      log: log is _i8ee25fm.HealthLog? ? log : this.log?.copyWith(),
      water: water ?? this.water.map((e0) => e0.copyWith()).toList(),
      activities:
          activities ?? this.activities.map((e0) => e0.copyWith()).toList(),
      profile: profile is _i79m2hrp.HealthProfile?
          ? profile
          : this.profile?.copyWith(),
    );
  }
}
