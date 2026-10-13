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

/// Motivational / educational quote. Null userId = system seed quote.
abstract class Quote
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Quote._({
    this.id,
    this.userId,
    required this.text,
    this.author,
    this.source,
    this.category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isActive = isActive ?? true,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Quote({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    required String text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _QuoteImpl;

  factory Quote.fromJson(Map<String, dynamic> jsonSerialization) {
    return Quote(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: jsonSerialization['userId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      text: jsonSerialization['text'] as String,
      author: jsonSerialization['author'] as String?,
      source: jsonSerialization['source'] as String?,
      category: jsonSerialization['category'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue? userId;

  String text;

  String? author;

  String? source;

  String? category;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Quote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Quote copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Quote',
      if (id != null) 'id': id?.toJson(),
      if (userId != null) 'userId': userId?.toJson(),
      'text': text,
      if (author != null) 'author': author,
      if (source != null) 'source': source,
      if (category != null) 'category': category,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Quote',
      if (id != null) 'id': id?.toJson(),
      if (userId != null) 'userId': userId?.toJson(),
      'text': text,
      if (author != null) 'author': author,
      if (source != null) 'source': source,
      if (category != null) 'category': category,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuoteImpl extends Quote {
  _QuoteImpl({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    required String text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         text: text,
         author: author,
         source: source,
         category: category,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Quote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Quote copyWith({
    Object? id = _Undefined,
    Object? userId = _Undefined,
    String? text,
    Object? author = _Undefined,
    Object? source = _Undefined,
    Object? category = _Undefined,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Quote(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId is _isc.UuidValue? ? userId : this.userId,
      text: text ?? this.text,
      author: author is String? ? author : this.author,
      source: source is String? ? source : this.source,
      category: category is String? ? category : this.category,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
