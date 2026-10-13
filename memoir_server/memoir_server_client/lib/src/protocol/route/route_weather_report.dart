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
import '../route/route_alert.dart' as _icv6fd3j;
import '../route/route_weather_sample.dart' as _i90uhssz;

/// Weather along a route: one sample per stop and per point between stops,
/// plus the merged unfavourable stretches.
abstract class RouteWeatherReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RouteWeatherReport._({
    required this.generatedAt,
    required this.coverage,
    required this.source,
    required this.beyondRange,
    required this.samples,
    required this.alerts,
    required this.notes,
  });

  factory RouteWeatherReport({
    required DateTime generatedAt,
    required String coverage,
    required String source,
    required bool beyondRange,
    required List<_i90uhssz.RouteWeatherSample> samples,
    required List<_icv6fd3j.RouteAlert> alerts,
    required List<String> notes,
  }) = _RouteWeatherReportImpl;

  factory RouteWeatherReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteWeatherReport(
      generatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      coverage: jsonSerialization['coverage'] as String,
      source: jsonSerialization['source'] as String,
      beyondRange: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['beyondRange'],
      ),
      samples: _itoi32v3.Protocol()
          .deserialize<List<_i90uhssz.RouteWeatherSample>>(
            jsonSerialization['samples'],
          ),
      alerts: _itoi32v3.Protocol().deserialize<List<_icv6fd3j.RouteAlert>>(
        jsonSerialization['alerts'],
      ),
      notes: _itoi32v3.Protocol().deserialize<List<String>>(
        jsonSerialization['notes'],
      ),
    );
  }

  DateTime generatedAt;

  /// full | partial | none
  String coverage;

  /// api | cache | unavailable
  String source;

  /// True when the trip reaches past the provider's forecast horizon.
  bool beyondRange;

  List<_i90uhssz.RouteWeatherSample> samples;

  List<_icv6fd3j.RouteAlert> alerts;

  /// Vietnamese notes explaining the coverage, shown verbatim in the UI.
  List<String> notes;

  /// Returns a shallow copy of this [RouteWeatherReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RouteWeatherReport copyWith({
    DateTime? generatedAt,
    String? coverage,
    String? source,
    bool? beyondRange,
    List<_i90uhssz.RouteWeatherSample>? samples,
    List<_icv6fd3j.RouteAlert>? alerts,
    List<String>? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteWeatherReport',
      'generatedAt': generatedAt.toJson(),
      'coverage': coverage,
      'source': source,
      'beyondRange': beyondRange,
      'samples': samples.toJson(valueToJson: (v) => v.toJson()),
      'alerts': alerts.toJson(valueToJson: (v) => v.toJson()),
      'notes': notes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteWeatherReport',
      'generatedAt': generatedAt.toJson(),
      'coverage': coverage,
      'source': source,
      'beyondRange': beyondRange,
      'samples': samples.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'alerts': alerts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'notes': notes.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RouteWeatherReportImpl extends RouteWeatherReport {
  _RouteWeatherReportImpl({
    required DateTime generatedAt,
    required String coverage,
    required String source,
    required bool beyondRange,
    required List<_i90uhssz.RouteWeatherSample> samples,
    required List<_icv6fd3j.RouteAlert> alerts,
    required List<String> notes,
  }) : super._(
         generatedAt: generatedAt,
         coverage: coverage,
         source: source,
         beyondRange: beyondRange,
         samples: samples,
         alerts: alerts,
         notes: notes,
       );

  /// Returns a shallow copy of this [RouteWeatherReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RouteWeatherReport copyWith({
    DateTime? generatedAt,
    String? coverage,
    String? source,
    bool? beyondRange,
    List<_i90uhssz.RouteWeatherSample>? samples,
    List<_icv6fd3j.RouteAlert>? alerts,
    List<String>? notes,
  }) {
    return RouteWeatherReport(
      generatedAt: generatedAt ?? this.generatedAt,
      coverage: coverage ?? this.coverage,
      source: source ?? this.source,
      beyondRange: beyondRange ?? this.beyondRange,
      samples: samples ?? this.samples.map((e0) => e0.copyWith()).toList(),
      alerts: alerts ?? this.alerts.map((e0) => e0.copyWith()).toList(),
      notes: notes ?? this.notes.map((e0) => e0).toList(),
    );
  }
}
