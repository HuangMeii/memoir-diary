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

/// Mood lookup (5 rows, seeded).
abstract class Mood
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Mood._({
    this.id,
    required this.code,
    required this.labelVi,
    required this.colorHex,
    required this.icon,
    int? sortOrder,
  }) : sortOrder = sortOrder ?? 0;

  factory Mood({
    int? id,
    required String code,
    required String labelVi,
    required String colorHex,
    required String icon,
    int? sortOrder,
  }) = _MoodImpl;

  factory Mood.fromJson(Map<String, dynamic> jsonSerialization) {
    return Mood(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      labelVi: jsonSerialization['labelVi'] as String,
      colorHex: jsonSerialization['colorHex'] as String,
      icon: jsonSerialization['icon'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String labelVi;

  String colorHex;

  String icon;

  int sortOrder;

  /// Returns a shallow copy of this [Mood]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Mood copyWith({
    int? id,
    String? code,
    String? labelVi,
    String? colorHex,
    String? icon,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Mood',
      if (id != null) 'id': id,
      'code': code,
      'labelVi': labelVi,
      'colorHex': colorHex,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Mood',
      if (id != null) 'id': id,
      'code': code,
      'labelVi': labelVi,
      'colorHex': colorHex,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MoodImpl extends Mood {
  _MoodImpl({
    int? id,
    required String code,
    required String labelVi,
    required String colorHex,
    required String icon,
    int? sortOrder,
  }) : super._(
         id: id,
         code: code,
         labelVi: labelVi,
         colorHex: colorHex,
         icon: icon,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [Mood]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Mood copyWith({
    Object? id = _Undefined,
    String? code,
    String? labelVi,
    String? colorHex,
    String? icon,
    int? sortOrder,
  }) {
    return Mood(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      labelVi: labelVi ?? this.labelVi,
      colorHex: colorHex ?? this.colorHex,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
