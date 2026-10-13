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
import '../weather/weather_day.dart' as _ixtooy5a;

/// Now plus the multi-day forecast, or the stored snapshot when the API fails.
abstract class WeatherForecast
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WeatherForecast._({
    required this.locationName,
    this.currentTime,
    this.currentTemperature,
    required this.currentWeatherCode,
    required this.condition,
    required this.icon,
    required this.daily,
    required this.source,
  });

  factory WeatherForecast({
    required String locationName,
    DateTime? currentTime,
    double? currentTemperature,
    required int currentWeatherCode,
    required String condition,
    required String icon,
    required List<_ixtooy5a.WeatherDay> daily,
    required String source,
  }) = _WeatherForecastImpl;

  factory WeatherForecast.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeatherForecast(
      locationName: jsonSerialization['locationName'] as String,
      currentTime: jsonSerialization['currentTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['currentTime'],
            ),
      currentTemperature: (jsonSerialization['currentTemperature'] as num?)
          ?.toDouble(),
      currentWeatherCode: jsonSerialization['currentWeatherCode'] as int,
      condition: jsonSerialization['condition'] as String,
      icon: jsonSerialization['icon'] as String,
      daily: _is9lv3rz.Protocol().deserialize<List<_ixtooy5a.WeatherDay>>(
        jsonSerialization['daily'],
      ),
      source: jsonSerialization['source'] as String,
    );
  }

  String locationName;

  DateTime? currentTime;

  double? currentTemperature;

  int currentWeatherCode;

  String condition;

  String icon;

  List<_ixtooy5a.WeatherDay> daily;

  /// "api" or "cache".
  String source;

  /// Returns a shallow copy of this [WeatherForecast]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WeatherForecast copyWith({
    String? locationName,
    DateTime? currentTime,
    double? currentTemperature,
    int? currentWeatherCode,
    String? condition,
    String? icon,
    List<_ixtooy5a.WeatherDay>? daily,
    String? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeatherForecast',
      'locationName': locationName,
      if (currentTime != null) 'currentTime': currentTime?.toJson(),
      if (currentTemperature != null) 'currentTemperature': currentTemperature,
      'currentWeatherCode': currentWeatherCode,
      'condition': condition,
      'icon': icon,
      'daily': daily.toJson(valueToJson: (v) => v.toJson()),
      'source': source,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeatherForecast',
      'locationName': locationName,
      if (currentTime != null) 'currentTime': currentTime?.toJson(),
      if (currentTemperature != null) 'currentTemperature': currentTemperature,
      'currentWeatherCode': currentWeatherCode,
      'condition': condition,
      'icon': icon,
      'daily': daily.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'source': source,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WeatherForecastImpl extends WeatherForecast {
  _WeatherForecastImpl({
    required String locationName,
    DateTime? currentTime,
    double? currentTemperature,
    required int currentWeatherCode,
    required String condition,
    required String icon,
    required List<_ixtooy5a.WeatherDay> daily,
    required String source,
  }) : super._(
         locationName: locationName,
         currentTime: currentTime,
         currentTemperature: currentTemperature,
         currentWeatherCode: currentWeatherCode,
         condition: condition,
         icon: icon,
         daily: daily,
         source: source,
       );

  /// Returns a shallow copy of this [WeatherForecast]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WeatherForecast copyWith({
    String? locationName,
    Object? currentTime = _Undefined,
    Object? currentTemperature = _Undefined,
    int? currentWeatherCode,
    String? condition,
    String? icon,
    List<_ixtooy5a.WeatherDay>? daily,
    String? source,
  }) {
    return WeatherForecast(
      locationName: locationName ?? this.locationName,
      currentTime: currentTime is DateTime? ? currentTime : this.currentTime,
      currentTemperature: currentTemperature is double?
          ? currentTemperature
          : this.currentTemperature,
      currentWeatherCode: currentWeatherCode ?? this.currentWeatherCode,
      condition: condition ?? this.condition,
      icon: icon ?? this.icon,
      daily: daily ?? this.daily.map((e0) => e0.copyWith()).toList(),
      source: source ?? this.source,
    );
  }
}
