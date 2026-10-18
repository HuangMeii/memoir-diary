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

/// A milestone the user adds to the day's activity timeline.
abstract class HealthActivity
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  HealthActivity._({
    this.id,
    required this.userId,
    required this.logDate,
    required this.atTime,
    required this.title,
    this.detail,
    String? kind,
    DateTime? createdAt,
  }) : kind = kind ?? 'note',
       createdAt = createdAt ?? DateTime.now();

  factory HealthActivity({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime logDate,
    required String atTime,
    required String title,
    String? detail,
    String? kind,
    DateTime? createdAt,
  }) = _HealthActivityImpl;

  factory HealthActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthActivity(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      logDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['logDate']),
      atTime: jsonSerialization['atTime'] as String,
      title: jsonSerialization['title'] as String,
      detail: jsonSerialization['detail'] as String?,
      kind: jsonSerialization['kind'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = HealthActivityTable();

  static const db = HealthActivityRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  DateTime logDate;

  String atTime;

  String title;

  String? detail;

  /// `note` (tự thêm) — chỗ để mở rộng loại mốc khác sau này.
  String kind;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [HealthActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthActivity copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    DateTime? logDate,
    String? atTime,
    String? title,
    String? detail,
    String? kind,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthActivity',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'atTime': atTime,
      'title': title,
      if (detail != null) 'detail': detail,
      'kind': kind,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthActivity',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'atTime': atTime,
      'title': title,
      if (detail != null) 'detail': detail,
      'kind': kind,
      'createdAt': createdAt.toJson(),
    };
  }

  static HealthActivityInclude include() {
    return HealthActivityInclude._();
  }

  static HealthActivityIncludeList includeList({
    _is.WhereExpressionBuilder<HealthActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthActivityTable>? orderBy,
    _is.OrderByListBuilder<HealthActivityTable>? orderByList,
    HealthActivityInclude? include,
  }) {
    return HealthActivityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthActivity.t),
      orderByList: orderByList?.call(HealthActivity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthActivityImpl extends HealthActivity {
  _HealthActivityImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime logDate,
    required String atTime,
    required String title,
    String? detail,
    String? kind,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         logDate: logDate,
         atTime: atTime,
         title: title,
         detail: detail,
         kind: kind,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthActivity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthActivity copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? logDate,
    String? atTime,
    String? title,
    Object? detail = _Undefined,
    String? kind,
    DateTime? createdAt,
  }) {
    return HealthActivity(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      atTime: atTime ?? this.atTime,
      title: title ?? this.title,
      detail: detail is String? ? detail : this.detail,
      kind: kind ?? this.kind,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HealthActivityUpdateTable extends _is.UpdateTable<HealthActivityTable> {
  HealthActivityUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> logDate(DateTime value) =>
      _is.ColumnValue(
        table.logDate,
        value,
      );

  _is.ColumnValue<String, String> atTime(String value) => _is.ColumnValue(
    table.atTime,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> detail(String? value) => _is.ColumnValue(
    table.detail,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class HealthActivityTable extends _is.Table<_is.UuidValue?> {
  HealthActivityTable({super.tableRelation})
    : super(tableName: 'health_activities') {
    updateTable = HealthActivityUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    logDate = _is.ColumnDateTime(
      'logDate',
      this,
    );
    atTime = _is.ColumnString(
      'atTime',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    detail = _is.ColumnString(
      'detail',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final HealthActivityUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnDateTime logDate;

  late final _is.ColumnString atTime;

  late final _is.ColumnString title;

  late final _is.ColumnString detail;

  /// `note` (tự thêm) — chỗ để mở rộng loại mốc khác sau này.
  late final _is.ColumnString kind;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    logDate,
    atTime,
    title,
    detail,
    kind,
    createdAt,
  ];
}

class HealthActivityInclude extends _is.IncludeObject {
  HealthActivityInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthActivity.t;
}

class HealthActivityIncludeList extends _is.IncludeList {
  HealthActivityIncludeList._({
    _is.WhereExpressionBuilder<HealthActivityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HealthActivity.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthActivity.t;
}

class HealthActivityRepository {
  const HealthActivityRepository._();

  /// Returns a list of [HealthActivity]s matching the given query parameters.
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
  Future<List<HealthActivity>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthActivityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthActivityTable>? orderBy,
    _is.OrderByListBuilder<HealthActivityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HealthActivity>(
      where: where?.call(HealthActivity.t),
      orderBy: orderBy?.call(HealthActivity.t),
      orderByList: orderByList?.call(HealthActivity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HealthActivity] matching the given query parameters.
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
  Future<HealthActivity?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthActivityTable>? where,
    int? offset,
    _is.OrderByBuilder<HealthActivityTable>? orderBy,
    _is.OrderByListBuilder<HealthActivityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HealthActivity>(
      where: where?.call(HealthActivity.t),
      orderBy: orderBy?.call(HealthActivity.t),
      orderByList: orderByList?.call(HealthActivity.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HealthActivity] by its [id] or null if no such row exists.
  Future<HealthActivity?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HealthActivity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HealthActivity]s in the list and returns the inserted rows.
  ///
  /// The returned [HealthActivity]s will have their `id` fields set.
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
  Future<List<HealthActivity>> insert(
    _is.DatabaseSession session,
    List<HealthActivity> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<HealthActivity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [HealthActivity] and returns the inserted row.
  ///
  /// The returned [HealthActivity] will have its `id` field set.
  Future<HealthActivity> insertRow(
    _is.DatabaseSession session,
    HealthActivity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<HealthActivity>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [HealthActivity]s in the list and returns the resulting rows.
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
  /// The returned [HealthActivity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthActivity>> upsert(
    _is.DatabaseSession session,
    List<HealthActivity> rows, {
    required _is.ColumnSelections<HealthActivityTable> conflictColumns,
    _is.ColumnSelections<HealthActivityTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthActivityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<HealthActivity>(
      rows,
      conflictColumns: conflictColumns(HealthActivity.t),
      updateColumns: updateColumns?.call(HealthActivity.t),
      updateWhere: updateWhere?.call(HealthActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [HealthActivity] and returns the resulting row.
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
  /// The returned [HealthActivity] will have its `id` field set.
  Future<HealthActivity?> upsertRow(
    _is.DatabaseSession session,
    HealthActivity row, {
    required _is.ColumnSelections<HealthActivityTable> conflictColumns,
    _is.ColumnSelections<HealthActivityTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthActivityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<HealthActivity>(
      row,
      conflictColumns: conflictColumns(HealthActivity.t),
      updateColumns: updateColumns?.call(HealthActivity.t),
      updateWhere: updateWhere?.call(HealthActivity.t),
      transaction: transaction,
    );
  }

  /// Updates all [HealthActivity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthActivity>> update(
    _is.DatabaseSession session,
    List<HealthActivity> rows, {
    _is.ColumnSelections<HealthActivityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<HealthActivity>(
      rows,
      columns: columns?.call(HealthActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [HealthActivity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HealthActivity> updateRow(
    _is.DatabaseSession session,
    HealthActivity row, {
    _is.ColumnSelections<HealthActivityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<HealthActivity>(
      row,
      columns: columns?.call(HealthActivity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthActivity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HealthActivity?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<HealthActivityUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<HealthActivity>(
      id,
      columnValues: columnValues(HealthActivity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HealthActivity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthActivity>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<HealthActivityUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<HealthActivityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthActivityTable>? orderBy,
    _is.OrderByListBuilder<HealthActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<HealthActivity>(
      columnValues: columnValues(HealthActivity.t.updateTable),
      where: where(HealthActivity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthActivity.t),
      orderByList: orderByList?.call(HealthActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [HealthActivity]s in the list and returns the deleted rows.
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
  Future<List<HealthActivity>> delete(
    _is.DatabaseSession session,
    List<HealthActivity> rows, {
    _is.OrderByBuilder<HealthActivityTable>? orderBy,
    _is.OrderByListBuilder<HealthActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<HealthActivity>(
      rows,
      orderBy: orderBy?.call(HealthActivity.t),
      orderByList: orderByList?.call(HealthActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [HealthActivity].
  Future<HealthActivity> deleteRow(
    _is.DatabaseSession session,
    HealthActivity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HealthActivity>(
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
  Future<List<HealthActivity>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthActivityTable> where,
    _is.OrderByBuilder<HealthActivityTable>? orderBy,
    _is.OrderByListBuilder<HealthActivityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<HealthActivity>(
      where: where(HealthActivity.t),
      orderBy: orderBy?.call(HealthActivity.t),
      orderByList: orderByList?.call(HealthActivity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthActivityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<HealthActivity>(
      where: where?.call(HealthActivity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HealthActivity] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthActivityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HealthActivity>(
      where: where(HealthActivity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
