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

/// The user's own message to self.
abstract class SelfMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SelfMessage._({
    this.id,
    required this.userId,
    this.entryId,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SelfMessage({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    _isc.UuidValue? entryId,
    required String content,
    DateTime? createdAt,
  }) = _SelfMessageImpl;

  factory SelfMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SelfMessage(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryId: jsonSerialization['entryId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['entryId']),
      content: jsonSerialization['content'] as String,
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

  String content;

  DateTime createdAt;

  /// Returns a shallow copy of this [SelfMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SelfMessage copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    _isc.UuidValue? entryId,
    String? content,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SelfMessage',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SelfMessage',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SelfMessageImpl extends SelfMessage {
  _SelfMessageImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    _isc.UuidValue? entryId,
    required String content,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         entryId: entryId,
         content: content,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SelfMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SelfMessage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    Object? entryId = _Undefined,
    String? content,
    DateTime? createdAt,
  }) {
    return SelfMessage(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      entryId: entryId is _isc.UuidValue? ? entryId : this.entryId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
