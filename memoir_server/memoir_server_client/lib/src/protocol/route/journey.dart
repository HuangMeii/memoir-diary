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

/// A saved trip: the route, its weather snapshot and the diary link. Stops and
/// weather points live in their own tables so a trip can be reopened and shown
/// exactly as it was planned, separately from the latest forecast.
abstract class Journey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Journey._({
    this.id,
    required this.userId,
    required this.title,
    required this.vehicle,
    required this.departureAt,
    required this.originName,
    required this.originLat,
    required this.originLon,
    required this.destinationName,
    required this.destinationLat,
    required this.destinationLon,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    this.notes,
    this.entryId,
    this.weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Journey({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required String originName,
    required double originLat,
    required double originLon,
    required String destinationName,
    required double destinationLat,
    required double destinationLon,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    String? notes,
    _isc.UuidValue? entryId,
    DateTime? weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JourneyImpl;

  factory Journey.fromJson(Map<String, dynamic> jsonSerialization) {
    return Journey(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      vehicle: jsonSerialization['vehicle'] as String,
      departureAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['departureAt'],
      ),
      originName: jsonSerialization['originName'] as String,
      originLat: (jsonSerialization['originLat'] as num).toDouble(),
      originLon: (jsonSerialization['originLon'] as num).toDouble(),
      destinationName: jsonSerialization['destinationName'] as String,
      destinationLat: (jsonSerialization['destinationLat'] as num).toDouble(),
      destinationLon: (jsonSerialization['destinationLon'] as num).toDouble(),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      geometry: jsonSerialization['geometry'] as String,
      notes: jsonSerialization['notes'] as String?,
      entryId: jsonSerialization['entryId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['entryId']),
      weatherSavedAt: jsonSerialization['weatherSavedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['weatherSavedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
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

  String title;

  /// car | motor | bike | foot
  String vehicle;

  DateTime departureAt;

  String originName;

  double originLat;

  double originLon;

  String destinationName;

  double destinationLat;

  double destinationLon;

  int distanceMeters;

  int durationSeconds;

  /// GeoJSON LineString of the chosen route.
  String geometry;

  String? notes;

  /// Soft link to the diary entry, like `reflections.entryId`: deleting the
  /// entry leaves the trip intact.
  _isc.UuidValue? entryId;

  /// When the weather snapshot below was taken.
  DateTime? weatherSavedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Journey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Journey copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? title,
    String? vehicle,
    DateTime? departureAt,
    String? originName,
    double? originLat,
    double? originLon,
    String? destinationName,
    double? destinationLat,
    double? destinationLon,
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
    String? notes,
    _isc.UuidValue? entryId,
    DateTime? weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Journey',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      'vehicle': vehicle,
      'departureAt': departureAt.toJson(),
      'originName': originName,
      'originLat': originLat,
      'originLon': originLon,
      'destinationName': destinationName,
      'destinationLat': destinationLat,
      'destinationLon': destinationLon,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      if (notes != null) 'notes': notes,
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (weatherSavedAt != null) 'weatherSavedAt': weatherSavedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Journey',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      'vehicle': vehicle,
      'departureAt': departureAt.toJson(),
      'originName': originName,
      'originLat': originLat,
      'originLon': originLon,
      'destinationName': destinationName,
      'destinationLat': destinationLat,
      'destinationLon': destinationLon,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      if (notes != null) 'notes': notes,
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (weatherSavedAt != null) 'weatherSavedAt': weatherSavedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyImpl extends Journey {
  _JourneyImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required String originName,
    required double originLat,
    required double originLon,
    required String destinationName,
    required double destinationLat,
    required double destinationLon,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    String? notes,
    _isc.UuidValue? entryId,
    DateTime? weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         vehicle: vehicle,
         departureAt: departureAt,
         originName: originName,
         originLat: originLat,
         originLon: originLon,
         destinationName: destinationName,
         destinationLat: destinationLat,
         destinationLon: destinationLon,
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         geometry: geometry,
         notes: notes,
         entryId: entryId,
         weatherSavedAt: weatherSavedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Journey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Journey copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? title,
    String? vehicle,
    DateTime? departureAt,
    String? originName,
    double? originLat,
    double? originLon,
    String? destinationName,
    double? destinationLat,
    double? destinationLon,
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
    Object? notes = _Undefined,
    Object? entryId = _Undefined,
    Object? weatherSavedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Journey(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      vehicle: vehicle ?? this.vehicle,
      departureAt: departureAt ?? this.departureAt,
      originName: originName ?? this.originName,
      originLat: originLat ?? this.originLat,
      originLon: originLon ?? this.originLon,
      destinationName: destinationName ?? this.destinationName,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLon: destinationLon ?? this.destinationLon,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      geometry: geometry ?? this.geometry,
      notes: notes is String? ? notes : this.notes,
      entryId: entryId is _isc.UuidValue? ? entryId : this.entryId,
      weatherSavedAt: weatherSavedAt is DateTime?
          ? weatherSavedAt
          : this.weatherSavedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
