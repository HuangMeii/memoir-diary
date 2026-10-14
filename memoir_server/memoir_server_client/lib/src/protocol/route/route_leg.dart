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

/// One leg of a route: from the previous stop to stop number [toIndex].
abstract class RouteLeg
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RouteLeg._({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.toIndex,
  });

  factory RouteLeg({
    required int distanceMeters,
    required int durationSeconds,
    required int toIndex,
  }) = _RouteLegImpl;

  factory RouteLeg.fromJson(Map<String, dynamic> jsonSerialization) {
    return RouteLeg(
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      toIndex: jsonSerialization['toIndex'] as int,
    );
  }

  int distanceMeters;

  int durationSeconds;

  /// Index into `RoutePlan.stops` this leg arrives at (leg i ends at stop i + 1).
  int toIndex;

  /// Returns a shallow copy of this [RouteLeg]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RouteLeg copyWith({
    int? distanceMeters,
    int? durationSeconds,
    int? toIndex,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RouteLeg',
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'toIndex': toIndex,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RouteLeg',
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'toIndex': toIndex,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RouteLegImpl extends RouteLeg {
  _RouteLegImpl({
    required int distanceMeters,
    required int durationSeconds,
    required int toIndex,
  }) : super._(
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         toIndex: toIndex,
       );

  /// Returns a shallow copy of this [RouteLeg]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RouteLeg copyWith({
    int? distanceMeters,
    int? durationSeconds,
    int? toIndex,
  }) {
    return RouteLeg(
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      toIndex: toIndex ?? this.toIndex,
    );
  }
}
