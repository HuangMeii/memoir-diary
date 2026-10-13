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

/// User account (multi-user). Mirrors the FastAPI `users` table.
abstract class User
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  User._({
    this.id,
    required this.email,
    required this.username,
    this.displayName,
    bool? isActive,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.weatherLat,
    this.weatherLon,
    this.weatherLocationName,
  }) : isActive = isActive ?? true,
       role = role ?? 'user',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory User({
    _isc.UuidValue? id,
    required String email,
    required String username,
    String? displayName,
    bool? isActive,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? weatherLat,
    double? weatherLon,
    String? weatherLocationName,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      email: jsonSerialization['email'] as String,
      username: jsonSerialization['username'] as String,
      displayName: jsonSerialization['displayName'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      role: jsonSerialization['role'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      weatherLat: (jsonSerialization['weatherLat'] as num?)?.toDouble(),
      weatherLon: (jsonSerialization['weatherLon'] as num?)?.toDouble(),
      weatherLocationName: jsonSerialization['weatherLocationName'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String email;

  String username;

  String? displayName;

  bool isActive;

  /// "user" | "admin" (plain string, not an enum, so adding one is a code change).
  String role;

  DateTime createdAt;

  DateTime updatedAt;

  /// Optional weather location; null falls back to the configured default.
  double? weatherLat;

  double? weatherLon;

  String? weatherLocationName;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  User copyWith({
    _isc.UuidValue? id,
    String? email,
    String? username,
    String? displayName,
    bool? isActive,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? weatherLat,
    double? weatherLon,
    String? weatherLocationName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'username': username,
      if (displayName != null) 'displayName': displayName,
      'isActive': isActive,
      'role': role,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (weatherLat != null) 'weatherLat': weatherLat,
      if (weatherLon != null) 'weatherLon': weatherLon,
      if (weatherLocationName != null)
        'weatherLocationName': weatherLocationName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id?.toJson(),
      'email': email,
      'username': username,
      if (displayName != null) 'displayName': displayName,
      'isActive': isActive,
      'role': role,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (weatherLat != null) 'weatherLat': weatherLat,
      if (weatherLon != null) 'weatherLon': weatherLon,
      if (weatherLocationName != null)
        'weatherLocationName': weatherLocationName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    _isc.UuidValue? id,
    required String email,
    required String username,
    String? displayName,
    bool? isActive,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? weatherLat,
    double? weatherLon,
    String? weatherLocationName,
  }) : super._(
         id: id,
         email: email,
         username: username,
         displayName: displayName,
         isActive: isActive,
         role: role,
         createdAt: createdAt,
         updatedAt: updatedAt,
         weatherLat: weatherLat,
         weatherLon: weatherLon,
         weatherLocationName: weatherLocationName,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    String? email,
    String? username,
    Object? displayName = _Undefined,
    bool? isActive,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? weatherLat = _Undefined,
    Object? weatherLon = _Undefined,
    Object? weatherLocationName = _Undefined,
  }) {
    return User(
      id: id is _isc.UuidValue? ? id : this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName is String? ? displayName : this.displayName,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      weatherLat: weatherLat is double? ? weatherLat : this.weatherLat,
      weatherLon: weatherLon is double? ? weatherLon : this.weatherLon,
      weatherLocationName: weatherLocationName is String?
          ? weatherLocationName
          : this.weatherLocationName,
    );
  }
}
