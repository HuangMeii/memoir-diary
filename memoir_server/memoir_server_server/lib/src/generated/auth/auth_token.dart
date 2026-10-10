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

/// Opaque session token issued at login. Stored so logout can revoke it.
abstract class AuthToken
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  AuthToken._({
    this.id,
    required this.userId,
    required this.token,
    required this.expiresAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AuthToken({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required String token,
    required DateTime expiresAt,
    DateTime? createdAt,
  }) = _AuthTokenImpl;

  factory AuthToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthToken(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      token: jsonSerialization['token'] as String,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = AuthTokenTable();

  static const db = AuthTokenRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  String token;

  DateTime expiresAt;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AuthToken copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    String? token,
    DateTime? expiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthToken',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthToken',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static AuthTokenInclude include() {
    return AuthTokenInclude._();
  }

  static AuthTokenIncludeList includeList({
    _is.WhereExpressionBuilder<AuthTokenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthTokenTable>? orderBy,
    _is.OrderByListBuilder<AuthTokenTable>? orderByList,
    AuthTokenInclude? include,
  }) {
    return AuthTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthTokenImpl extends AuthToken {
  _AuthTokenImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required String token,
    required DateTime expiresAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         token: token,
         expiresAt: expiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuthToken]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AuthToken copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    String? token,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return AuthToken(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthTokenUpdateTable extends _is.UpdateTable<AuthTokenTable> {
  AuthTokenUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> token(String value) => _is.ColumnValue(
    table.token,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class AuthTokenTable extends _is.Table<_is.UuidValue?> {
  AuthTokenTable({super.tableRelation}) : super(tableName: 'auth_tokens') {
    updateTable = AuthTokenUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    token = _is.ColumnString(
      'token',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final AuthTokenUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnString token;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    token,
    expiresAt,
    createdAt,
  ];
}

class AuthTokenInclude extends _is.IncludeObject {
  AuthTokenInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => AuthToken.t;
}

class AuthTokenIncludeList extends _is.IncludeList {
  AuthTokenIncludeList._({
    _is.WhereExpressionBuilder<AuthTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AuthToken.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => AuthToken.t;
}

class AuthTokenRepository {
  const AuthTokenRepository._();

  /// Returns a list of [AuthToken]s matching the given query parameters.
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
  Future<List<AuthToken>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthTokenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthTokenTable>? orderBy,
    _is.OrderByListBuilder<AuthTokenTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AuthToken>(
      where: where?.call(AuthToken.t),
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AuthToken] matching the given query parameters.
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
  Future<AuthToken?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthTokenTable>? where,
    int? offset,
    _is.OrderByBuilder<AuthTokenTable>? orderBy,
    _is.OrderByListBuilder<AuthTokenTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AuthToken>(
      where: where?.call(AuthToken.t),
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AuthToken] by its [id] or null if no such row exists.
  Future<AuthToken?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AuthToken>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AuthToken]s in the list and returns the inserted rows.
  ///
  /// The returned [AuthToken]s will have their `id` fields set.
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
  Future<List<AuthToken>> insert(
    _is.DatabaseSession session,
    List<AuthToken> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AuthToken>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AuthToken] and returns the inserted row.
  ///
  /// The returned [AuthToken] will have its `id` field set.
  Future<AuthToken> insertRow(
    _is.DatabaseSession session,
    AuthToken row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AuthToken>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AuthToken]s in the list and returns the resulting rows.
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
  /// The returned [AuthToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthToken>> upsert(
    _is.DatabaseSession session,
    List<AuthToken> rows, {
    required _is.ColumnSelections<AuthTokenTable> conflictColumns,
    _is.ColumnSelections<AuthTokenTable>? updateColumns,
    _is.WhereExpressionBuilder<AuthTokenTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AuthToken>(
      rows,
      conflictColumns: conflictColumns(AuthToken.t),
      updateColumns: updateColumns?.call(AuthToken.t),
      updateWhere: updateWhere?.call(AuthToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AuthToken] and returns the resulting row.
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
  /// The returned [AuthToken] will have its `id` field set.
  Future<AuthToken?> upsertRow(
    _is.DatabaseSession session,
    AuthToken row, {
    required _is.ColumnSelections<AuthTokenTable> conflictColumns,
    _is.ColumnSelections<AuthTokenTable>? updateColumns,
    _is.WhereExpressionBuilder<AuthTokenTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AuthToken>(
      row,
      conflictColumns: conflictColumns(AuthToken.t),
      updateColumns: updateColumns?.call(AuthToken.t),
      updateWhere: updateWhere?.call(AuthToken.t),
      transaction: transaction,
    );
  }

  /// Updates all [AuthToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthToken>> update(
    _is.DatabaseSession session,
    List<AuthToken> rows, {
    _is.ColumnSelections<AuthTokenTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AuthToken>(
      rows,
      columns: columns?.call(AuthToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AuthToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AuthToken> updateRow(
    _is.DatabaseSession session,
    AuthToken row, {
    _is.ColumnSelections<AuthTokenTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AuthToken>(
      row,
      columns: columns?.call(AuthToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AuthToken] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AuthToken?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<AuthTokenUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AuthToken>(
      id,
      columnValues: columnValues(AuthToken.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AuthToken]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AuthToken>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AuthTokenUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AuthTokenTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AuthTokenTable>? orderBy,
    _is.OrderByListBuilder<AuthTokenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AuthToken>(
      columnValues: columnValues(AuthToken.t.updateTable),
      where: where(AuthToken.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AuthToken]s in the list and returns the deleted rows.
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
  Future<List<AuthToken>> delete(
    _is.DatabaseSession session,
    List<AuthToken> rows, {
    _is.OrderByBuilder<AuthTokenTable>? orderBy,
    _is.OrderByListBuilder<AuthTokenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AuthToken>(
      rows,
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AuthToken].
  Future<AuthToken> deleteRow(
    _is.DatabaseSession session,
    AuthToken row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AuthToken>(
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
  Future<List<AuthToken>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuthTokenTable> where,
    _is.OrderByBuilder<AuthTokenTable>? orderBy,
    _is.OrderByListBuilder<AuthTokenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AuthToken>(
      where: where(AuthToken.t),
      orderBy: orderBy?.call(AuthToken.t),
      orderByList: orderByList?.call(AuthToken.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AuthTokenTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AuthToken>(
      where: where?.call(AuthToken.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AuthToken] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AuthTokenTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AuthToken>(
      where: where(AuthToken.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
