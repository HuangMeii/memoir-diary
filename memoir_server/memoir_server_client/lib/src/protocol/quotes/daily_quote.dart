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

/// The quote pair shown on a given day. One row per user per day.
abstract class DailyQuote
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyQuote._({
    this.id,
    required this.userId,
    required this.quoteDate,
    this.quoteId,
    this.quoteId2,
    this.selfMessageId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DailyQuote({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime quoteDate,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? quoteId2,
    _isc.UuidValue? selfMessageId,
    DateTime? createdAt,
  }) = _DailyQuoteImpl;

  factory DailyQuote.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyQuote(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      quoteDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['quoteDate'],
      ),
      quoteId: jsonSerialization['quoteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['quoteId']),
      quoteId2: jsonSerialization['quoteId2'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['quoteId2']),
      selfMessageId: jsonSerialization['selfMessageId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['selfMessageId'],
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

  DateTime quoteDate;

  _isc.UuidValue? quoteId;

  /// Second library quote; set when the user has too few self messages.
  _isc.UuidValue? quoteId2;

  _isc.UuidValue? selfMessageId;

  DateTime createdAt;

  /// Returns a shallow copy of this [DailyQuote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyQuote copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    DateTime? quoteDate,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? quoteId2,
    _isc.UuidValue? selfMessageId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyQuote',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'quoteDate': quoteDate.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (quoteId2 != null) 'quoteId2': quoteId2?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyQuote',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'quoteDate': quoteDate.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (quoteId2 != null) 'quoteId2': quoteId2?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyQuoteImpl extends DailyQuote {
  _DailyQuoteImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required DateTime quoteDate,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? quoteId2,
    _isc.UuidValue? selfMessageId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         quoteDate: quoteDate,
         quoteId: quoteId,
         quoteId2: quoteId2,
         selfMessageId: selfMessageId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DailyQuote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyQuote copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? quoteDate,
    Object? quoteId = _Undefined,
    Object? quoteId2 = _Undefined,
    Object? selfMessageId = _Undefined,
    DateTime? createdAt,
  }) {
    return DailyQuote(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      quoteDate: quoteDate ?? this.quoteDate,
      quoteId: quoteId is _isc.UuidValue? ? quoteId : this.quoteId,
      quoteId2: quoteId2 is _isc.UuidValue? ? quoteId2 : this.quoteId2,
      selfMessageId: selfMessageId is _isc.UuidValue?
          ? selfMessageId
          : this.selfMessageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
