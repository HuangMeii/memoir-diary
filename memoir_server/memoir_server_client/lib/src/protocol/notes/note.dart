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
import 'package:memoir_server_client/src/protocol/protocol.dart' as _itoi32v3;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Quick note.
abstract class Note
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Note._({
    this.id,
    required this.userId,
    this.title,
    required this.content,
    this.color,
    this.tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isPinned = isPinned ?? false,
       isArchived = isArchived ?? false,
       isTrashed = isTrashed ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Note({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    String? title,
    required String content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NoteImpl;

  factory Note.fromJson(Map<String, dynamic> jsonSerialization) {
    return Note(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String?,
      content: jsonSerialization['content'] as String,
      color: jsonSerialization['color'] as String?,
      tags: jsonSerialization['tags'] == null
          ? null
          : _itoi32v3.Protocol().deserialize<List<String>>(
              jsonSerialization['tags'],
            ),
      isPinned: jsonSerialization['isPinned'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isPinned']),
      isArchived: jsonSerialization['isArchived'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isArchived']),
      isTrashed: jsonSerialization['isTrashed'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isTrashed']),
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

  _isc.UuidValue userId;

  /// Tiêu đề riêng; `content` giữ vai trò thân ghi chú.
  String? title;

  String content;

  String? color;

  /// Thẻ tự do, không phân cấp; UI hiển thị dạng `#tag`.
  /// Serverpod không hỗ trợ `default` cho List nên để nullable,
  /// endpoint sẽ chuẩn hoá null thành [] khi tạo/sửa.
  List<String>? tags;

  bool isPinned;

  bool isArchived;

  bool isTrashed;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Note]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Note copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? title,
    String? content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Note',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (title != null) 'title': title,
      'content': content,
      if (color != null) 'color': color,
      if (tags != null) 'tags': tags?.toJson(),
      'isPinned': isPinned,
      'isArchived': isArchived,
      'isTrashed': isTrashed,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Note',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (title != null) 'title': title,
      'content': content,
      if (color != null) 'color': color,
      if (tags != null) 'tags': tags?.toJson(),
      'isPinned': isPinned,
      'isArchived': isArchived,
      'isTrashed': isTrashed,
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

class _NoteImpl extends Note {
  _NoteImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    String? title,
    required String content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         content: content,
         color: color,
         tags: tags,
         isPinned: isPinned,
         isArchived: isArchived,
         isTrashed: isTrashed,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Note]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Note copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    Object? title = _Undefined,
    String? content,
    Object? color = _Undefined,
    Object? tags = _Undefined,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title is String? ? title : this.title,
      content: content ?? this.content,
      color: color is String? ? color : this.color,
      tags: tags is List<String>? ? tags : this.tags?.map((e0) => e0).toList(),
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isTrashed: isTrashed ?? this.isTrashed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
