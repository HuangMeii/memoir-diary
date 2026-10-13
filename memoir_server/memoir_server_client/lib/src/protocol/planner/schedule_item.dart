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

/// Schedule (timetable) item.
abstract class ScheduleItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ScheduleItem._({
    this.id,
    required this.userId,
    required this.title,
    required this.startAt,
    this.endAt,
    this.recurrenceRule,
    this.reminderMinutes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ScheduleItem({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    required DateTime startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
    DateTime? createdAt,
  }) = _ScheduleItemImpl;

  factory ScheduleItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScheduleItem(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      endAt: jsonSerialization['endAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      recurrenceRule: jsonSerialization['recurrenceRule'] as String?,
      reminderMinutes: jsonSerialization['reminderMinutes'] as int?,
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

  String title;

  DateTime startAt;

  DateTime? endAt;

  String? recurrenceRule;

  int? reminderMinutes;

  DateTime createdAt;

  /// Returns a shallow copy of this [ScheduleItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ScheduleItem copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? title,
    DateTime? startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScheduleItem',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      'startAt': startAt.toJson(),
      if (endAt != null) 'endAt': endAt?.toJson(),
      if (recurrenceRule != null) 'recurrenceRule': recurrenceRule,
      if (reminderMinutes != null) 'reminderMinutes': reminderMinutes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScheduleItem',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      'startAt': startAt.toJson(),
      if (endAt != null) 'endAt': endAt?.toJson(),
      if (recurrenceRule != null) 'recurrenceRule': recurrenceRule,
      if (reminderMinutes != null) 'reminderMinutes': reminderMinutes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduleItemImpl extends ScheduleItem {
  _ScheduleItemImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    required DateTime startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         startAt: startAt,
         endAt: endAt,
         recurrenceRule: recurrenceRule,
         reminderMinutes: reminderMinutes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ScheduleItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ScheduleItem copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? title,
    DateTime? startAt,
    Object? endAt = _Undefined,
    Object? recurrenceRule = _Undefined,
    Object? reminderMinutes = _Undefined,
    DateTime? createdAt,
  }) {
    return ScheduleItem(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      startAt: startAt ?? this.startAt,
      endAt: endAt is DateTime? ? endAt : this.endAt,
      recurrenceRule: recurrenceRule is String?
          ? recurrenceRule
          : this.recurrenceRule,
      reminderMinutes: reminderMinutes is int?
          ? reminderMinutes
          : this.reminderMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
