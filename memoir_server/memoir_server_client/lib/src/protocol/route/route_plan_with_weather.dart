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
import '../route/route_plan.dart' as _i6kbawag;
import '../route/route_weather_report.dart' as _ij2lc9bc;

/// A plan together with the weather along it, so the screen needs one call
/// instead of two.
abstract class RoutePlanWithWeather
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RoutePlanWithWeather._({
    required this.plan,
    required this.weather,
  });

  factory RoutePlanWithWeather({
    required _i6kbawag.RoutePlan plan,
    required _ij2lc9bc.RouteWeatherReport weather,
  }) = _RoutePlanWithWeatherImpl;

  factory RoutePlanWithWeather.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RoutePlanWithWeather(
      plan: _itoi32v3.Protocol().deserialize<_i6kbawag.RoutePlan>(
        jsonSerialization['plan'],
      ),
      weather: _itoi32v3.Protocol().deserialize<_ij2lc9bc.RouteWeatherReport>(
        jsonSerialization['weather'],
      ),
    );
  }

  _i6kbawag.RoutePlan plan;

  _ij2lc9bc.RouteWeatherReport weather;

  /// Returns a shallow copy of this [RoutePlanWithWeather]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RoutePlanWithWeather copyWith({
    _i6kbawag.RoutePlan? plan,
    _ij2lc9bc.RouteWeatherReport? weather,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoutePlanWithWeather',
      'plan': plan.toJson(),
      'weather': weather.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoutePlanWithWeather',
      'plan': plan.toJsonForProtocol(),
      'weather': weather.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RoutePlanWithWeatherImpl extends RoutePlanWithWeather {
  _RoutePlanWithWeatherImpl({
    required _i6kbawag.RoutePlan plan,
    required _ij2lc9bc.RouteWeatherReport weather,
  }) : super._(
         plan: plan,
         weather: weather,
       );

  /// Returns a shallow copy of this [RoutePlanWithWeather]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RoutePlanWithWeather copyWith({
    _i6kbawag.RoutePlan? plan,
    _ij2lc9bc.RouteWeatherReport? weather,
  }) {
    return RoutePlanWithWeather(
      plan: plan ?? this.plan.copyWith(),
      weather: weather ?? this.weather.copyWith(),
    );
  }
}
