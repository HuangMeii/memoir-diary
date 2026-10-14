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

/// Weather at one point of the route, at the time the traveller is expected to
/// be there. The five weather groups reuse the `weathers` lookup, so `condition`
/// and `icon` match the wording used everywhere else in the app.
abstract class RouteWeatherSample
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RouteWeatherSample._({
    required this.seq,
    required this.label,
    required this.kind,
    required this.lat,
    required this.lon,
    required this.distanceFromStartMeters,
    required this.arrivalAt,
    this.weatherCode,
    this.weatherGroup,
    this.condition,
    this.icon,
    this.tempC,
    this.precipitationMm,
    this.precipitationProbability,
    this.windSpeedKmh,
    required this.severity,
    required this.reasons,
    required this.status,
  });

  factory RouteWeatherSample({
    required int seq,
    required String label,
    required String kind,
    required double lat,
    required double lon,
    required int distanceFromStartMeters,
    required DateTime arrivalAt,
    int? weatherCode,
    String? weatherGroup,
    String? condition,
    String? icon,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    required String severity,
    required List<String> reasons,
    required String status,
  }) = _RouteWeatherSampleImpl;

  factory RouteWeatherSample.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteWeatherSample(
      seq: jsonSerialization['seq'] as int,
      label: jsonSerialization['label'] as String,
      kind: jsonSerialization['kind'] as String,
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
      distanceFromStartMeters:
          jsonSerialization['distanceFromStartMeters'] as int,
      arrivalAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['arrivalAt'],
      ),
      weatherCode: jsonSerialization['weatherCode'] as int?,
      weatherGroup: jsonSerialization['weatherGroup'] as String?,
      condition: jsonSerialization['condition'] as String?,
      icon: jsonSerialization['icon'] as String?,
      tempC: (jsonSerialization['tempC'] as num?)?.toDouble(),
      precipitationMm: (jsonSerialization['precipitationMm'] as num?)
          ?.toDouble(),
      precipitationProbability:
          jsonSerialization['precipitationProbability'] as int?,
      windSpeedKmh: (jsonSerialization['windSpeedKmh'] as num?)?.toDouble(),
      severity: jsonSerialization['severity'] as String,
      reasons: _is9lv3rz.Protocol().deserialize<List<String>>(
        jsonSerialization['reasons'],
      ),
      status: jsonSerialization['status'] as String,
    );
  }

  int seq;

  /// Stop name, or "Km 185" for a point between two stops.
  String label;

  /// origin | waypoint | destination | sample
  String kind;

  double lat;

  double lon;

  int distanceFromStartMeters;

  DateTime arrivalAt;

  int? weatherCode;

  /// `weathers.code` group of [weatherCode]; lets the app pick its own icon
  /// without repeating the WMO table on the client.
  String? weatherGroup;

  String? condition;

  String? icon;

  double? tempC;

  double? precipitationMm;

  int? precipitationProbability;

  double? windSpeedKmh;

  /// info | caution | warning
  String severity;

  /// Human readable reasons; empty when nothing stands out.
  List<String> reasons;

  /// forecast | stale | unavailable
  String status;

  /// Returns a shallow copy of this [RouteWeatherSample]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RouteWeatherSample copyWith({
    int? seq,
    String? label,
    String? kind,
    double? lat,
    double? lon,
    int? distanceFromStartMeters,
    DateTime? arrivalAt,
    int? weatherCode,
    String? weatherGroup,
    String? condition,
    String? icon,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    List<String>? reasons,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteWeatherSample',
      'seq': seq,
      'label': label,
      'kind': kind,
      'lat': lat,
      'lon': lon,
      'distanceFromStartMeters': distanceFromStartMeters,
      'arrivalAt': arrivalAt.toJson(),
      if (weatherCode != null) 'weatherCode': weatherCode,
      if (weatherGroup != null) 'weatherGroup': weatherGroup,
      if (condition != null) 'condition': condition,
      if (icon != null) 'icon': icon,
      if (tempC != null) 'tempC': tempC,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      if (precipitationProbability != null)
        'precipitationProbability': precipitationProbability,
      if (windSpeedKmh != null) 'windSpeedKmh': windSpeedKmh,
      'severity': severity,
      'reasons': reasons.toJson(),
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteWeatherSample',
      'seq': seq,
      'label': label,
      'kind': kind,
      'lat': lat,
      'lon': lon,
      'distanceFromStartMeters': distanceFromStartMeters,
      'arrivalAt': arrivalAt.toJson(),
      if (weatherCode != null) 'weatherCode': weatherCode,
      if (weatherGroup != null) 'weatherGroup': weatherGroup,
      if (condition != null) 'condition': condition,
      if (icon != null) 'icon': icon,
      if (tempC != null) 'tempC': tempC,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      if (precipitationProbability != null)
        'precipitationProbability': precipitationProbability,
      if (windSpeedKmh != null) 'windSpeedKmh': windSpeedKmh,
      'severity': severity,
      'reasons': reasons.toJson(),
      'status': status,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RouteWeatherSampleImpl extends RouteWeatherSample {
  _RouteWeatherSampleImpl({
    required int seq,
    required String label,
    required String kind,
    required double lat,
    required double lon,
    required int distanceFromStartMeters,
    required DateTime arrivalAt,
    int? weatherCode,
    String? weatherGroup,
    String? condition,
    String? icon,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    required String severity,
    required List<String> reasons,
    required String status,
  }) : super._(
         seq: seq,
         label: label,
         kind: kind,
         lat: lat,
         lon: lon,
         distanceFromStartMeters: distanceFromStartMeters,
         arrivalAt: arrivalAt,
         weatherCode: weatherCode,
         weatherGroup: weatherGroup,
         condition: condition,
         icon: icon,
         tempC: tempC,
         precipitationMm: precipitationMm,
         precipitationProbability: precipitationProbability,
         windSpeedKmh: windSpeedKmh,
         severity: severity,
         reasons: reasons,
         status: status,
       );

  /// Returns a shallow copy of this [RouteWeatherSample]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RouteWeatherSample copyWith({
    int? seq,
    String? label,
    String? kind,
    double? lat,
    double? lon,
    int? distanceFromStartMeters,
    DateTime? arrivalAt,
    Object? weatherCode = _Undefined,
    Object? weatherGroup = _Undefined,
    Object? condition = _Undefined,
    Object? icon = _Undefined,
    Object? tempC = _Undefined,
    Object? precipitationMm = _Undefined,
    Object? precipitationProbability = _Undefined,
    Object? windSpeedKmh = _Undefined,
    String? severity,
    List<String>? reasons,
    String? status,
  }) {
    return RouteWeatherSample(
      seq: seq ?? this.seq,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      distanceFromStartMeters:
          distanceFromStartMeters ?? this.distanceFromStartMeters,
      arrivalAt: arrivalAt ?? this.arrivalAt,
      weatherCode: weatherCode is int? ? weatherCode : this.weatherCode,
      weatherGroup: weatherGroup is String? ? weatherGroup : this.weatherGroup,
      condition: condition is String? ? condition : this.condition,
      icon: icon is String? ? icon : this.icon,
      tempC: tempC is double? ? tempC : this.tempC,
      precipitationMm: precipitationMm is double?
          ? precipitationMm
          : this.precipitationMm,
      precipitationProbability: precipitationProbability is int?
          ? precipitationProbability
          : this.precipitationProbability,
      windSpeedKmh: windSpeedKmh is double? ? windSpeedKmh : this.windSpeedKmh,
      severity: severity ?? this.severity,
      reasons: reasons ?? this.reasons.map((e0) => e0).toList(),
      status: status ?? this.status,
    );
  }
}
