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
import 'package:memoir_server_client/src/protocol/protocol.dart' as _itoi32v3;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../route/route_weather_report.dart' as _ij2lc9bc;

/// One departure time offered by the "compare departure times" panel.
abstract class RouteDepartureOption
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RouteDepartureOption._({
    required this.offsetHours,
    required this.departureAt,
    required this.arrivalAt,
    required this.severity,
    required this.headline,
    required this.weather,
  });

  factory RouteDepartureOption({
    required int offsetHours,
    required DateTime departureAt,
    required DateTime arrivalAt,
    required String severity,
    required String headline,
    required _ij2lc9bc.RouteWeatherReport weather,
  }) = _RouteDepartureOptionImpl;

  factory RouteDepartureOption.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RouteDepartureOption(
      offsetHours: jsonSerialization['offsetHours'] as int,
      departureAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['departureAt'],
      ),
      arrivalAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['arrivalAt'],
      ),
      severity: jsonSerialization['severity'] as String,
      headline: jsonSerialization['headline'] as String,
      weather: _itoi32v3.Protocol().deserialize<_ij2lc9bc.RouteWeatherReport>(
        jsonSerialization['weather'],
      ),
    );
  }

  /// Hours from the departure time the user picked (negative = earlier).
  int offsetHours;

  DateTime departureAt;

  DateTime arrivalAt;

  /// Worst severity along the route: info | caution | warning
  String severity;

  /// Short Vietnamese verdict, e.g. "Ít mưa nhất".
  String headline;

  _ij2lc9bc.RouteWeatherReport weather;

  /// Returns a shallow copy of this [RouteDepartureOption]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RouteDepartureOption copyWith({
    int? offsetHours,
    DateTime? departureAt,
    DateTime? arrivalAt,
    String? severity,
    String? headline,
    _ij2lc9bc.RouteWeatherReport? weather,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteDepartureOption',
      'offsetHours': offsetHours,
      'departureAt': departureAt.toJson(),
      'arrivalAt': arrivalAt.toJson(),
      'severity': severity,
      'headline': headline,
      'weather': weather.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteDepartureOption',
      'offsetHours': offsetHours,
      'departureAt': departureAt.toJson(),
      'arrivalAt': arrivalAt.toJson(),
      'severity': severity,
      'headline': headline,
      'weather': weather.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RouteDepartureOptionImpl extends RouteDepartureOption {
  _RouteDepartureOptionImpl({
    required int offsetHours,
    required DateTime departureAt,
    required DateTime arrivalAt,
    required String severity,
    required String headline,
    required _ij2lc9bc.RouteWeatherReport weather,
  }) : super._(
         offsetHours: offsetHours,
         departureAt: departureAt,
         arrivalAt: arrivalAt,
         severity: severity,
         headline: headline,
         weather: weather,
       );

  /// Returns a shallow copy of this [RouteDepartureOption]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RouteDepartureOption copyWith({
    int? offsetHours,
    DateTime? departureAt,
    DateTime? arrivalAt,
    String? severity,
    String? headline,
    _ij2lc9bc.RouteWeatherReport? weather,
  }) {
    return RouteDepartureOption(
      offsetHours: offsetHours ?? this.offsetHours,
      departureAt: departureAt ?? this.departureAt,
      arrivalAt: arrivalAt ?? this.arrivalAt,
      severity: severity ?? this.severity,
      headline: headline ?? this.headline,
      weather: weather ?? this.weather.copyWith(),
    );
  }
}
