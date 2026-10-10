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

/// Entry image metadata. Bytes live in object storage.
abstract class EntryImage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  EntryImage._({
    this.id,
    required this.entryId,
    required this.objectKey,
    this.url,
    String? contentType,
    this.sizeBytes,
    this.width,
    this.height,
    this.caption,
    DateTime? createdAt,
  }) : contentType = contentType ?? 'image/jpeg',
       createdAt = createdAt ?? DateTime.now();

  factory EntryImage({
    _isc.UuidValue? id,
    required _isc.UuidValue entryId,
    required String objectKey,
    String? url,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
    DateTime? createdAt,
  }) = _EntryImageImpl;

  factory EntryImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return EntryImage(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      entryId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['entryId'],
      ),
      objectKey: jsonSerialization['objectKey'] as String,
      url: jsonSerialization['url'] as String?,
      contentType: jsonSerialization['contentType'] as String?,
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      width: jsonSerialization['width'] as int?,
      height: jsonSerialization['height'] as int?,
      caption: jsonSerialization['caption'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue entryId;

  String objectKey;

  String? url;

  String contentType;

  int? sizeBytes;

  int? width;

  int? height;

  String? caption;

  DateTime createdAt;

  /// Returns a shallow copy of this [EntryImage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EntryImage copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? entryId,
    String? objectKey,
    String? url,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EntryImage',
      if (id != null) 'id': id?.toJson(),
      'entryId': entryId.toJson(),
      'objectKey': objectKey,
      if (url != null) 'url': url,
      'contentType': contentType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (caption != null) 'caption': caption,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EntryImage',
      if (id != null) 'id': id?.toJson(),
      'entryId': entryId.toJson(),
      'objectKey': objectKey,
      if (url != null) 'url': url,
      'contentType': contentType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (caption != null) 'caption': caption,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EntryImageImpl extends EntryImage {
  _EntryImageImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue entryId,
    required String objectKey,
    String? url,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
    DateTime? createdAt,
  }) : super._(
         id: id,
         entryId: entryId,
         objectKey: objectKey,
         url: url,
         contentType: contentType,
         sizeBytes: sizeBytes,
         width: width,
         height: height,
         caption: caption,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EntryImage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EntryImage copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? entryId,
    String? objectKey,
    Object? url = _Undefined,
    String? contentType,
    Object? sizeBytes = _Undefined,
    Object? width = _Undefined,
    Object? height = _Undefined,
    Object? caption = _Undefined,
    DateTime? createdAt,
  }) {
    return EntryImage(
      id: id is _isc.UuidValue? ? id : this.id,
      entryId: entryId ?? this.entryId,
      objectKey: objectKey ?? this.objectKey,
      url: url is String? ? url : this.url,
      contentType: contentType ?? this.contentType,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      width: width is int? ? width : this.width,
      height: height is int? ? height : this.height,
      caption: caption is String? ? caption : this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
