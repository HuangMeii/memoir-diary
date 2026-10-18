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

/// One logged drink. `health_logs.water_ml` is the derived daily total.
abstract class HealthWaterEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthWaterEntry._({
    this.id,
    required this.userId,
    required this.logDate,
    required this.amountMl,
    DateTime? recordedAt,
    this.note,
    DateTime? createdAt,
  }) : recordedAt = recordedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory HealthWaterEntry({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime logDate,
    required int amountMl,
    DateTime? recordedAt,
    String? note,
    DateTime? createdAt,
  }) = _HealthWaterEntryImpl;

  factory HealthWaterEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthWaterEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      logDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['logDate'],
      ),
      amountMl: jsonSerialization['amountMl'] as int,
      recordedAt: jsonSerialization['recordedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['recordedAt'],
            ),
      note: jsonSerialization['note'] as String?,
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

  int amountMl;

  DateTime recordedAt;

  String? note;

  DateTime createdAt;

  /// Returns a shallow copy of this [HealthWaterEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthWaterEntry copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    DateTime? logDate,
    int? amountMl,
    DateTime? recordedAt,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthWaterEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'amountMl': amountMl,
      'recordedAt': recordedAt.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthWaterEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'amountMl': amountMl,
      'recordedAt': recordedAt.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthWaterEntryImpl extends HealthWaterEntry {
  _HealthWaterEntryImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime logDate,
    required int amountMl,
    DateTime? recordedAt,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         logDate: logDate,
         amountMl: amountMl,
         recordedAt: recordedAt,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthWaterEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthWaterEntry copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? logDate,
    int? amountMl,
    DateTime? recordedAt,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return HealthWaterEntry(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      amountMl: amountMl ?? this.amountMl,
      recordedAt: recordedAt ?? this.recordedAt,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
