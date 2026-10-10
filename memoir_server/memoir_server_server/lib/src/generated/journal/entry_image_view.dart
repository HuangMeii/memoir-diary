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
import 'package:memoir_server_server/src/generated/protocol.dart' as _is9lv3rz;
import 'package:serverpod/serverpod.dart' as _is;
import '../journal/entry_image.dart' as _ix8vzpjv;

/// An image row plus a short-lived download URL.
abstract class EntryImageView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  EntryImageView._({
    required this.image,
    required this.url,
  });

  factory EntryImageView({
    required _ix8vzpjv.EntryImage image,
    required String url,
  }) = _EntryImageViewImpl;

  factory EntryImageView.fromJson(Map<String, dynamic> jsonSerialization) {
    return EntryImageView(
      image: _is9lv3rz.Protocol().deserialize<_ix8vzpjv.EntryImage>(
        jsonSerialization['image'],
      ),
      url: jsonSerialization['url'] as String,
    );
  }

  _ix8vzpjv.EntryImage image;

  String url;

  /// Returns a shallow copy of this [EntryImageView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EntryImageView copyWith({
    _ix8vzpjv.EntryImage? image,
    String? url,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EntryImageView',
      'image': image.toJson(),
      'url': url,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EntryImageView',
      'image': image.toJsonForProtocol(),
      'url': url,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _EntryImageViewImpl extends EntryImageView {
  _EntryImageViewImpl({
    required _ix8vzpjv.EntryImage image,
    required String url,
  }) : super._(
         image: image,
         url: url,
       );

  /// Returns a shallow copy of this [EntryImageView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EntryImageView copyWith({
    _ix8vzpjv.EntryImage? image,
    String? url,
  }) {
    return EntryImageView(
      image: image ?? this.image.copyWith(),
      url: url ?? this.url,
    );
  }
}
