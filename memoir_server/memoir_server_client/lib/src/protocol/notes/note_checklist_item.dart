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

/// One checklist line inside a note (interactive to-do block).
abstract class NoteChecklistItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NoteChecklistItem._({
    this.id,
    required this.noteId,
    required this.text,
    bool? isDone,
    int? sortOrder,
  }) : isDone = isDone ?? false,
       sortOrder = sortOrder ?? 0;

  factory NoteChecklistItem({
    _isc.UuidValue? id,
    required _isc.UuidValue noteId,
    required String text,
    bool? isDone,
    int? sortOrder,
  }) = _NoteChecklistItemImpl;

  factory NoteChecklistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return NoteChecklistItem(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      noteId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['noteId']),
      text: jsonSerialization['text'] as String,
      isDone: jsonSerialization['isDone'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isDone']),
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue noteId;

  String text;

  bool isDone;

  /// Thứ tự hiển thị; 0-based, tăng dần từ trên xuống.
  int sortOrder;

  /// Returns a shallow copy of this [NoteChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NoteChecklistItem copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? noteId,
    String? text,
    bool? isDone,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NoteChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'noteId': noteId.toJson(),
      'text': text,
      'isDone': isDone,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NoteChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'noteId': noteId.toJson(),
      'text': text,
      'isDone': isDone,
      'sortOrder': sortOrder,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NoteChecklistItemImpl extends NoteChecklistItem {
  _NoteChecklistItemImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue noteId,
    required String text,
    bool? isDone,
    int? sortOrder,
  }) : super._(
         id: id,
         noteId: noteId,
         text: text,
         isDone: isDone,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [NoteChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NoteChecklistItem copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? noteId,
    String? text,
    bool? isDone,
    int? sortOrder,
  }) {
    return NoteChecklistItem(
      id: id is _isc.UuidValue? ? id : this.id,
      noteId: noteId ?? this.noteId,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
