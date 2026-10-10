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

/// Opaque session token issued at login. Stored so logout can revoke it.
abstract class AuthToken
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuthToken._({
    this.id,
    required this.userId,
    required this.token,
    required this.expiresAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AuthToken({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String token,
    required DateTime expiresAt,
    DateTime? createdAt,
  }) = _AuthTokenImpl;

  factory AuthToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthToken(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      token: jsonSerialization['token'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
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

  String token;

  DateTime expiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuthToken copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? token,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthToken',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthToken',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthTokenImpl extends AuthToken {
  _AuthTokenImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String token,
    required DateTime expiresAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         token: token,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuthToken copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? token,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return AuthToken(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
