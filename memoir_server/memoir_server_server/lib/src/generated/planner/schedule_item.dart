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

/// Schedule (timetable) item.
abstract class ScheduleItem
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
    _is.UuidValue? id,
    required _is.UuidValue userId,
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
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      startAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['startAt']),
      endAt: jsonSerialization['endAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endAt']),
      recurrenceRule: jsonSerialization['recurrenceRule'] as String?,
      reminderMinutes: jsonSerialization['reminderMinutes'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ScheduleItemTable();

  static const db = ScheduleItemRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  String title;

  DateTime startAt;

  DateTime? endAt;

  String? recurrenceRule;

  int? reminderMinutes;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ScheduleItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScheduleItem copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
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

  static ScheduleItemInclude include() {
    return ScheduleItemInclude._();
  }

  static ScheduleItemIncludeList includeList({
    _is.WhereExpressionBuilder<ScheduleItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduleItemTable>? orderBy,
    _is.OrderByListBuilder<ScheduleItemTable>? orderByList,
    ScheduleItemInclude? include,
  }) {
    return ScheduleItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduleItem.t),
      orderByList: orderByList?.call(ScheduleItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScheduleItemImpl extends ScheduleItem {
  _ScheduleItemImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  ScheduleItem copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    String? title,
    DateTime? startAt,
    Object? endAt = _Undefined,
    Object? recurrenceRule = _Undefined,
    Object? reminderMinutes = _Undefined,
    DateTime? createdAt,
  }) {
    return ScheduleItem(
      id: id is _is.UuidValue? ? id : this.id,
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

class ScheduleItemUpdateTable extends _is.UpdateTable<ScheduleItemTable> {
  ScheduleItemUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startAt(DateTime value) =>
      _is.ColumnValue(
        table.startAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endAt(DateTime? value) => _is.ColumnValue(
    table.endAt,
    value,
  );

  _is.ColumnValue<String, String> recurrenceRule(String? value) =>
      _is.ColumnValue(
        table.recurrenceRule,
        value,
      );

  _is.ColumnValue<int, int> reminderMinutes(int? value) => _is.ColumnValue(
    table.reminderMinutes,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ScheduleItemTable extends _is.Table<_is.UuidValue?> {
  ScheduleItemTable({super.tableRelation})
    : super(tableName: 'schedule_items') {
    updateTable = ScheduleItemUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    startAt = _is.ColumnDateTime(
      'startAt',
      this,
    );
    endAt = _is.ColumnDateTime(
      'endAt',
      this,
    );
    recurrenceRule = _is.ColumnString(
      'recurrenceRule',
      this,
    );
    reminderMinutes = _is.ColumnInt(
      'reminderMinutes',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ScheduleItemUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnString title;

  late final _is.ColumnDateTime startAt;

  late final _is.ColumnDateTime endAt;

  late final _is.ColumnString recurrenceRule;

  late final _is.ColumnInt reminderMinutes;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    title,
    startAt,
    endAt,
    recurrenceRule,
    reminderMinutes,
    createdAt,
  ];
}

class ScheduleItemInclude extends _is.IncludeObject {
  ScheduleItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ScheduleItem.t;
}

class ScheduleItemIncludeList extends _is.IncludeList {
  ScheduleItemIncludeList._({
    _is.WhereExpressionBuilder<ScheduleItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScheduleItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ScheduleItem.t;
}

class ScheduleItemRepository {
  const ScheduleItemRepository._();

  /// Returns a list of [ScheduleItem]s matching the given query parameters.
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
  Future<List<ScheduleItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduleItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduleItemTable>? orderBy,
    _is.OrderByListBuilder<ScheduleItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScheduleItem>(
      where: where?.call(ScheduleItem.t),
      orderBy: orderBy?.call(ScheduleItem.t),
      orderByList: orderByList?.call(ScheduleItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScheduleItem] matching the given query parameters.
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
  Future<ScheduleItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduleItemTable>? where,
    int? offset,
    _is.OrderByBuilder<ScheduleItemTable>? orderBy,
    _is.OrderByListBuilder<ScheduleItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScheduleItem>(
      where: where?.call(ScheduleItem.t),
      orderBy: orderBy?.call(ScheduleItem.t),
      orderByList: orderByList?.call(ScheduleItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScheduleItem] by its [id] or null if no such row exists.
  Future<ScheduleItem?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScheduleItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScheduleItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ScheduleItem]s will have their `id` fields set.
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
  Future<List<ScheduleItem>> insert(
    _is.DatabaseSession session,
    List<ScheduleItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ScheduleItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ScheduleItem] and returns the inserted row.
  ///
  /// The returned [ScheduleItem] will have its `id` field set.
  Future<ScheduleItem> insertRow(
    _is.DatabaseSession session,
    ScheduleItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScheduleItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ScheduleItem]s in the list and returns the resulting rows.
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
  /// The returned [ScheduleItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduleItem>> upsert(
    _is.DatabaseSession session,
    List<ScheduleItem> rows, {
    required _is.ColumnSelections<ScheduleItemTable> conflictColumns,
    _is.ColumnSelections<ScheduleItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduleItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ScheduleItem>(
      rows,
      conflictColumns: conflictColumns(ScheduleItem.t),
      updateColumns: updateColumns?.call(ScheduleItem.t),
      updateWhere: updateWhere?.call(ScheduleItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ScheduleItem] and returns the resulting row.
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
  /// The returned [ScheduleItem] will have its `id` field set.
  Future<ScheduleItem?> upsertRow(
    _is.DatabaseSession session,
    ScheduleItem row, {
    required _is.ColumnSelections<ScheduleItemTable> conflictColumns,
    _is.ColumnSelections<ScheduleItemTable>? updateColumns,
    _is.WhereExpressionBuilder<ScheduleItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ScheduleItem>(
      row,
      conflictColumns: conflictColumns(ScheduleItem.t),
      updateColumns: updateColumns?.call(ScheduleItem.t),
      updateWhere: updateWhere?.call(ScheduleItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduleItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduleItem>> update(
    _is.DatabaseSession session,
    List<ScheduleItem> rows, {
    _is.ColumnSelections<ScheduleItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ScheduleItem>(
      rows,
      columns: columns?.call(ScheduleItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ScheduleItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScheduleItem> updateRow(
    _is.DatabaseSession session,
    ScheduleItem row, {
    _is.ColumnSelections<ScheduleItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScheduleItem>(
      row,
      columns: columns?.call(ScheduleItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScheduleItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScheduleItem?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ScheduleItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ScheduleItem>(
      id,
      columnValues: columnValues(ScheduleItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScheduleItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScheduleItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ScheduleItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ScheduleItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScheduleItemTable>? orderBy,
    _is.OrderByListBuilder<ScheduleItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ScheduleItem>(
      columnValues: columnValues(ScheduleItem.t.updateTable),
      where: where(ScheduleItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScheduleItem.t),
      orderByList: orderByList?.call(ScheduleItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ScheduleItem]s in the list and returns the deleted rows.
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
  Future<List<ScheduleItem>> delete(
    _is.DatabaseSession session,
    List<ScheduleItem> rows, {
    _is.OrderByBuilder<ScheduleItemTable>? orderBy,
    _is.OrderByListBuilder<ScheduleItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ScheduleItem>(
      rows,
      orderBy: orderBy?.call(ScheduleItem.t),
      orderByList: orderByList?.call(ScheduleItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ScheduleItem].
  Future<ScheduleItem> deleteRow(
    _is.DatabaseSession session,
    ScheduleItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScheduleItem>(
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
  Future<List<ScheduleItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduleItemTable> where,
    _is.OrderByBuilder<ScheduleItemTable>? orderBy,
    _is.OrderByListBuilder<ScheduleItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ScheduleItem>(
      where: where(ScheduleItem.t),
      orderBy: orderBy?.call(ScheduleItem.t),
      orderByList: orderByList?.call(ScheduleItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScheduleItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ScheduleItem>(
      where: where?.call(ScheduleItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScheduleItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScheduleItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScheduleItem>(
      where: where(ScheduleItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
