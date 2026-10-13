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

/// User's thoughts about the daily quote + self message pair.
abstract class Reflection
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Reflection._({
    this.id,
    required this.userId,
    this.entryId,
    this.quoteId,
    this.selfMessageId,
    this.thought,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Reflection({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    _isc.UuidValue? entryId,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? selfMessageId,
    String? thought,
    DateTime? createdAt,
  }) = _ReflectionImpl;

  factory Reflection.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reflection(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryId: jsonSerialization['entryId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['entryId']),
      quoteId: jsonSerialization['quoteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['quoteId']),
      selfMessageId: jsonSerialization['selfMessageId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['selfMessageId'],
            ),
      thought: jsonSerialization['thought'] as String?,
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

  _isc.UuidValue? entryId;

  _isc.UuidValue? quoteId;

  _isc.UuidValue? selfMessageId;

  String? thought;

  DateTime createdAt;

  /// Returns a shallow copy of this [Reflection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Reflection copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    _isc.UuidValue? entryId,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? selfMessageId,
    String? thought,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reflection',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      if (thought != null) 'thought': thought,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reflection',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      if (thought != null) 'thought': thought,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReflectionImpl extends Reflection {
  _ReflectionImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    _isc.UuidValue? entryId,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? selfMessageId,
    String? thought,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         entryId: entryId,
         quoteId: quoteId,
         selfMessageId: selfMessageId,
         thought: thought,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Reflection]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Reflection copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    Object? entryId = _Undefined,
    Object? quoteId = _Undefined,
    Object? selfMessageId = _Undefined,
    Object? thought = _Undefined,
    DateTime? createdAt,
  }) {
    return Reflection(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      entryId: entryId is _isc.UuidValue? ? entryId : this.entryId,
      quoteId: quoteId is _isc.UuidValue? ? quoteId : this.quoteId,
      selfMessageId: selfMessageId is _isc.UuidValue?
          ? selfMessageId
          : this.selfMessageId,
      thought: thought is String? ? thought : this.thought,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
