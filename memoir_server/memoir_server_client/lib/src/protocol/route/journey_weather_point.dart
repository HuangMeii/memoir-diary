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

/// The forecast snapshot saved with a journey, so a past trip keeps the summary
/// it was planned with even after the provider's data moved on.
abstract class JourneyWeatherPoint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyWeatherPoint._({
    this.id,
    required this.journeyId,
    required this.seq,
    required this.sampleAt,
    required this.lat,
    required this.lon,
    this.label,
    this.weatherCode,
    this.weatherGroup,
    this.weatherId,
    this.tempC,
    this.precipitationMm,
    this.precipitationProbability,
    this.windSpeedKmh,
    this.severity,
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  factory JourneyWeatherPoint({
    _isc.UuidValue? id,
    required _isc.UuidValue journeyId,
    required int seq,
    required DateTime sampleAt,
    required double lat,
    required double lon,
    String? label,
    int? weatherCode,
    String? weatherGroup,
    int? weatherId,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    DateTime? fetchedAt,
  }) = _JourneyWeatherPointImpl;

  factory JourneyWeatherPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyWeatherPoint(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      journeyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['journeyId'],
      ),
      seq: jsonSerialization['seq'] as int,
      sampleAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['sampleAt'],
      ),
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
      label: jsonSerialization['label'] as String?,
      weatherCode: jsonSerialization['weatherCode'] as int?,
      weatherGroup: jsonSerialization['weatherGroup'] as String?,
      weatherId: jsonSerialization['weatherId'] as int?,
      tempC: (jsonSerialization['tempC'] as num?)?.toDouble(),
      precipitationMm: (jsonSerialization['precipitationMm'] as num?)
          ?.toDouble(),
      precipitationProbability:
          jsonSerialization['precipitationProbability'] as int?,
      windSpeedKmh: (jsonSerialization['windSpeedKmh'] as num?)?.toDouble(),
      severity: jsonSerialization['severity'] as String?,
      fetchedAt: jsonSerialization['fetchedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['fetchedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue journeyId;

  int seq;

  DateTime sampleAt;

  double lat;

  double lon;

  String? label;

  int? weatherCode;

  /// `weathers.code` group of [weatherCode].
  String? weatherGroup;

  int? weatherId;

  double? tempC;

  double? precipitationMm;

  int? precipitationProbability;

  double? windSpeedKmh;

  /// info | caution | warning
  String? severity;

  DateTime fetchedAt;

  /// Returns a shallow copy of this [JourneyWeatherPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyWeatherPoint copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? journeyId,
    int? seq,
    DateTime? sampleAt,
    double? lat,
    double? lon,
    String? label,
    int? weatherCode,
    String? weatherGroup,
    int? weatherId,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    DateTime? fetchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyWeatherPoint',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'sampleAt': sampleAt.toJson(),
      'lat': lat,
      'lon': lon,
      if (label != null) 'label': label,
      if (weatherCode != null) 'weatherCode': weatherCode,
      if (weatherGroup != null) 'weatherGroup': weatherGroup,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempC != null) 'tempC': tempC,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      if (precipitationProbability != null)
        'precipitationProbability': precipitationProbability,
      if (windSpeedKmh != null) 'windSpeedKmh': windSpeedKmh,
      if (severity != null) 'severity': severity,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyWeatherPoint',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'sampleAt': sampleAt.toJson(),
      'lat': lat,
      'lon': lon,
      if (label != null) 'label': label,
      if (weatherCode != null) 'weatherCode': weatherCode,
      if (weatherGroup != null) 'weatherGroup': weatherGroup,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempC != null) 'tempC': tempC,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      if (precipitationProbability != null)
        'precipitationProbability': precipitationProbability,
      if (windSpeedKmh != null) 'windSpeedKmh': windSpeedKmh,
      if (severity != null) 'severity': severity,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyWeatherPointImpl extends JourneyWeatherPoint {
  _JourneyWeatherPointImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue journeyId,
    required int seq,
    required DateTime sampleAt,
    required double lat,
    required double lon,
    String? label,
    int? weatherCode,
    String? weatherGroup,
    int? weatherId,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    DateTime? fetchedAt,
  }) : super._(
         id: id,
         journeyId: journeyId,
         seq: seq,
         sampleAt: sampleAt,
         lat: lat,
         lon: lon,
         label: label,
         weatherCode: weatherCode,
         weatherGroup: weatherGroup,
         weatherId: weatherId,
         tempC: tempC,
         precipitationMm: precipitationMm,
         precipitationProbability: precipitationProbability,
         windSpeedKmh: windSpeedKmh,
         severity: severity,
         fetchedAt: fetchedAt,
       );

  /// Returns a shallow copy of this [JourneyWeatherPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyWeatherPoint copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? journeyId,
    int? seq,
    DateTime? sampleAt,
    double? lat,
    double? lon,
    Object? label = _Undefined,
    Object? weatherCode = _Undefined,
    Object? weatherGroup = _Undefined,
    Object? weatherId = _Undefined,
    Object? tempC = _Undefined,
    Object? precipitationMm = _Undefined,
    Object? precipitationProbability = _Undefined,
    Object? windSpeedKmh = _Undefined,
    Object? severity = _Undefined,
    DateTime? fetchedAt,
  }) {
    return JourneyWeatherPoint(
      id: id is _isc.UuidValue? ? id : this.id,
      journeyId: journeyId ?? this.journeyId,
      seq: seq ?? this.seq,
      sampleAt: sampleAt ?? this.sampleAt,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      label: label is String? ? label : this.label,
      weatherCode: weatherCode is int? ? weatherCode : this.weatherCode,
      weatherGroup: weatherGroup is String? ? weatherGroup : this.weatherGroup,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      tempC: tempC is double? ? tempC : this.tempC,
      precipitationMm: precipitationMm is double?
          ? precipitationMm
          : this.precipitationMm,
      precipitationProbability: precipitationProbability is int?
          ? precipitationProbability
          : this.precipitationProbability,
      windSpeedKmh: windSpeedKmh is double? ? windSpeedKmh : this.windSpeedKmh,
      severity: severity is String? ? severity : this.severity,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }
}
