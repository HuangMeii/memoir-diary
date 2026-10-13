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

/// An alternative route the engine offered. Kept flat on purpose: only the
/// primary route carries the per-leg breakdown the ETA calculation needs.
abstract class RouteAlternative
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RouteAlternative._({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
  });

  factory RouteAlternative({
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
  }) = _RouteAlternativeImpl;

  factory RouteAlternative.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteAlternative(
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      geometry: jsonSerialization['geometry'] as String,
    );
  }

  int distanceMeters;

  int durationSeconds;

  /// GeoJSON LineString.
  String geometry;

  /// Returns a shallow copy of this [RouteAlternative]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RouteAlternative copyWith({
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteAlternative',
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteAlternative',
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RouteAlternativeImpl extends RouteAlternative {
  _RouteAlternativeImpl({
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
  }) : super._(
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         geometry: geometry,
       );

  /// Returns a shallow copy of this [RouteAlternative]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RouteAlternative copyWith({
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
  }) {
    return RouteAlternative(
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      geometry: geometry ?? this.geometry,
    );
  }
}
