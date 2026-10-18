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

/// A milestone the user adds to the day's activity timeline.
abstract class HealthActivity
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthActivity._({
    this.id,
    required this.userId,
    required this.logDate,
    required this.atTime,
    required this.title,
    this.detail,
    String? kind,
    DateTime? createdAt,
  }) : kind = kind ?? 'note',
       createdAt = createdAt ?? DateTime.now();

  factory HealthActivity({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime logDate,
    required String atTime,
    required String title,
    String? detail,
    String? kind,
    DateTime? createdAt,
  }) = _HealthActivityImpl;

  factory HealthActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthActivity(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      logDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['logDate'],
      ),
      atTime: jsonSerialization['atTime'] as String,
      title: jsonSerialization['title'] as String,
      detail: jsonSerialization['detail'] as String?,
      kind: jsonSerialization['kind'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue userId;

  DateTime logDate;

  String atTime;

  String title;

  String? detail;

  /// `note` (tự thêm) — chỗ để mở rộng loại mốc khác sau này.
  String kind;

  DateTime createdAt;

  /// Returns a shallow copy of this [HealthActivity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthActivity copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    DateTime? logDate,
    String? atTime,
    String? title,
    String? detail,
    String? kind,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthActivity',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'atTime': atTime,
      'title': title,
      if (detail != null) 'detail': detail,
      'kind': kind,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthActivity',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'atTime': atTime,
      'title': title,
      if (detail != null) 'detail': detail,
      'kind': kind,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthActivityImpl extends HealthActivity {
  _HealthActivityImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime logDate,
    required String atTime,
    required String title,
    String? detail,
    String? kind,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         logDate: logDate,
         atTime: atTime,
         title: title,
         detail: detail,
         kind: kind,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthActivity]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthActivity copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? logDate,
    String? atTime,
    String? title,
    Object? detail = _Undefined,
    String? kind,
    DateTime? createdAt,
  }) {
    return HealthActivity(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      atTime: atTime ?? this.atTime,
      title: title ?? this.title,
      detail: detail is String? ? detail : this.detail,
      kind: kind ?? this.kind,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
