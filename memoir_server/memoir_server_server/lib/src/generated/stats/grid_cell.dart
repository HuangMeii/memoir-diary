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

/// One coloured cell in the mood/weather month grid.
abstract class GridCell
    implements _is.SerializableModel, _is.ProtocolSerialization {
  GridCell._({
    required this.date,
    this.code,
    this.label,
    this.color,
  });

  factory GridCell({
    required DateTime date,
    String? code,
    String? label,
    String? color,
  }) = _GridCellImpl;

  factory GridCell.fromJson(Map<String, dynamic> jsonSerialization) {
    return GridCell(
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      code: jsonSerialization['code'] as String?,
      label: jsonSerialization['label'] as String?,
      color: jsonSerialization['color'] as String?,
    );
  }

  DateTime date;

  String? code;

  String? label;

  String? color;

  /// Returns a shallow copy of this [GridCell]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GridCell copyWith({
    DateTime? date,
    String? code,
    String? label,
    String? color,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GridCell',
      'date': date.toJson(),
      if (code != null) 'code': code,
      if (label != null) 'label': label,
      if (color != null) 'color': color,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GridCell',
      'date': date.toJson(),
      if (code != null) 'code': code,
      if (label != null) 'label': label,
      if (color != null) 'color': color,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GridCellImpl extends GridCell {
  _GridCellImpl({
    required DateTime date,
    String? code,
    String? label,
    String? color,
  }) : super._(
         date: date,
         code: code,
         label: label,
         color: color,
       );

  /// Returns a shallow copy of this [GridCell]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GridCell copyWith({
    DateTime? date,
    Object? code = _Undefined,
    Object? label = _Undefined,
    Object? color = _Undefined,
  }) {
    return GridCell(
      date: date ?? this.date,
      code: code is String? ? code : this.code,
      label: label is String? ? label : this.label,
      color: color is String? ? color : this.color,
    );
  }
}
