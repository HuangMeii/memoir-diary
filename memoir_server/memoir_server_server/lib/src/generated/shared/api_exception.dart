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

/// Serializable API exception so the client receives a code and a message.
/// Throw on the server; catch `on ApiException` on the client.
abstract class ApiException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ApiException._({
    required this.message,
    this.code,
  });

  factory ApiException({
    required String message,
    String? code,
  }) = _ApiExceptionImpl;

  factory ApiException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String?,
    );
  }

  String message;

  /// Stable code: unauthorized | forbidden | conflict | notFound | validation.
  String? code;

  /// Returns a shallow copy of this [ApiException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApiException copyWith({
    String? message,
    String? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiException',
      'message': message,
      if (code != null) 'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiException',
      'message': message,
      if (code != null) 'code': code,
    };
  }

  @override
  String toString() {
    return 'ApiException(message: $message, code: $code)';
  }
}

class _Undefined {}

class _ApiExceptionImpl extends ApiException {
  _ApiExceptionImpl({
    required String message,
    String? code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [ApiException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApiException copyWith({
    String? message,
    Object? code = _Undefined,
  }) {
    return ApiException(
      message: message ?? this.message,
      code: code is String? ? code : this.code,
    );
  }
}
