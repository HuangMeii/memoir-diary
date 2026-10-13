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

/// What the client needs to upload one image and then confirm it.
abstract class ImageUploadTicket
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ImageUploadTicket._({
    required this.uploadUrl,
    required this.objectKey,
  });

  factory ImageUploadTicket({
    required String uploadUrl,
    required String objectKey,
  }) = _ImageUploadTicketImpl;

  factory ImageUploadTicket.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImageUploadTicket(
      uploadUrl: jsonSerialization['uploadUrl'] as String,
      objectKey: jsonSerialization['objectKey'] as String,
    );
  }

  /// Where to PUT the bytes.
  String uploadUrl;

  /// Server-derived path; pass back to `confirmUpload`.
  String objectKey;

  /// Returns a shallow copy of this [ImageUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImageUploadTicket copyWith({
    String? uploadUrl,
    String? objectKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImageUploadTicket',
      'uploadUrl': uploadUrl,
      'objectKey': objectKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImageUploadTicket',
      'uploadUrl': uploadUrl,
      'objectKey': objectKey,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ImageUploadTicketImpl extends ImageUploadTicket {
  _ImageUploadTicketImpl({
    required String uploadUrl,
    required String objectKey,
  }) : super._(
         uploadUrl: uploadUrl,
         objectKey: objectKey,
       );

  /// Returns a shallow copy of this [ImageUploadTicket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImageUploadTicket copyWith({
    String? uploadUrl,
    String? objectKey,
  }) {
    return ImageUploadTicket(
      uploadUrl: uploadUrl ?? this.uploadUrl,
      objectKey: objectKey ?? this.objectKey,
    );
  }
}
