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

/// One stop of a saved journey, in travel order.
abstract class JourneyStop
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyStop._({
    this.id,
    required this.journeyId,
    required this.seq,
    required this.kind,
    required this.name,
    required this.lat,
    required this.lon,
    int? dwellMinutes,
    this.arrivalAt,
    this.distanceFromStartMeters,
  }) : dwellMinutes = dwellMinutes ?? 0;

  factory JourneyStop({
    _isc.UuidValue? id,
    required _isc.UuidValue journeyId,
    required int seq,
    required String kind,
    required String name,
    required double lat,
    required double lon,
    int? dwellMinutes,
    DateTime? arrivalAt,
    int? distanceFromStartMeters,
  }) = _JourneyStopImpl;

  factory JourneyStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyStop(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      journeyId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['journeyId'],
      ),
      seq: jsonSerialization['seq'] as int,
      kind: jsonSerialization['kind'] as String,
      name: jsonSerialization['name'] as String,
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
      dwellMinutes: jsonSerialization['dwellMinutes'] as int?,
      arrivalAt: jsonSerialization['arrivalAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['arrivalAt']),
      distanceFromStartMeters:
          jsonSerialization['distanceFromStartMeters'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue journeyId;

  int seq;

  /// origin | waypoint | destination
  String kind;

  String name;

  double lat;

  double lon;

  int dwellMinutes;

  DateTime? arrivalAt;

  int? distanceFromStartMeters;

  /// Returns a shallow copy of this [JourneyStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyStop copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? journeyId,
    int? seq,
    String? kind,
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    DateTime? arrivalAt,
    int? distanceFromStartMeters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyStop',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'kind': kind,
      'name': name,
      'lat': lat,
      'lon': lon,
      'dwellMinutes': dwellMinutes,
      if (arrivalAt != null) 'arrivalAt': arrivalAt?.toJson(),
      if (distanceFromStartMeters != null)
        'distanceFromStartMeters': distanceFromStartMeters,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyStop',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'kind': kind,
      'name': name,
      'lat': lat,
      'lon': lon,
      'dwellMinutes': dwellMinutes,
      if (arrivalAt != null) 'arrivalAt': arrivalAt?.toJson(),
      if (distanceFromStartMeters != null)
        'distanceFromStartMeters': distanceFromStartMeters,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyStopImpl extends JourneyStop {
  _JourneyStopImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue journeyId,
    required int seq,
    required String kind,
    required String name,
    required double lat,
    required double lon,
    int? dwellMinutes,
    DateTime? arrivalAt,
    int? distanceFromStartMeters,
  }) : super._(
         id: id,
         journeyId: journeyId,
         seq: seq,
         kind: kind,
         name: name,
         lat: lat,
         lon: lon,
         dwellMinutes: dwellMinutes,
         arrivalAt: arrivalAt,
         distanceFromStartMeters: distanceFromStartMeters,
       );

  /// Returns a shallow copy of this [JourneyStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyStop copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? journeyId,
    int? seq,
    String? kind,
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    Object? arrivalAt = _Undefined,
    Object? distanceFromStartMeters = _Undefined,
  }) {
    return JourneyStop(
      id: id is _isc.UuidValue? ? id : this.id,
      journeyId: journeyId ?? this.journeyId,
      seq: seq ?? this.seq,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      dwellMinutes: dwellMinutes ?? this.dwellMinutes,
      arrivalAt: arrivalAt is DateTime? ? arrivalAt : this.arrivalAt,
      distanceFromStartMeters: distanceFromStartMeters is int?
          ? distanceFromStartMeters
          : this.distanceFromStartMeters,
    );
  }
}
