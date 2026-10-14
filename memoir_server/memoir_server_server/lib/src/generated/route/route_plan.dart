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
import '../route/route_alternative.dart' as _izb6xopr;
import '../route/route_leg.dart' as _idzu3rnf;
import '../route/route_stop.dart' as _ih4mamog;

/// A route computed by the routing engine, plus the stops it connects.
abstract class RoutePlan
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RoutePlan._({
    required this.stops,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    required this.legs,
    required this.alternatives,
    required this.source,
    required this.vehicle,
  });

  factory RoutePlan({
    required List<_ih4mamog.RouteStop> stops,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    required List<_idzu3rnf.RouteLeg> legs,
    required List<_izb6xopr.RouteAlternative> alternatives,
    required String source,
    required String vehicle,
  }) = _RoutePlanImpl;

  factory RoutePlan.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoutePlan(
      stops: _is9lv3rz.Protocol().deserialize<List<_ih4mamog.RouteStop>>(
        jsonSerialization['stops'],
      ),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      geometry: jsonSerialization['geometry'] as String,
      legs: _is9lv3rz.Protocol().deserialize<List<_idzu3rnf.RouteLeg>>(
        jsonSerialization['legs'],
      ),
      alternatives: _is9lv3rz.Protocol()
          .deserialize<List<_izb6xopr.RouteAlternative>>(
            jsonSerialization['alternatives'],
          ),
      source: jsonSerialization['source'] as String,
      vehicle: jsonSerialization['vehicle'] as String,
    );
  }

  /// Stops in travel order: origin, waypoints..., destination.
  List<_ih4mamog.RouteStop> stops;

  int distanceMeters;

  int durationSeconds;

  /// GeoJSON LineString of the chosen route.
  String geometry;

  /// One entry per stop pair; leg i arrives at stop i + 1.
  List<_idzu3rnf.RouteLeg> legs;

  /// Empty when the engine offers no alternative.
  List<_izb6xopr.RouteAlternative> alternatives;

  /// Name of the routing backend, e.g. "osrm".
  String source;

  /// car | bike | foot
  String vehicle;

  /// Returns a shallow copy of this [RoutePlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RoutePlan copyWith({
    List<_ih4mamog.RouteStop>? stops,
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
    List<_idzu3rnf.RouteLeg>? legs,
    List<_izb6xopr.RouteAlternative>? alternatives,
    String? source,
    String? vehicle,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoutePlan',
      'stops': stops.toJson(valueToJson: (v) => v.toJson()),
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      'legs': legs.toJson(valueToJson: (v) => v.toJson()),
      'alternatives': alternatives.toJson(valueToJson: (v) => v.toJson()),
      'source': source,
      'vehicle': vehicle,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoutePlan',
      'stops': stops.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      'legs': legs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'alternatives': alternatives.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'source': source,
      'vehicle': vehicle,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RoutePlanImpl extends RoutePlan {
  _RoutePlanImpl({
    required List<_ih4mamog.RouteStop> stops,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    required List<_idzu3rnf.RouteLeg> legs,
    required List<_izb6xopr.RouteAlternative> alternatives,
    required String source,
    required String vehicle,
  }) : super._(
         stops: stops,
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         geometry: geometry,
         legs: legs,
         alternatives: alternatives,
         source: source,
         vehicle: vehicle,
       );

  /// Returns a shallow copy of this [RoutePlan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RoutePlan copyWith({
    List<_ih4mamog.RouteStop>? stops,
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
    List<_idzu3rnf.RouteLeg>? legs,
    List<_izb6xopr.RouteAlternative>? alternatives,
    String? source,
    String? vehicle,
  }) {
    return RoutePlan(
      stops: stops ?? this.stops.map((e0) => e0.copyWith()).toList(),
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      geometry: geometry ?? this.geometry,
      legs: legs ?? this.legs.map((e0) => e0.copyWith()).toList(),
      alternatives:
          alternatives ?? this.alternatives.map((e0) => e0.copyWith()).toList(),
      source: source ?? this.source,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
