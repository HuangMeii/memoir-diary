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

/// Many-to-many link between a note and the diary entries it references.
abstract class NoteEntryLink
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NoteEntryLink._({
    this.id,
    required this.noteId,
    required this.entryId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NoteEntryLink({
    _isc.UuidValue? id,
    required _isc.UuidValue noteId,
    required _isc.UuidValue entryId,
    DateTime? createdAt,
  }) = _NoteEntryLinkImpl;

  factory NoteEntryLink.fromJson(Map<String, dynamic> jsonSerialization) {
    return NoteEntryLink(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      noteId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['noteId']),
      entryId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['entryId'],
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

  _isc.UuidValue noteId;

  _isc.UuidValue entryId;

  DateTime createdAt;

  /// Returns a shallow copy of this [NoteEntryLink]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NoteEntryLink copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? noteId,
    _isc.UuidValue? entryId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NoteEntryLink',
      if (id != null) 'id': id?.toJson(),
      'noteId': noteId.toJson(),
      'entryId': entryId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NoteEntryLink',
      if (id != null) 'id': id?.toJson(),
      'noteId': noteId.toJson(),
      'entryId': entryId.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NoteEntryLinkImpl extends NoteEntryLink {
  _NoteEntryLinkImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue noteId,
    required _isc.UuidValue entryId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         noteId: noteId,
         entryId: entryId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [NoteEntryLink]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NoteEntryLink copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? noteId,
    _isc.UuidValue? entryId,
    DateTime? createdAt,
  }) {
    return NoteEntryLink(
      id: id is _isc.UuidValue? ? id : this.id,
      noteId: noteId ?? this.noteId,
      entryId: entryId ?? this.entryId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
