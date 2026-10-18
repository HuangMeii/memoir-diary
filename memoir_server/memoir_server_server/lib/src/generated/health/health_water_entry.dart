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

/// One logged drink. `health_logs.water_ml` is the derived daily total.
abstract class HealthWaterEntry
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  HealthWaterEntry._({
    this.id,
    required this.userId,
    required this.logDate,
    required this.amountMl,
    DateTime? recordedAt,
    this.note,
    DateTime? createdAt,
  }) : recordedAt = recordedAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory HealthWaterEntry({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime logDate,
    required int amountMl,
    DateTime? recordedAt,
    String? note,
    DateTime? createdAt,
  }) = _HealthWaterEntryImpl;

  factory HealthWaterEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthWaterEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      logDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['logDate']),
      amountMl: jsonSerialization['amountMl'] as int,
      recordedAt: jsonSerialization['recordedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['recordedAt']),
      note: jsonSerialization['note'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = HealthWaterEntryTable();

  static const db = HealthWaterEntryRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  DateTime logDate;

  int amountMl;

  DateTime recordedAt;

  String? note;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [HealthWaterEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthWaterEntry copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    DateTime? logDate,
    int? amountMl,
    DateTime? recordedAt,
    String? note,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthWaterEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'amountMl': amountMl,
      'recordedAt': recordedAt.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthWaterEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      'amountMl': amountMl,
      'recordedAt': recordedAt.toJson(),
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
    };
  }

  static HealthWaterEntryInclude include() {
    return HealthWaterEntryInclude._();
  }

  static HealthWaterEntryIncludeList includeList({
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthWaterEntryTable>? orderBy,
    _is.OrderByListBuilder<HealthWaterEntryTable>? orderByList,
    HealthWaterEntryInclude? include,
  }) {
    return HealthWaterEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthWaterEntry.t),
      orderByList: orderByList?.call(HealthWaterEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthWaterEntryImpl extends HealthWaterEntry {
  _HealthWaterEntryImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime logDate,
    required int amountMl,
    DateTime? recordedAt,
    String? note,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         logDate: logDate,
         amountMl: amountMl,
         recordedAt: recordedAt,
         note: note,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthWaterEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthWaterEntry copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? logDate,
    int? amountMl,
    DateTime? recordedAt,
    Object? note = _Undefined,
    DateTime? createdAt,
  }) {
    return HealthWaterEntry(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      amountMl: amountMl ?? this.amountMl,
      recordedAt: recordedAt ?? this.recordedAt,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HealthWaterEntryUpdateTable
    extends _is.UpdateTable<HealthWaterEntryTable> {
  HealthWaterEntryUpdateTable(super.table);

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

  _is.ColumnValue<int, int> amountMl(int value) => _is.ColumnValue(
    table.amountMl,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> recordedAt(DateTime value) =>
      _is.ColumnValue(
        table.recordedAt,
        value,
      );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class HealthWaterEntryTable extends _is.Table<_is.UuidValue?> {
  HealthWaterEntryTable({super.tableRelation})
    : super(tableName: 'health_water_entries') {
    updateTable = HealthWaterEntryUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    logDate = _is.ColumnDateTime(
      'logDate',
      this,
    );
    amountMl = _is.ColumnInt(
      'amountMl',
      this,
    );
    recordedAt = _is.ColumnDateTime(
      'recordedAt',
      this,
      hasDefault: true,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final HealthWaterEntryUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnDateTime logDate;

  late final _is.ColumnInt amountMl;

  late final _is.ColumnDateTime recordedAt;

  late final _is.ColumnString note;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    logDate,
    amountMl,
    recordedAt,
    note,
    createdAt,
  ];
}

class HealthWaterEntryInclude extends _is.IncludeObject {
  HealthWaterEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthWaterEntry.t;
}

class HealthWaterEntryIncludeList extends _is.IncludeList {
  HealthWaterEntryIncludeList._({
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HealthWaterEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthWaterEntry.t;
}

class HealthWaterEntryRepository {
  const HealthWaterEntryRepository._();

  /// Returns a list of [HealthWaterEntry]s matching the given query parameters.
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
  Future<List<HealthWaterEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthWaterEntryTable>? orderBy,
    _is.OrderByListBuilder<HealthWaterEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HealthWaterEntry>(
      where: where?.call(HealthWaterEntry.t),
      orderBy: orderBy?.call(HealthWaterEntry.t),
      orderByList: orderByList?.call(HealthWaterEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HealthWaterEntry] matching the given query parameters.
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
  Future<HealthWaterEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<HealthWaterEntryTable>? orderBy,
    _is.OrderByListBuilder<HealthWaterEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HealthWaterEntry>(
      where: where?.call(HealthWaterEntry.t),
      orderBy: orderBy?.call(HealthWaterEntry.t),
      orderByList: orderByList?.call(HealthWaterEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HealthWaterEntry] by its [id] or null if no such row exists.
  Future<HealthWaterEntry?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HealthWaterEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HealthWaterEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [HealthWaterEntry]s will have their `id` fields set.
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
  Future<List<HealthWaterEntry>> insert(
    _is.DatabaseSession session,
    List<HealthWaterEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<HealthWaterEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [HealthWaterEntry] and returns the inserted row.
  ///
  /// The returned [HealthWaterEntry] will have its `id` field set.
  Future<HealthWaterEntry> insertRow(
    _is.DatabaseSession session,
    HealthWaterEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<HealthWaterEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [HealthWaterEntry]s in the list and returns the resulting rows.
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
  /// The returned [HealthWaterEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthWaterEntry>> upsert(
    _is.DatabaseSession session,
    List<HealthWaterEntry> rows, {
    required _is.ColumnSelections<HealthWaterEntryTable> conflictColumns,
    _is.ColumnSelections<HealthWaterEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<HealthWaterEntry>(
      rows,
      conflictColumns: conflictColumns(HealthWaterEntry.t),
      updateColumns: updateColumns?.call(HealthWaterEntry.t),
      updateWhere: updateWhere?.call(HealthWaterEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [HealthWaterEntry] and returns the resulting row.
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
  /// The returned [HealthWaterEntry] will have its `id` field set.
  Future<HealthWaterEntry?> upsertRow(
    _is.DatabaseSession session,
    HealthWaterEntry row, {
    required _is.ColumnSelections<HealthWaterEntryTable> conflictColumns,
    _is.ColumnSelections<HealthWaterEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<HealthWaterEntry>(
      row,
      conflictColumns: conflictColumns(HealthWaterEntry.t),
      updateColumns: updateColumns?.call(HealthWaterEntry.t),
      updateWhere: updateWhere?.call(HealthWaterEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [HealthWaterEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthWaterEntry>> update(
    _is.DatabaseSession session,
    List<HealthWaterEntry> rows, {
    _is.ColumnSelections<HealthWaterEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<HealthWaterEntry>(
      rows,
      columns: columns?.call(HealthWaterEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [HealthWaterEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HealthWaterEntry> updateRow(
    _is.DatabaseSession session,
    HealthWaterEntry row, {
    _is.ColumnSelections<HealthWaterEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<HealthWaterEntry>(
      row,
      columns: columns?.call(HealthWaterEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthWaterEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HealthWaterEntry?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<HealthWaterEntryUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<HealthWaterEntry>(
      id,
      columnValues: columnValues(HealthWaterEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HealthWaterEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthWaterEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<HealthWaterEntryUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<HealthWaterEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthWaterEntryTable>? orderBy,
    _is.OrderByListBuilder<HealthWaterEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<HealthWaterEntry>(
      columnValues: columnValues(HealthWaterEntry.t.updateTable),
      where: where(HealthWaterEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthWaterEntry.t),
      orderByList: orderByList?.call(HealthWaterEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [HealthWaterEntry]s in the list and returns the deleted rows.
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
  Future<List<HealthWaterEntry>> delete(
    _is.DatabaseSession session,
    List<HealthWaterEntry> rows, {
    _is.OrderByBuilder<HealthWaterEntryTable>? orderBy,
    _is.OrderByListBuilder<HealthWaterEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<HealthWaterEntry>(
      rows,
      orderBy: orderBy?.call(HealthWaterEntry.t),
      orderByList: orderByList?.call(HealthWaterEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [HealthWaterEntry].
  Future<HealthWaterEntry> deleteRow(
    _is.DatabaseSession session,
    HealthWaterEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HealthWaterEntry>(
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
  Future<List<HealthWaterEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthWaterEntryTable> where,
    _is.OrderByBuilder<HealthWaterEntryTable>? orderBy,
    _is.OrderByListBuilder<HealthWaterEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<HealthWaterEntry>(
      where: where(HealthWaterEntry.t),
      orderBy: orderBy?.call(HealthWaterEntry.t),
      orderByList: orderByList?.call(HealthWaterEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthWaterEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<HealthWaterEntry>(
      where: where?.call(HealthWaterEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HealthWaterEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthWaterEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HealthWaterEntry>(
      where: where(HealthWaterEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
