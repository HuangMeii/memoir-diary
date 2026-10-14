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

/// One stop of a planned route: the origin, a waypoint, or the destination.
abstract class RouteStop
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RouteStop._({
    required this.name,
    required this.lat,
    required this.lon,
    int? dwellMinutes,
    required this.kind,
  }) : dwellMinutes = dwellMinutes ?? 0;

  factory RouteStop({
    required String name,
    required double lat,
    required double lon,
    int? dwellMinutes,
    required String kind,
  }) = _RouteStopImpl;

  factory RouteStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteStop(
      name: jsonSerialization['name'] as String,
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
      dwellMinutes: jsonSerialization['dwellMinutes'] as int?,
      kind: jsonSerialization['kind'] as String,
    );
  }

  /// Display name, e.g. "Đà Lạt".
  String name;

  double lat;

  double lon;

  /// Minutes spent here. Only waypoints and the destination use it.
  int dwellMinutes;

  /// origin | waypoint | destination
  String kind;

  /// Returns a shallow copy of this [RouteStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RouteStop copyWith({
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    String? kind,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteStop',
      'name': name,
      'lat': lat,
      'lon': lon,
      'dwellMinutes': dwellMinutes,
      'kind': kind,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteStop',
      'name': name,
      'lat': lat,
      'lon': lon,
      'dwellMinutes': dwellMinutes,
      'kind': kind,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RouteStopImpl extends RouteStop {
  _RouteStopImpl({
    required String name,
    required double lat,
    required double lon,
    int? dwellMinutes,
    required String kind,
  }) : super._(
         name: name,
         lat: lat,
         lon: lon,
         dwellMinutes: dwellMinutes,
         kind: kind,
       );

  /// Returns a shallow copy of this [RouteStop]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RouteStop copyWith({
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    String? kind,
  }) {
    return RouteStop(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      dwellMinutes: dwellMinutes ?? this.dwellMinutes,
      kind: kind ?? this.kind,
    );
  }
}
