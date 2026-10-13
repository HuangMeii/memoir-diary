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

/// Special event.
abstract class Event
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Event._({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.startAt,
    this.endAt,
    this.location,
    bool? isAllDay,
    this.reminderMinutes,
    DateTime? createdAt,
  }) : isAllDay = isAllDay ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Event({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    String? description,
    required DateTime startAt,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
    DateTime? createdAt,
  }) = _EventImpl;

  factory Event.fromJson(Map<String, dynamic> jsonSerialization) {
    return Event(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      startAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startAt'],
      ),
      endAt: jsonSerialization['endAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      location: jsonSerialization['location'] as String?,
      isAllDay: jsonSerialization['isAllDay'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isAllDay']),
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

  String? description;

  DateTime startAt;

  DateTime? endAt;

  String? location;

  bool isAllDay;

  int? reminderMinutes;

  DateTime createdAt;

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Event copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? title,
    String? description,
    DateTime? startAt,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'startAt': startAt.toJson(),
      if (endAt != null) 'endAt': endAt?.toJson(),
      if (location != null) 'location': location,
      'isAllDay': isAllDay,
      if (reminderMinutes != null) 'reminderMinutes': reminderMinutes,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Event',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      if (description != null) 'description': description,
      'startAt': startAt.toJson(),
      if (endAt != null) 'endAt': endAt?.toJson(),
      if (location != null) 'location': location,
      'isAllDay': isAllDay,
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

class _EventImpl extends Event {
  _EventImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    String? description,
    required DateTime startAt,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         description: description,
         startAt: startAt,
         endAt: endAt,
         location: location,
         isAllDay: isAllDay,
         reminderMinutes: reminderMinutes,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Event]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Event copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? title,
    Object? description = _Undefined,
    DateTime? startAt,
    Object? endAt = _Undefined,
    Object? location = _Undefined,
    bool? isAllDay,
    Object? reminderMinutes = _Undefined,
    DateTime? createdAt,
  }) {
    return Event(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      startAt: startAt ?? this.startAt,
      endAt: endAt is DateTime? ? endAt : this.endAt,
      location: location is String? ? location : this.location,
      isAllDay: isAllDay ?? this.isAllDay,
      reminderMinutes: reminderMinutes is int?
          ? reminderMinutes
          : this.reminderMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
