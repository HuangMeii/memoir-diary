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
import '../route/journey.dart' as _iz694qst;
import '../route/journey_stop.dart' as _ih8qr0z4;
import '../route/journey_weather_point.dart' as _ib7ldgs9;

/// A saved journey with its stops and its weather snapshot. The snapshot is what
/// the trip was planned with; the screen can still ask for a fresh forecast and
/// show the two side by side.
abstract class JourneyDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JourneyDetail._({
    required this.journey,
    required this.stops,
    required this.weatherPoints,
  });

  factory JourneyDetail({
    required _iz694qst.Journey journey,
    required List<_ih8qr0z4.JourneyStop> stops,
    required List<_ib7ldgs9.JourneyWeatherPoint> weatherPoints,
  }) = _JourneyDetailImpl;

  factory JourneyDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyDetail(
      journey: _is9lv3rz.Protocol().deserialize<_iz694qst.Journey>(
        jsonSerialization['journey'],
      ),
      stops: _is9lv3rz.Protocol().deserialize<List<_ih8qr0z4.JourneyStop>>(
        jsonSerialization['stops'],
      ),
      weatherPoints: _is9lv3rz.Protocol()
          .deserialize<List<_ib7ldgs9.JourneyWeatherPoint>>(
            jsonSerialization['weatherPoints'],
          ),
    );
  }

  _iz694qst.Journey journey;

  /// Stops in travel order.
  List<_ih8qr0z4.JourneyStop> stops;

  /// Weather snapshot taken when the journey was saved.
  List<_ib7ldgs9.JourneyWeatherPoint> weatherPoints;

  /// Returns a shallow copy of this [JourneyDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JourneyDetail copyWith({
    _iz694qst.Journey? journey,
    List<_ih8qr0z4.JourneyStop>? stops,
    List<_ib7ldgs9.JourneyWeatherPoint>? weatherPoints,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyDetail',
      'journey': journey.toJson(),
      'stops': stops.toJson(valueToJson: (v) => v.toJson()),
      'weatherPoints': weatherPoints.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyDetail',
      'journey': journey.toJsonForProtocol(),
      'stops': stops.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'weatherPoints': weatherPoints.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _JourneyDetailImpl extends JourneyDetail {
  _JourneyDetailImpl({
    required _iz694qst.Journey journey,
    required List<_ih8qr0z4.JourneyStop> stops,
    required List<_ib7ldgs9.JourneyWeatherPoint> weatherPoints,
  }) : super._(
         journey: journey,
         stops: stops,
         weatherPoints: weatherPoints,
       );

  /// Returns a shallow copy of this [JourneyDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JourneyDetail copyWith({
    _iz694qst.Journey? journey,
    List<_ih8qr0z4.JourneyStop>? stops,
    List<_ib7ldgs9.JourneyWeatherPoint>? weatherPoints,
  }) {
    return JourneyDetail(
      journey: journey ?? this.journey.copyWith(),
      stops: stops ?? this.stops.map((e0) => e0.copyWith()).toList(),
      weatherPoints:
          weatherPoints ??
          this.weatherPoints.map((e0) => e0.copyWith()).toList(),
    );
  }
}
