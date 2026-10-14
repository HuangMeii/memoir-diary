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
import '../journal/diary_entry.dart' as _iov5s3oy;
import '../notes/note.dart' as _i9a2yvtv;
import '../notes/note_checklist_item.dart' as _iq1e2yb8;

/// Note + its checklist and linked diary entries, for the note editor.
abstract class NoteDetail
    implements _is.SerializableModel, _is.ProtocolSerialization {
  NoteDetail._({
    required this.note,
    required this.checklist,
    required this.entries,
  });

  factory NoteDetail({
    required _i9a2yvtv.Note note,
    required List<_iq1e2yb8.NoteChecklistItem> checklist,
    required List<_iov5s3oy.DiaryEntry> entries,
  }) = _NoteDetailImpl;

  factory NoteDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return NoteDetail(
      note: _is9lv3rz.Protocol().deserialize<_i9a2yvtv.Note>(
        jsonSerialization['note'],
      ),
      checklist: _is9lv3rz.Protocol()
          .deserialize<List<_iq1e2yb8.NoteChecklistItem>>(
            jsonSerialization['checklist'],
          ),
      entries: _is9lv3rz.Protocol().deserialize<List<_iov5s3oy.DiaryEntry>>(
        jsonSerialization['entries'],
      ),
    );
  }

  _i9a2yvtv.Note note;

  List<_iq1e2yb8.NoteChecklistItem> checklist;

  /// Các trang nhật ký đang liên kết (mới nhất trước).
  List<_iov5s3oy.DiaryEntry> entries;

  /// Returns a shallow copy of this [NoteDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NoteDetail copyWith({
    _i9a2yvtv.Note? note,
    List<_iq1e2yb8.NoteChecklistItem>? checklist,
    List<_iov5s3oy.DiaryEntry>? entries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NoteDetail',
      'note': note.toJson(),
      'checklist': checklist.toJson(valueToJson: (v) => v.toJson()),
      'entries': entries.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NoteDetail',
      'note': note.toJsonForProtocol(),
      'checklist': checklist.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'entries': entries.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _NoteDetailImpl extends NoteDetail {
  _NoteDetailImpl({
    required _i9a2yvtv.Note note,
    required List<_iq1e2yb8.NoteChecklistItem> checklist,
    required List<_iov5s3oy.DiaryEntry> entries,
  }) : super._(
         note: note,
         checklist: checklist,
         entries: entries,
       );

  /// Returns a shallow copy of this [NoteDetail]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NoteDetail copyWith({
    _i9a2yvtv.Note? note,
    List<_iq1e2yb8.NoteChecklistItem>? checklist,
    List<_iov5s3oy.DiaryEntry>? entries,
  }) {
    return NoteDetail(
      note: note ?? this.note.copyWith(),
      checklist:
          checklist ?? this.checklist.map((e0) => e0.copyWith()).toList(),
      entries: entries ?? this.entries.map((e0) => e0.copyWith()).toList(),
    );
  }
}
