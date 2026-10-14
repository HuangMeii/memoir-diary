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

/// A place found by the geocoding API.
abstract class PlaceCandidate
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PlaceCandidate._({
    required this.name,
    this.admin,
    this.country,
    required this.lat,
    required this.lon,
  });

  factory PlaceCandidate({
    required String name,
    String? admin,
    String? country,
    required double lat,
    required double lon,
  }) = _PlaceCandidateImpl;

  factory PlaceCandidate.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaceCandidate(
      name: jsonSerialization['name'] as String,
      admin: jsonSerialization['admin'] as String?,
      country: jsonSerialization['country'] as String?,
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
    );
  }

  String name;

  /// Province / state, when the provider knows it.
  String? admin;

  String? country;

  double lat;

  double lon;

  /// Returns a shallow copy of this [PlaceCandidate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlaceCandidate copyWith({
    String? name,
    String? admin,
    String? country,
    double? lat,
    double? lon,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlaceCandidate',
      'name': name,
      if (admin != null) 'admin': admin,
      if (country != null) 'country': country,
      'lat': lat,
      'lon': lon,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlaceCandidate',
      'name': name,
      if (admin != null) 'admin': admin,
      if (country != null) 'country': country,
      'lat': lat,
      'lon': lon,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlaceCandidateImpl extends PlaceCandidate {
  _PlaceCandidateImpl({
    required String name,
    String? admin,
    String? country,
    required double lat,
    required double lon,
  }) : super._(
         name: name,
         admin: admin,
         country: country,
         lat: lat,
         lon: lon,
       );

  /// Returns a shallow copy of this [PlaceCandidate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlaceCandidate copyWith({
    String? name,
    Object? admin = _Undefined,
    Object? country = _Undefined,
    double? lat,
    double? lon,
  }) {
    return PlaceCandidate(
      name: name ?? this.name,
      admin: admin is String? ? admin : this.admin,
      country: country is String? ? country : this.country,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }
}
