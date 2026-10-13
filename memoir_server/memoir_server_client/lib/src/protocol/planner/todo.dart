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

/// Weekly goal / todo.
abstract class Todo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Todo._({
    this.id,
    required this.userId,
    required this.title,
    this.notes,
    this.dueDate,
    this.weekLabel,
    int? priority,
    bool? isDone,
    this.completedAt,
    DateTime? createdAt,
  }) : priority = priority ?? 2,
       isDone = isDone ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Todo({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
    bool? isDone,
    DateTime? completedAt,
    DateTime? createdAt,
  }) = _TodoImpl;

  factory Todo.fromJson(Map<String, dynamic> jsonSerialization) {
    return Todo(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String?,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      weekLabel: jsonSerialization['weekLabel'] as String?,
      priority: jsonSerialization['priority'] as int?,
      isDone: jsonSerialization['isDone'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isDone']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
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

  _isc.UuidValue userId;

  String title;

  String? notes;

  DateTime? dueDate;

  String? weekLabel;

  int priority;

  bool isDone;

  DateTime? completedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Todo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Todo copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    String? title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
    bool? isDone,
    DateTime? completedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Todo',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      if (notes != null) 'notes': notes,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (weekLabel != null) 'weekLabel': weekLabel,
      'priority': priority,
      'isDone': isDone,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Todo',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      if (notes != null) 'notes': notes,
      if (dueDate != null) 'dueDate': dueDate?.toJson(),
      if (weekLabel != null) 'weekLabel': weekLabel,
      'priority': priority,
      'isDone': isDone,
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TodoImpl extends Todo {
  _TodoImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
    required String title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
    bool? isDone,
    DateTime? completedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         notes: notes,
         dueDate: dueDate,
         weekLabel: weekLabel,
         priority: priority,
         isDone: isDone,
         completedAt: completedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Todo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Todo copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? title,
    Object? notes = _Undefined,
    Object? dueDate = _Undefined,
    Object? weekLabel = _Undefined,
    int? priority,
    bool? isDone,
    Object? completedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      notes: notes is String? ? notes : this.notes,
      dueDate: dueDate is DateTime? ? dueDate : this.dueDate,
      weekLabel: weekLabel is String? ? weekLabel : this.weekLabel,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
