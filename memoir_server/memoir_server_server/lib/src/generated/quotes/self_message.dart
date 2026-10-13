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

/// The user's own message to self.
abstract class SelfMessage
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  SelfMessage._({
    this.id,
    required this.userId,
    this.entryId,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SelfMessage({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    _is.UuidValue? entryId,
    required String content,
    DateTime? createdAt,
  }) = _SelfMessageImpl;

  factory SelfMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SelfMessage(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryId: jsonSerialization['entryId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['entryId']),
      content: jsonSerialization['content'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = SelfMessageTable();

  static const db = SelfMessageRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  _is.UuidValue? entryId;

  String content;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SelfMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SelfMessage copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    _is.UuidValue? entryId,
    String? content,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SelfMessage',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SelfMessage',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (entryId != null) 'entryId': entryId?.toJson(),
      'content': content,
      'createdAt': createdAt.toJson(),
    };
  }

  static SelfMessageInclude include() {
    return SelfMessageInclude._();
  }

  static SelfMessageIncludeList includeList({
    _is.WhereExpressionBuilder<SelfMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SelfMessageTable>? orderBy,
    _is.OrderByListBuilder<SelfMessageTable>? orderByList,
    SelfMessageInclude? include,
  }) {
    return SelfMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SelfMessage.t),
      orderByList: orderByList?.call(SelfMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SelfMessageImpl extends SelfMessage {
  _SelfMessageImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    _is.UuidValue? entryId,
    required String content,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         entryId: entryId,
         content: content,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SelfMessage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SelfMessage copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    Object? entryId = _Undefined,
    String? content,
    DateTime? createdAt,
  }) {
    return SelfMessage(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      entryId: entryId is _is.UuidValue? ? entryId : this.entryId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class SelfMessageUpdateTable extends _is.UpdateTable<SelfMessageTable> {
  SelfMessageUpdateTable(super.table);

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

  _is.ColumnValue<String, String> content(String value) => _is.ColumnValue(
    table.content,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class SelfMessageTable extends _is.Table<_is.UuidValue?> {
  SelfMessageTable({super.tableRelation}) : super(tableName: 'self_messages') {
    updateTable = SelfMessageUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    entryId = _is.ColumnUuid(
      'entryId',
      this,
    );
    content = _is.ColumnString(
      'content',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final SelfMessageUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnUuid entryId;

  late final _is.ColumnString content;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    entryId,
    content,
    createdAt,
  ];
}

class SelfMessageInclude extends _is.IncludeObject {
  SelfMessageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => SelfMessage.t;
}

class SelfMessageIncludeList extends _is.IncludeList {
  SelfMessageIncludeList._({
    _is.WhereExpressionBuilder<SelfMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SelfMessage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => SelfMessage.t;
}

class SelfMessageRepository {
  const SelfMessageRepository._();

  /// Returns a list of [SelfMessage]s matching the given query parameters.
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
  Future<List<SelfMessage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SelfMessageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SelfMessageTable>? orderBy,
    _is.OrderByListBuilder<SelfMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SelfMessage>(
      where: where?.call(SelfMessage.t),
      orderBy: orderBy?.call(SelfMessage.t),
      orderByList: orderByList?.call(SelfMessage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SelfMessage] matching the given query parameters.
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
  Future<SelfMessage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SelfMessageTable>? where,
    int? offset,
    _is.OrderByBuilder<SelfMessageTable>? orderBy,
    _is.OrderByListBuilder<SelfMessageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SelfMessage>(
      where: where?.call(SelfMessage.t),
      orderBy: orderBy?.call(SelfMessage.t),
      orderByList: orderByList?.call(SelfMessage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SelfMessage] by its [id] or null if no such row exists.
  Future<SelfMessage?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SelfMessage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SelfMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [SelfMessage]s will have their `id` fields set.
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
  Future<List<SelfMessage>> insert(
    _is.DatabaseSession session,
    List<SelfMessage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SelfMessage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SelfMessage] and returns the inserted row.
  ///
  /// The returned [SelfMessage] will have its `id` field set.
  Future<SelfMessage> insertRow(
    _is.DatabaseSession session,
    SelfMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SelfMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SelfMessage]s in the list and returns the resulting rows.
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
  /// The returned [SelfMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SelfMessage>> upsert(
    _is.DatabaseSession session,
    List<SelfMessage> rows, {
    required _is.ColumnSelections<SelfMessageTable> conflictColumns,
    _is.ColumnSelections<SelfMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<SelfMessageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SelfMessage>(
      rows,
      conflictColumns: conflictColumns(SelfMessage.t),
      updateColumns: updateColumns?.call(SelfMessage.t),
      updateWhere: updateWhere?.call(SelfMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SelfMessage] and returns the resulting row.
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
  /// The returned [SelfMessage] will have its `id` field set.
  Future<SelfMessage?> upsertRow(
    _is.DatabaseSession session,
    SelfMessage row, {
    required _is.ColumnSelections<SelfMessageTable> conflictColumns,
    _is.ColumnSelections<SelfMessageTable>? updateColumns,
    _is.WhereExpressionBuilder<SelfMessageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SelfMessage>(
      row,
      conflictColumns: conflictColumns(SelfMessage.t),
      updateColumns: updateColumns?.call(SelfMessage.t),
      updateWhere: updateWhere?.call(SelfMessage.t),
      transaction: transaction,
    );
  }

  /// Updates all [SelfMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SelfMessage>> update(
    _is.DatabaseSession session,
    List<SelfMessage> rows, {
    _is.ColumnSelections<SelfMessageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SelfMessage>(
      rows,
      columns: columns?.call(SelfMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SelfMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SelfMessage> updateRow(
    _is.DatabaseSession session,
    SelfMessage row, {
    _is.ColumnSelections<SelfMessageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SelfMessage>(
      row,
      columns: columns?.call(SelfMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SelfMessage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SelfMessage?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<SelfMessageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SelfMessage>(
      id,
      columnValues: columnValues(SelfMessage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SelfMessage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SelfMessage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SelfMessageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SelfMessageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SelfMessageTable>? orderBy,
    _is.OrderByListBuilder<SelfMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SelfMessage>(
      columnValues: columnValues(SelfMessage.t.updateTable),
      where: where(SelfMessage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SelfMessage.t),
      orderByList: orderByList?.call(SelfMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SelfMessage]s in the list and returns the deleted rows.
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
  Future<List<SelfMessage>> delete(
    _is.DatabaseSession session,
    List<SelfMessage> rows, {
    _is.OrderByBuilder<SelfMessageTable>? orderBy,
    _is.OrderByListBuilder<SelfMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SelfMessage>(
      rows,
      orderBy: orderBy?.call(SelfMessage.t),
      orderByList: orderByList?.call(SelfMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SelfMessage].
  Future<SelfMessage> deleteRow(
    _is.DatabaseSession session,
    SelfMessage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SelfMessage>(
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
  Future<List<SelfMessage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SelfMessageTable> where,
    _is.OrderByBuilder<SelfMessageTable>? orderBy,
    _is.OrderByListBuilder<SelfMessageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SelfMessage>(
      where: where(SelfMessage.t),
      orderBy: orderBy?.call(SelfMessage.t),
      orderByList: orderByList?.call(SelfMessage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SelfMessageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SelfMessage>(
      where: where?.call(SelfMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SelfMessage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SelfMessageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SelfMessage>(
      where: where(SelfMessage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
