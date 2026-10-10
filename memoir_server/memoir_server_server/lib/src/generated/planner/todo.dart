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

/// Weekly goal / todo.
abstract class Todo
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
    _is.UuidValue? id,
    required _is.UuidValue userId,
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
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      notes: jsonSerialization['notes'] as String?,
      dueDate: jsonSerialization['dueDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueDate']),
      weekLabel: jsonSerialization['weekLabel'] as String?,
      priority: jsonSerialization['priority'] as int?,
      isDone: jsonSerialization['isDone'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDone']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = TodoTable();

  static const db = TodoRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  String title;

  String? notes;

  DateTime? dueDate;

  String? weekLabel;

  int priority;

  bool isDone;

  DateTime? completedAt;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Todo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Todo copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
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

  static TodoInclude include() {
    return TodoInclude._();
  }

  static TodoIncludeList includeList({
    _is.WhereExpressionBuilder<TodoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TodoTable>? orderBy,
    _is.OrderByListBuilder<TodoTable>? orderByList,
    TodoInclude? include,
  }) {
    return TodoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TodoImpl extends Todo {
  _TodoImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  Todo copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
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
      id: id is _is.UuidValue? ? id : this.id,
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

class TodoUpdateTable extends _is.UpdateTable<TodoTable> {
  TodoUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> notes(String? value) => _is.ColumnValue(
    table.notes,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueDate(DateTime? value) =>
      _is.ColumnValue(
        table.dueDate,
        value,
      );

  _is.ColumnValue<String, String> weekLabel(String? value) => _is.ColumnValue(
    table.weekLabel,
    value,
  );

  _is.ColumnValue<int, int> priority(int value) => _is.ColumnValue(
    table.priority,
    value,
  );

  _is.ColumnValue<bool, bool> isDone(bool value) => _is.ColumnValue(
    table.isDone,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _is.ColumnValue(
        table.completedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class TodoTable extends _is.Table<_is.UuidValue?> {
  TodoTable({super.tableRelation}) : super(tableName: 'todos') {
    updateTable = TodoUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
    dueDate = _is.ColumnDateTime(
      'dueDate',
      this,
    );
    weekLabel = _is.ColumnString(
      'weekLabel',
      this,
    );
    priority = _is.ColumnInt(
      'priority',
      this,
      hasDefault: true,
    );
    isDone = _is.ColumnBool(
      'isDone',
      this,
      hasDefault: true,
    );
    completedAt = _is.ColumnDateTime(
      'completedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final TodoUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnString title;

  late final _is.ColumnString notes;

  late final _is.ColumnDateTime dueDate;

  late final _is.ColumnString weekLabel;

  late final _is.ColumnInt priority;

  late final _is.ColumnBool isDone;

  late final _is.ColumnDateTime completedAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    title,
    notes,
    dueDate,
    weekLabel,
    priority,
    isDone,
    completedAt,
    createdAt,
  ];
}

class TodoInclude extends _is.IncludeObject {
  TodoInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Todo.t;
}

class TodoIncludeList extends _is.IncludeList {
  TodoIncludeList._({
    _is.WhereExpressionBuilder<TodoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Todo.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Todo.t;
}

class TodoRepository {
  const TodoRepository._();

  /// Returns a list of [Todo]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Todo>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TodoTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TodoTable>? orderBy,
    _is.OrderByListBuilder<TodoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Todo>(
      where: where?.call(Todo.t),
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Todo] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Todo?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TodoTable>? where,
    int? offset,
    _is.OrderByBuilder<TodoTable>? orderBy,
    _is.OrderByListBuilder<TodoTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Todo>(
      where: where?.call(Todo.t),
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Todo] by its [id] or null if no such row exists.
  Future<Todo?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Todo>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Todo]s in the list and returns the inserted rows.
  ///
  /// The returned [Todo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Todo>> insert(
    _is.DatabaseSession session,
    List<Todo> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Todo>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Todo] and returns the inserted row.
  ///
  /// The returned [Todo] will have its `id` field set.
  Future<Todo> insertRow(
    _is.DatabaseSession session,
    Todo row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Todo>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Todo]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Todo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Todo>> upsert(
    _is.DatabaseSession session,
    List<Todo> rows, {
    required _is.ColumnSelections<TodoTable> conflictColumns,
    _is.ColumnSelections<TodoTable>? updateColumns,
    _is.WhereExpressionBuilder<TodoTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Todo>(
      rows,
      conflictColumns: conflictColumns(Todo.t),
      updateColumns: updateColumns?.call(Todo.t),
      updateWhere: updateWhere?.call(Todo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Todo] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Todo] will have its `id` field set.
  Future<Todo?> upsertRow(
    _is.DatabaseSession session,
    Todo row, {
    required _is.ColumnSelections<TodoTable> conflictColumns,
    _is.ColumnSelections<TodoTable>? updateColumns,
    _is.WhereExpressionBuilder<TodoTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Todo>(
      row,
      conflictColumns: conflictColumns(Todo.t),
      updateColumns: updateColumns?.call(Todo.t),
      updateWhere: updateWhere?.call(Todo.t),
      transaction: transaction,
    );
  }

  /// Updates all [Todo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Todo>> update(
    _is.DatabaseSession session,
    List<Todo> rows, {
    _is.ColumnSelections<TodoTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Todo>(
      rows,
      columns: columns?.call(Todo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Todo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Todo> updateRow(
    _is.DatabaseSession session,
    Todo row, {
    _is.ColumnSelections<TodoTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Todo>(
      row,
      columns: columns?.call(Todo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Todo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Todo?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TodoUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Todo>(
      id,
      columnValues: columnValues(Todo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Todo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Todo>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TodoUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TodoTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TodoTable>? orderBy,
    _is.OrderByListBuilder<TodoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Todo>(
      columnValues: columnValues(Todo.t.updateTable),
      where: where(Todo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Todo]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Todo>> delete(
    _is.DatabaseSession session,
    List<Todo> rows, {
    _is.OrderByBuilder<TodoTable>? orderBy,
    _is.OrderByListBuilder<TodoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Todo>(
      rows,
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Todo].
  Future<Todo> deleteRow(
    _is.DatabaseSession session,
    Todo row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Todo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Todo>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TodoTable> where,
    _is.OrderByBuilder<TodoTable>? orderBy,
    _is.OrderByListBuilder<TodoTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Todo>(
      where: where(Todo.t),
      orderBy: orderBy?.call(Todo.t),
      orderByList: orderByList?.call(Todo.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TodoTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Todo>(
      where: where?.call(Todo.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Todo] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TodoTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Todo>(
      where: where(Todo.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
