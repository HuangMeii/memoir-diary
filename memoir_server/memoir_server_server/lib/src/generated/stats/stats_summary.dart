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
import 'package:memoir_server_server/src/generated/protocol.dart' as _is9lv3rz;
import 'package:serverpod/serverpod.dart' as _is;

/// Monthly summary response, mirroring FastAPI `StatsSummaryOut`.
abstract class StatsSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StatsSummary._({
    required this.month,
    required this.daysLogged,
    required this.moodCounts,
    required this.weatherCounts,
    required this.totalSteps,
    required this.totalWorkoutMinutes,
  });

  factory StatsSummary({
    required String month,
    required int daysLogged,
    required Map<String, int> moodCounts,
    required Map<String, int> weatherCounts,
    required int totalSteps,
    required int totalWorkoutMinutes,
  }) = _StatsSummaryImpl;

  factory StatsSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return StatsSummary(
      month: jsonSerialization['month'] as String,
      daysLogged: jsonSerialization['daysLogged'] as int,
      moodCounts: _is9lv3rz.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['moodCounts'],
      ),
      weatherCounts: _is9lv3rz.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['weatherCounts'],
      ),
      totalSteps: jsonSerialization['totalSteps'] as int,
      totalWorkoutMinutes: jsonSerialization['totalWorkoutMinutes'] as int,
    );
  }

  String month;

  int daysLogged;

  Map<String, int> moodCounts;

  Map<String, int> weatherCounts;

  int totalSteps;

  int totalWorkoutMinutes;

  /// Returns a shallow copy of this [StatsSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StatsSummary copyWith({
    String? month,
    int? daysLogged,
    Map<String, int>? moodCounts,
    Map<String, int>? weatherCounts,
    int? totalSteps,
    int? totalWorkoutMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StatsSummary',
      'month': month,
      'daysLogged': daysLogged,
      'moodCounts': moodCounts.toJson(),
      'weatherCounts': weatherCounts.toJson(),
      'totalSteps': totalSteps,
      'totalWorkoutMinutes': totalWorkoutMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StatsSummary',
      'month': month,
      'daysLogged': daysLogged,
      'moodCounts': moodCounts.toJson(),
      'weatherCounts': weatherCounts.toJson(),
      'totalSteps': totalSteps,
      'totalWorkoutMinutes': totalWorkoutMinutes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StatsSummaryImpl extends StatsSummary {
  _StatsSummaryImpl({
    required String month,
    required int daysLogged,
    required Map<String, int> moodCounts,
    required Map<String, int> weatherCounts,
    required int totalSteps,
    required int totalWorkoutMinutes,
  }) : super._(
         month: month,
         daysLogged: daysLogged,
         moodCounts: moodCounts,
         weatherCounts: weatherCounts,
         totalSteps: totalSteps,
         totalWorkoutMinutes: totalWorkoutMinutes,
       );

  /// Returns a shallow copy of this [StatsSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StatsSummary copyWith({
    String? month,
    int? daysLogged,
    Map<String, int>? moodCounts,
    Map<String, int>? weatherCounts,
    int? totalSteps,
    int? totalWorkoutMinutes,
  }) {
    return StatsSummary(
      month: month ?? this.month,
      daysLogged: daysLogged ?? this.daysLogged,
      moodCounts:
          moodCounts ??
          this.moodCounts.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      weatherCounts:
          weatherCounts ??
          this.weatherCounts.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      totalSteps: totalSteps ?? this.totalSteps,
      totalWorkoutMinutes: totalWorkoutMinutes ?? this.totalWorkoutMinutes,
    );
  }
}
