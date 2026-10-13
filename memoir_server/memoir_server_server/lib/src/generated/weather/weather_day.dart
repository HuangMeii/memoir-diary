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

/// One forecast day, mapped onto the five weather groups.
abstract class WeatherDay
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WeatherDay._({
    required this.date,
    required this.weatherCode,
    this.weatherId,
    required this.condition,
    required this.icon,
    this.tempMin,
    this.tempMax,
    this.tempAvg,
    this.precipitationMm,
  });

  factory WeatherDay({
    required DateTime date,
    required int weatherCode,
    int? weatherId,
    required String condition,
    required String icon,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
  }) = _WeatherDayImpl;

  factory WeatherDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeatherDay(
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      weatherCode: jsonSerialization['weatherCode'] as int,
      weatherId: jsonSerialization['weatherId'] as int?,
      condition: jsonSerialization['condition'] as String,
      icon: jsonSerialization['icon'] as String,
      tempMin: (jsonSerialization['tempMin'] as num?)?.toDouble(),
      tempMax: (jsonSerialization['tempMax'] as num?)?.toDouble(),
      tempAvg: (jsonSerialization['tempAvg'] as num?)?.toDouble(),
      precipitationMm: (jsonSerialization['precipitationMm'] as num?)
          ?.toDouble(),
    );
  }

  DateTime date;

  int weatherCode;

  int? weatherId;

  String condition;

  String icon;

  double? tempMin;

  double? tempMax;

  double? tempAvg;

  double? precipitationMm;

  /// Returns a shallow copy of this [WeatherDay]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WeatherDay copyWith({
    DateTime? date,
    int? weatherCode,
    int? weatherId,
    String? condition,
    String? icon,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeatherDay',
      'date': date.toJson(),
      'weatherCode': weatherCode,
      if (weatherId != null) 'weatherId': weatherId,
      'condition': condition,
      'icon': icon,
      if (tempMin != null) 'tempMin': tempMin,
      if (tempMax != null) 'tempMax': tempMax,
      if (tempAvg != null) 'tempAvg': tempAvg,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeatherDay',
      'date': date.toJson(),
      'weatherCode': weatherCode,
      if (weatherId != null) 'weatherId': weatherId,
      'condition': condition,
      'icon': icon,
      if (tempMin != null) 'tempMin': tempMin,
      if (tempMax != null) 'tempMax': tempMax,
      if (tempAvg != null) 'tempAvg': tempAvg,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WeatherDayImpl extends WeatherDay {
  _WeatherDayImpl({
    required DateTime date,
    required int weatherCode,
    int? weatherId,
    required String condition,
    required String icon,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
  }) : super._(
         date: date,
         weatherCode: weatherCode,
         weatherId: weatherId,
         condition: condition,
         icon: icon,
         tempMin: tempMin,
         tempMax: tempMax,
         tempAvg: tempAvg,
         precipitationMm: precipitationMm,
       );

  /// Returns a shallow copy of this [WeatherDay]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WeatherDay copyWith({
    DateTime? date,
    int? weatherCode,
    Object? weatherId = _Undefined,
    String? condition,
    String? icon,
    Object? tempMin = _Undefined,
    Object? tempMax = _Undefined,
    Object? tempAvg = _Undefined,
    Object? precipitationMm = _Undefined,
  }) {
    return WeatherDay(
      date: date ?? this.date,
      weatherCode: weatherCode ?? this.weatherCode,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      condition: condition ?? this.condition,
      icon: icon ?? this.icon,
      tempMin: tempMin is double? ? tempMin : this.tempMin,
      tempMax: tempMax is double? ? tempMax : this.tempMax,
      tempAvg: tempAvg is double? ? tempAvg : this.tempAvg,
      precipitationMm: precipitationMm is double?
          ? precipitationMm
          : this.precipitationMm,
    );
  }
}
