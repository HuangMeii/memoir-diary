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

/// Per-day weather snapshot so a past day's weather survives API outages.
abstract class WeatherSnapshot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WeatherSnapshot._({
    this.id,
    required this.userId,
    required this.forecastDate,
    required this.weatherCode,
    this.weatherId,
    this.tempMin,
    this.tempMax,
    this.tempAvg,
    this.precipitationMm,
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  factory WeatherSnapshot({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime forecastDate,
    required int weatherCode,
    int? weatherId,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
    DateTime? fetchedAt,
  }) = _WeatherSnapshotImpl;

  factory WeatherSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeatherSnapshot(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      forecastDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['forecastDate'],
      ),
      weatherCode: jsonSerialization['weatherCode'] as int,
      weatherId: jsonSerialization['weatherId'] as int?,
      tempMin: (jsonSerialization['tempMin'] as num?)?.toDouble(),
      tempMax: (jsonSerialization['tempMax'] as num?)?.toDouble(),
      tempAvg: (jsonSerialization['tempAvg'] as num?)?.toDouble(),
      precipitationMm: (jsonSerialization['precipitationMm'] as num?)
          ?.toDouble(),
      fetchedAt: jsonSerialization['fetchedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['fetchedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue userId;

  DateTime forecastDate;

  /// Raw WMO code from the API.
  int weatherCode;

  /// Matching row in the weathers lookup.
  int? weatherId;

  double? tempMin;

  double? tempMax;

  double? tempAvg;

  double? precipitationMm;

  DateTime fetchedAt;

  /// Returns a shallow copy of this [WeatherSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WeatherSnapshot copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    DateTime? forecastDate,
    int? weatherCode,
    int? weatherId,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
    DateTime? fetchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeatherSnapshot',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'forecastDate': forecastDate.toJson(),
      'weatherCode': weatherCode,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempMin != null) 'tempMin': tempMin,
      if (tempMax != null) 'tempMax': tempMax,
      if (tempAvg != null) 'tempAvg': tempAvg,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeatherSnapshot',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'forecastDate': forecastDate.toJson(),
      'weatherCode': weatherCode,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempMin != null) 'tempMin': tempMin,
      if (tempMax != null) 'tempMax': tempMax,
      if (tempAvg != null) 'tempAvg': tempAvg,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WeatherSnapshotImpl extends WeatherSnapshot {
  _WeatherSnapshotImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime forecastDate,
    required int weatherCode,
    int? weatherId,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
    DateTime? fetchedAt,
  }) : super._(
         id: id,
         userId: userId,
         forecastDate: forecastDate,
         weatherCode: weatherCode,
         weatherId: weatherId,
         tempMin: tempMin,
         tempMax: tempMax,
         tempAvg: tempAvg,
         precipitationMm: precipitationMm,
         fetchedAt: fetchedAt,
       );

  /// Returns a shallow copy of this [WeatherSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WeatherSnapshot copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? forecastDate,
    int? weatherCode,
    Object? weatherId = _Undefined,
    Object? tempMin = _Undefined,
    Object? tempMax = _Undefined,
    Object? tempAvg = _Undefined,
    Object? precipitationMm = _Undefined,
    DateTime? fetchedAt,
  }) {
    return WeatherSnapshot(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      forecastDate: forecastDate ?? this.forecastDate,
      weatherCode: weatherCode ?? this.weatherCode,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      tempMin: tempMin is double? ? tempMin : this.tempMin,
      tempMax: tempMax is double? ? tempMax : this.tempMax,
      tempAvg: tempAvg is double? ? tempAvg : this.tempAvg,
      precipitationMm: precipitationMm is double?
          ? precipitationMm
          : this.precipitationMm,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }
}
