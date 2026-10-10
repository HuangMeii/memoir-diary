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

/// The quote pair shown on a given day. One row per user per day.
abstract class DailyQuote
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  DailyQuote._({
    this.id,
    required this.userId,
    required this.quoteDate,
    this.quoteId,
    this.quoteId2,
    this.selfMessageId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory DailyQuote({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime quoteDate,
    _is.UuidValue? quoteId,
    _is.UuidValue? quoteId2,
    _is.UuidValue? selfMessageId,
    DateTime? createdAt,
  }) = _DailyQuoteImpl;

  factory DailyQuote.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyQuote(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      quoteDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['quoteDate'],
      ),
      quoteId: jsonSerialization['quoteId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['quoteId']),
      quoteId2: jsonSerialization['quoteId2'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['quoteId2']),
      selfMessageId: jsonSerialization['selfMessageId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['selfMessageId'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = DailyQuoteTable();

  static const db = DailyQuoteRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  DateTime quoteDate;

  _is.UuidValue? quoteId;

  /// Second library quote; set when the user has too few self messages.
  _is.UuidValue? quoteId2;

  _is.UuidValue? selfMessageId;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DailyQuote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DailyQuote copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    DateTime? quoteDate,
    _is.UuidValue? quoteId,
    _is.UuidValue? quoteId2,
    _is.UuidValue? selfMessageId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyQuote',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'quoteDate': quoteDate.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (quoteId2 != null) 'quoteId2': quoteId2?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyQuote',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'quoteDate': quoteDate.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (quoteId2 != null) 'quoteId2': quoteId2?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static DailyQuoteInclude include() {
    return DailyQuoteInclude._();
  }

  static DailyQuoteIncludeList includeList({
    _is.WhereExpressionBuilder<DailyQuoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DailyQuoteTable>? orderBy,
    _is.OrderByListBuilder<DailyQuoteTable>? orderByList,
    DailyQuoteInclude? include,
  }) {
    return DailyQuoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyQuote.t),
      orderByList: orderByList?.call(DailyQuote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyQuoteImpl extends DailyQuote {
  _DailyQuoteImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime quoteDate,
    _is.UuidValue? quoteId,
    _is.UuidValue? quoteId2,
    _is.UuidValue? selfMessageId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         quoteDate: quoteDate,
         quoteId: quoteId,
         quoteId2: quoteId2,
         selfMessageId: selfMessageId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DailyQuote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DailyQuote copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? quoteDate,
    Object? quoteId = _Undefined,
    Object? quoteId2 = _Undefined,
    Object? selfMessageId = _Undefined,
    DateTime? createdAt,
  }) {
    return DailyQuote(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      quoteDate: quoteDate ?? this.quoteDate,
      quoteId: quoteId is _is.UuidValue? ? quoteId : this.quoteId,
      quoteId2: quoteId2 is _is.UuidValue? ? quoteId2 : this.quoteId2,
      selfMessageId: selfMessageId is _is.UuidValue?
          ? selfMessageId
          : this.selfMessageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DailyQuoteUpdateTable extends _is.UpdateTable<DailyQuoteTable> {
  DailyQuoteUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> quoteDate(DateTime value) =>
      _is.ColumnValue(
        table.quoteDate,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> quoteId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.quoteId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> quoteId2(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.quoteId2,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> selfMessageId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.selfMessageId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class DailyQuoteTable extends _is.Table<_is.UuidValue?> {
  DailyQuoteTable({super.tableRelation}) : super(tableName: 'daily_quotes') {
    updateTable = DailyQuoteUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    quoteDate = _is.ColumnDateTime(
      'quoteDate',
      this,
    );
    quoteId = _is.ColumnUuid(
      'quoteId',
      this,
    );
    quoteId2 = _is.ColumnUuid(
      'quoteId2',
      this,
    );
    selfMessageId = _is.ColumnUuid(
      'selfMessageId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final DailyQuoteUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnDateTime quoteDate;

  late final _is.ColumnUuid quoteId;

  /// Second library quote; set when the user has too few self messages.
  late final _is.ColumnUuid quoteId2;

  late final _is.ColumnUuid selfMessageId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    quoteDate,
    quoteId,
    quoteId2,
    selfMessageId,
    createdAt,
  ];
}

class DailyQuoteInclude extends _is.IncludeObject {
  DailyQuoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => DailyQuote.t;
}

class DailyQuoteIncludeList extends _is.IncludeList {
  DailyQuoteIncludeList._({
    _is.WhereExpressionBuilder<DailyQuoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DailyQuote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => DailyQuote.t;
}

class DailyQuoteRepository {
  const DailyQuoteRepository._();

  /// Returns a list of [DailyQuote]s matching the given query parameters.
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
  Future<List<DailyQuote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DailyQuoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DailyQuoteTable>? orderBy,
    _is.OrderByListBuilder<DailyQuoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DailyQuote>(
      where: where?.call(DailyQuote.t),
      orderBy: orderBy?.call(DailyQuote.t),
      orderByList: orderByList?.call(DailyQuote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DailyQuote] matching the given query parameters.
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
  Future<DailyQuote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DailyQuoteTable>? where,
    int? offset,
    _is.OrderByBuilder<DailyQuoteTable>? orderBy,
    _is.OrderByListBuilder<DailyQuoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DailyQuote>(
      where: where?.call(DailyQuote.t),
      orderBy: orderBy?.call(DailyQuote.t),
      orderByList: orderByList?.call(DailyQuote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DailyQuote] by its [id] or null if no such row exists.
  Future<DailyQuote?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DailyQuote>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DailyQuote]s in the list and returns the inserted rows.
  ///
  /// The returned [DailyQuote]s will have their `id` fields set.
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
  Future<List<DailyQuote>> insert(
    _is.DatabaseSession session,
    List<DailyQuote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DailyQuote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DailyQuote] and returns the inserted row.
  ///
  /// The returned [DailyQuote] will have its `id` field set.
  Future<DailyQuote> insertRow(
    _is.DatabaseSession session,
    DailyQuote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DailyQuote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DailyQuote]s in the list and returns the resulting rows.
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
  /// The returned [DailyQuote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DailyQuote>> upsert(
    _is.DatabaseSession session,
    List<DailyQuote> rows, {
    required _is.ColumnSelections<DailyQuoteTable> conflictColumns,
    _is.ColumnSelections<DailyQuoteTable>? updateColumns,
    _is.WhereExpressionBuilder<DailyQuoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DailyQuote>(
      rows,
      conflictColumns: conflictColumns(DailyQuote.t),
      updateColumns: updateColumns?.call(DailyQuote.t),
      updateWhere: updateWhere?.call(DailyQuote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DailyQuote] and returns the resulting row.
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
  /// The returned [DailyQuote] will have its `id` field set.
  Future<DailyQuote?> upsertRow(
    _is.DatabaseSession session,
    DailyQuote row, {
    required _is.ColumnSelections<DailyQuoteTable> conflictColumns,
    _is.ColumnSelections<DailyQuoteTable>? updateColumns,
    _is.WhereExpressionBuilder<DailyQuoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DailyQuote>(
      row,
      conflictColumns: conflictColumns(DailyQuote.t),
      updateColumns: updateColumns?.call(DailyQuote.t),
      updateWhere: updateWhere?.call(DailyQuote.t),
      transaction: transaction,
    );
  }

  /// Updates all [DailyQuote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DailyQuote>> update(
    _is.DatabaseSession session,
    List<DailyQuote> rows, {
    _is.ColumnSelections<DailyQuoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DailyQuote>(
      rows,
      columns: columns?.call(DailyQuote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DailyQuote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DailyQuote> updateRow(
    _is.DatabaseSession session,
    DailyQuote row, {
    _is.ColumnSelections<DailyQuoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DailyQuote>(
      row,
      columns: columns?.call(DailyQuote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DailyQuote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DailyQuote?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<DailyQuoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DailyQuote>(
      id,
      columnValues: columnValues(DailyQuote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DailyQuote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DailyQuote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DailyQuoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DailyQuoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DailyQuoteTable>? orderBy,
    _is.OrderByListBuilder<DailyQuoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DailyQuote>(
      columnValues: columnValues(DailyQuote.t.updateTable),
      where: where(DailyQuote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DailyQuote.t),
      orderByList: orderByList?.call(DailyQuote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DailyQuote]s in the list and returns the deleted rows.
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
  Future<List<DailyQuote>> delete(
    _is.DatabaseSession session,
    List<DailyQuote> rows, {
    _is.OrderByBuilder<DailyQuoteTable>? orderBy,
    _is.OrderByListBuilder<DailyQuoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DailyQuote>(
      rows,
      orderBy: orderBy?.call(DailyQuote.t),
      orderByList: orderByList?.call(DailyQuote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DailyQuote].
  Future<DailyQuote> deleteRow(
    _is.DatabaseSession session,
    DailyQuote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DailyQuote>(
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
  Future<List<DailyQuote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DailyQuoteTable> where,
    _is.OrderByBuilder<DailyQuoteTable>? orderBy,
    _is.OrderByListBuilder<DailyQuoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DailyQuote>(
      where: where(DailyQuote.t),
      orderBy: orderBy?.call(DailyQuote.t),
      orderByList: orderByList?.call(DailyQuote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DailyQuoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DailyQuote>(
      where: where?.call(DailyQuote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DailyQuote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DailyQuoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DailyQuote>(
      where: where(DailyQuote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
