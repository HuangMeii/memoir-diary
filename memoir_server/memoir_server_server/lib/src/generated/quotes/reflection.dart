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

/// User's thoughts about the daily quote + self message pair.
abstract class Reflection
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Reflection._({
    this.id,
    required this.userId,
    this.entryId,
    this.quoteId,
    this.selfMessageId,
    this.thought,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Reflection({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    _is.UuidValue? entryId,
    _is.UuidValue? quoteId,
    _is.UuidValue? selfMessageId,
    String? thought,
    DateTime? createdAt,
  }) = _ReflectionImpl;

  factory Reflection.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reflection(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryId: jsonSerialization['entryId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['entryId']),
      quoteId: jsonSerialization['quoteId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['quoteId']),
      selfMessageId: jsonSerialization['selfMessageId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['selfMessageId'],
            ),
      thought: jsonSerialization['thought'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ReflectionTable();

  static const db = ReflectionRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  _is.UuidValue? entryId;

  _is.UuidValue? quoteId;

  _is.UuidValue? selfMessageId;

  String? thought;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Reflection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Reflection copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    _is.UuidValue? entryId,
    _is.UuidValue? quoteId,
    _is.UuidValue? selfMessageId,
    String? thought,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Reflection',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      if (thought != null) 'thought': thought,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Reflection',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (quoteId != null) 'quoteId': quoteId?.toJson(),
      if (selfMessageId != null) 'selfMessageId': selfMessageId?.toJson(),
      if (thought != null) 'thought': thought,
      'createdAt': createdAt.toJson(),
    };
  }

  static ReflectionInclude include() {
    return ReflectionInclude._();
  }

  static ReflectionIncludeList includeList({
    _is.WhereExpressionBuilder<ReflectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReflectionTable>? orderBy,
    _is.OrderByListBuilder<ReflectionTable>? orderByList,
    ReflectionInclude? include,
  }) {
    return ReflectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reflection.t),
      orderByList: orderByList?.call(Reflection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReflectionImpl extends Reflection {
  _ReflectionImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    _is.UuidValue? entryId,
    _is.UuidValue? quoteId,
    _is.UuidValue? selfMessageId,
    String? thought,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         entryId: entryId,
         quoteId: quoteId,
         selfMessageId: selfMessageId,
         thought: thought,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Reflection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Reflection copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    Object? entryId = _Undefined,
    Object? quoteId = _Undefined,
    Object? selfMessageId = _Undefined,
    Object? thought = _Undefined,
    DateTime? createdAt,
  }) {
    return Reflection(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      entryId: entryId is _is.UuidValue? ? entryId : this.entryId,
      quoteId: quoteId is _is.UuidValue? ? quoteId : this.quoteId,
      selfMessageId: selfMessageId is _is.UuidValue?
          ? selfMessageId
          : this.selfMessageId,
      thought: thought is String? ? thought : this.thought,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReflectionUpdateTable extends _is.UpdateTable<ReflectionTable> {
  ReflectionUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> entryId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.entryId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> quoteId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.quoteId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> selfMessageId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.selfMessageId,
    value,
  );

  _is.ColumnValue<String, String> thought(String? value) => _is.ColumnValue(
    table.thought,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReflectionTable extends _is.Table<_is.UuidValue?> {
  ReflectionTable({super.tableRelation}) : super(tableName: 'reflections') {
    updateTable = ReflectionUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    entryId = _is.ColumnUuid(
      'entryId',
      this,
    );
    quoteId = _is.ColumnUuid(
      'quoteId',
      this,
    );
    selfMessageId = _is.ColumnUuid(
      'selfMessageId',
      this,
    );
    thought = _is.ColumnString(
      'thought',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ReflectionUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnUuid entryId;

  late final _is.ColumnUuid quoteId;

  late final _is.ColumnUuid selfMessageId;

  late final _is.ColumnString thought;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    entryId,
    quoteId,
    selfMessageId,
    thought,
    createdAt,
  ];
}

class ReflectionInclude extends _is.IncludeObject {
  ReflectionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Reflection.t;
}

class ReflectionIncludeList extends _is.IncludeList {
  ReflectionIncludeList._({
    _is.WhereExpressionBuilder<ReflectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Reflection.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Reflection.t;
}

class ReflectionRepository {
  const ReflectionRepository._();

  /// Returns a list of [Reflection]s matching the given query parameters.
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
  Future<List<Reflection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReflectionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReflectionTable>? orderBy,
    _is.OrderByListBuilder<ReflectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Reflection>(
      where: where?.call(Reflection.t),
      orderBy: orderBy?.call(Reflection.t),
      orderByList: orderByList?.call(Reflection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Reflection] matching the given query parameters.
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
  Future<Reflection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReflectionTable>? where,
    int? offset,
    _is.OrderByBuilder<ReflectionTable>? orderBy,
    _is.OrderByListBuilder<ReflectionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Reflection>(
      where: where?.call(Reflection.t),
      orderBy: orderBy?.call(Reflection.t),
      orderByList: orderByList?.call(Reflection.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Reflection] by its [id] or null if no such row exists.
  Future<Reflection?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Reflection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Reflection]s in the list and returns the inserted rows.
  ///
  /// The returned [Reflection]s will have their `id` fields set.
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
  Future<List<Reflection>> insert(
    _is.DatabaseSession session,
    List<Reflection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Reflection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Reflection] and returns the inserted row.
  ///
  /// The returned [Reflection] will have its `id` field set.
  Future<Reflection> insertRow(
    _is.DatabaseSession session,
    Reflection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Reflection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Reflection]s in the list and returns the resulting rows.
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
  /// The returned [Reflection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reflection>> upsert(
    _is.DatabaseSession session,
    List<Reflection> rows, {
    required _is.ColumnSelections<ReflectionTable> conflictColumns,
    _is.ColumnSelections<ReflectionTable>? updateColumns,
    _is.WhereExpressionBuilder<ReflectionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Reflection>(
      rows,
      conflictColumns: conflictColumns(Reflection.t),
      updateColumns: updateColumns?.call(Reflection.t),
      updateWhere: updateWhere?.call(Reflection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Reflection] and returns the resulting row.
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
  /// The returned [Reflection] will have its `id` field set.
  Future<Reflection?> upsertRow(
    _is.DatabaseSession session,
    Reflection row, {
    required _is.ColumnSelections<ReflectionTable> conflictColumns,
    _is.ColumnSelections<ReflectionTable>? updateColumns,
    _is.WhereExpressionBuilder<ReflectionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Reflection>(
      row,
      conflictColumns: conflictColumns(Reflection.t),
      updateColumns: updateColumns?.call(Reflection.t),
      updateWhere: updateWhere?.call(Reflection.t),
      transaction: transaction,
    );
  }

  /// Updates all [Reflection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reflection>> update(
    _is.DatabaseSession session,
    List<Reflection> rows, {
    _is.ColumnSelections<ReflectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Reflection>(
      rows,
      columns: columns?.call(Reflection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Reflection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Reflection> updateRow(
    _is.DatabaseSession session,
    Reflection row, {
    _is.ColumnSelections<ReflectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Reflection>(
      row,
      columns: columns?.call(Reflection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Reflection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Reflection?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ReflectionUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Reflection>(
      id,
      columnValues: columnValues(Reflection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Reflection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Reflection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReflectionUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ReflectionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReflectionTable>? orderBy,
    _is.OrderByListBuilder<ReflectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Reflection>(
      columnValues: columnValues(Reflection.t.updateTable),
      where: where(Reflection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Reflection.t),
      orderByList: orderByList?.call(Reflection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Reflection]s in the list and returns the deleted rows.
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
  Future<List<Reflection>> delete(
    _is.DatabaseSession session,
    List<Reflection> rows, {
    _is.OrderByBuilder<ReflectionTable>? orderBy,
    _is.OrderByListBuilder<ReflectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Reflection>(
      rows,
      orderBy: orderBy?.call(Reflection.t),
      orderByList: orderByList?.call(Reflection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Reflection].
  Future<Reflection> deleteRow(
    _is.DatabaseSession session,
    Reflection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Reflection>(
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
  Future<List<Reflection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReflectionTable> where,
    _is.OrderByBuilder<ReflectionTable>? orderBy,
    _is.OrderByListBuilder<ReflectionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Reflection>(
      where: where(Reflection.t),
      orderBy: orderBy?.call(Reflection.t),
      orderByList: orderByList?.call(Reflection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReflectionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Reflection>(
      where: where?.call(Reflection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Reflection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReflectionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Reflection>(
      where: where(Reflection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
