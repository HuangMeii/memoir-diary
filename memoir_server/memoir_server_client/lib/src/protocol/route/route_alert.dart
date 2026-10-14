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

/// A stretch of the route with unfavourable weather, merged from neighbouring
/// samples so the UI can show one callout instead of many markers.
abstract class RouteAlert
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RouteAlert._({
    required this.severity,
    required this.title,
    required this.summary,
    required this.startAt,
    required this.endAt,
    required this.fromSeq,
    required this.toSeq,
  });

  factory RouteAlert({
    required String severity,
    required String title,
    required String summary,
    required DateTime startAt,
    required DateTime endAt,
    required int fromSeq,
    required int toSeq,
  }) = _RouteAlertImpl;

  factory RouteAlert.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteAlert(
      severity: jsonSerialization['severity'] as String,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      endAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      fromSeq: jsonSerialization['fromSeq'] as int,
      toSeq: jsonSerialization['toSeq'] as int,
    );
  }

  /// info | caution | warning
  String severity;

  String title;

  String summary;

  DateTime startAt;

  DateTime endAt;

  /// Sequence numbers of the first and last sample in the stretch.
  int fromSeq;

  int toSeq;

  /// Returns a shallow copy of this [RouteAlert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RouteAlert copyWith({
    String? severity,
    String? title,
    String? summary,
    DateTime? startAt,
    DateTime? endAt,
    int? fromSeq,
    int? toSeq,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteAlert',
      'severity': severity,
      'title': title,
      'summary': summary,
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'fromSeq': fromSeq,
      'toSeq': toSeq,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteAlert',
      'severity': severity,
      'title': title,
      'summary': summary,
      'startAt': startAt.toJson(),
      'endAt': endAt.toJson(),
      'fromSeq': fromSeq,
      'toSeq': toSeq,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RouteAlertImpl extends RouteAlert {
  _RouteAlertImpl({
    required String severity,
    required String title,
    required String summary,
    required DateTime startAt,
    required DateTime endAt,
    required int fromSeq,
    required int toSeq,
  }) : super._(
         severity: severity,
         title: title,
         summary: summary,
         startAt: startAt,
         endAt: endAt,
         fromSeq: fromSeq,
         toSeq: toSeq,
       );

  /// Returns a shallow copy of this [RouteAlert]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RouteAlert copyWith({
    String? severity,
    String? title,
    String? summary,
    DateTime? startAt,
    DateTime? endAt,
    int? fromSeq,
    int? toSeq,
  }) {
    return RouteAlert(
      severity: severity ?? this.severity,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      fromSeq: fromSeq ?? this.fromSeq,
      toSeq: toSeq ?? this.toSeq,
    );
  }
}
