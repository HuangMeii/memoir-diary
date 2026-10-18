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
import 'package:serverpod/serverpod.dart' as _is;

/// One day of a trend series for the selected metric.
abstract class HealthTrendPoint
    implements _is.SerializableModel, _is.ProtocolSerialization {
  HealthTrendPoint._({
    required this.date,
    this.value,
    this.goal,
  });

  factory HealthTrendPoint({
    required DateTime date,
    double? value,
    double? goal,
  }) = _HealthTrendPointImpl;

  factory HealthTrendPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthTrendPoint(
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      value: (jsonSerialization['value'] as num?)?.toDouble(),
      goal: (jsonSerialization['goal'] as num?)?.toDouble(),
    );
  }

  DateTime date;

  /// Null when the day has no data for the metric (keeps the axis honest).
  double? value;

  /// Goal in force for that day, so the chart can draw the target line.
  double? goal;

  /// Returns a shallow copy of this [HealthTrendPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthTrendPoint copyWith({
    DateTime? date,
    double? value,
    double? goal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthTrendPoint',
      'date': date.toJson(),
      if (value != null) 'value': value,
      if (goal != null) 'goal': goal,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthTrendPoint',
      'date': date.toJson(),
      if (value != null) 'value': value,
      if (goal != null) 'goal': goal,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthTrendPointImpl extends HealthTrendPoint {
  _HealthTrendPointImpl({
    required DateTime date,
    double? value,
    double? goal,
  }) : super._(
         date: date,
         value: value,
         goal: goal,
       );

  /// Returns a shallow copy of this [HealthTrendPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthTrendPoint copyWith({
    DateTime? date,
    Object? value = _Undefined,
    Object? goal = _Undefined,
  }) {
    return HealthTrendPoint(
      date: date ?? this.date,
      value: value is double? ? value : this.value,
      goal: goal is double? ? goal : this.goal,
    );
  }
}
