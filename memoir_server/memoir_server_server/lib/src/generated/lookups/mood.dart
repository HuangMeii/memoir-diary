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

/// Mood lookup (5 rows, seeded).
abstract class Mood implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Mood._({
    this.id,
    required this.code,
    required this.labelVi,
    required this.colorHex,
    required this.icon,
    int? sortOrder,
  }) : sortOrder = sortOrder ?? 0;

  factory Mood({
    int? id,
    required String code,
    required String labelVi,
    required String colorHex,
    required String icon,
    int? sortOrder,
  }) = _MoodImpl;

  factory Mood.fromJson(Map<String, dynamic> jsonSerialization) {
    return Mood(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      labelVi: jsonSerialization['labelVi'] as String,
      colorHex: jsonSerialization['colorHex'] as String,
      icon: jsonSerialization['icon'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  static final t = MoodTable();

  static const db = MoodRepository._();

  @override
  int? id;

  String code;

  String labelVi;

  String colorHex;

  String icon;

  int sortOrder;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Mood]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Mood copyWith({
    int? id,
    String? code,
    String? labelVi,
    String? colorHex,
    String? icon,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Mood',
      if (id != null) 'id': id,
      'code': code,
      'labelVi': labelVi,
      'colorHex': colorHex,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Mood',
      if (id != null) 'id': id,
      'code': code,
      'labelVi': labelVi,
      'colorHex': colorHex,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }

  static MoodInclude include() {
    return MoodInclude._();
  }

  static MoodIncludeList includeList({
    _is.WhereExpressionBuilder<MoodTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MoodTable>? orderBy,
    _is.OrderByListBuilder<MoodTable>? orderByList,
    MoodInclude? include,
  }) {
    return MoodIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Mood.t),
      orderByList: orderByList?.call(Mood.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MoodImpl extends Mood {
  _MoodImpl({
    int? id,
    required String code,
    required String labelVi,
    required String colorHex,
    required String icon,
    int? sortOrder,
  }) : super._(
         id: id,
         code: code,
         labelVi: labelVi,
         colorHex: colorHex,
         icon: icon,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [Mood]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Mood copyWith({
    Object? id = _Undefined,
    String? code,
    String? labelVi,
    String? colorHex,
    String? icon,
    int? sortOrder,
  }) {
    return Mood(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      labelVi: labelVi ?? this.labelVi,
      colorHex: colorHex ?? this.colorHex,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class MoodUpdateTable extends _is.UpdateTable<MoodTable> {
  MoodUpdateTable(super.table);

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> labelVi(String value) => _is.ColumnValue(
    table.labelVi,
    value,
  );

  _is.ColumnValue<String, String> colorHex(String value) => _is.ColumnValue(
    table.colorHex,
    value,
  );

  _is.ColumnValue<String, String> icon(String value) => _is.ColumnValue(
    table.icon,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );
}

class MoodTable extends _is.Table<int?> {
  MoodTable({super.tableRelation}) : super(tableName: 'moods') {
    updateTable = MoodUpdateTable(this);
    code = _is.ColumnString(
      'code',
      this,
    );
    labelVi = _is.ColumnString(
      'labelVi',
      this,
    );
    colorHex = _is.ColumnString(
      'colorHex',
      this,
    );
    icon = _is.ColumnString(
      'icon',
      this,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
  }

  late final MoodUpdateTable updateTable;

  late final _is.ColumnString code;

  late final _is.ColumnString labelVi;

  late final _is.ColumnString colorHex;

  late final _is.ColumnString icon;

  late final _is.ColumnInt sortOrder;

  @override
  List<_is.Column> get columns => [
    id,
    code,
    labelVi,
    colorHex,
    icon,
    sortOrder,
  ];
}

class MoodInclude extends _is.IncludeObject {
  MoodInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Mood.t;
}

class MoodIncludeList extends _is.IncludeList {
  MoodIncludeList._({
    _is.WhereExpressionBuilder<MoodTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Mood.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Mood.t;
}

class MoodRepository {
  const MoodRepository._();

  /// Returns a list of [Mood]s matching the given query parameters.
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
  Future<List<Mood>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MoodTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MoodTable>? orderBy,
    _is.OrderByListBuilder<MoodTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Mood>(
      where: where?.call(Mood.t),
      orderBy: orderBy?.call(Mood.t),
      orderByList: orderByList?.call(Mood.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Mood] matching the given query parameters.
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
  Future<Mood?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MoodTable>? where,
    int? offset,
    _is.OrderByBuilder<MoodTable>? orderBy,
    _is.OrderByListBuilder<MoodTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Mood>(
      where: where?.call(Mood.t),
      orderBy: orderBy?.call(Mood.t),
      orderByList: orderByList?.call(Mood.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Mood] by its [id] or null if no such row exists.
  Future<Mood?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Mood>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Mood]s in the list and returns the inserted rows.
  ///
  /// The returned [Mood]s will have their `id` fields set.
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
  Future<List<Mood>> insert(
    _is.DatabaseSession session,
    List<Mood> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Mood>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Mood] and returns the inserted row.
  ///
  /// The returned [Mood] will have its `id` field set.
  Future<Mood> insertRow(
    _is.DatabaseSession session,
    Mood row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Mood>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Mood]s in the list and returns the resulting rows.
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
  /// The returned [Mood]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Mood>> upsert(
    _is.DatabaseSession session,
    List<Mood> rows, {
    required _is.ColumnSelections<MoodTable> conflictColumns,
    _is.ColumnSelections<MoodTable>? updateColumns,
    _is.WhereExpressionBuilder<MoodTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Mood>(
      rows,
      conflictColumns: conflictColumns(Mood.t),
      updateColumns: updateColumns?.call(Mood.t),
      updateWhere: updateWhere?.call(Mood.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Mood] and returns the resulting row.
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
  /// The returned [Mood] will have its `id` field set.
  Future<Mood?> upsertRow(
    _is.DatabaseSession session,
    Mood row, {
    required _is.ColumnSelections<MoodTable> conflictColumns,
    _is.ColumnSelections<MoodTable>? updateColumns,
    _is.WhereExpressionBuilder<MoodTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Mood>(
      row,
      conflictColumns: conflictColumns(Mood.t),
      updateColumns: updateColumns?.call(Mood.t),
      updateWhere: updateWhere?.call(Mood.t),
      transaction: transaction,
    );
  }

  /// Updates all [Mood]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Mood>> update(
    _is.DatabaseSession session,
    List<Mood> rows, {
    _is.ColumnSelections<MoodTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Mood>(
      rows,
      columns: columns?.call(Mood.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Mood]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Mood> updateRow(
    _is.DatabaseSession session,
    Mood row, {
    _is.ColumnSelections<MoodTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Mood>(
      row,
      columns: columns?.call(Mood.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Mood] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Mood?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MoodUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Mood>(
      id,
      columnValues: columnValues(Mood.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Mood]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Mood>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MoodUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MoodTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MoodTable>? orderBy,
    _is.OrderByListBuilder<MoodTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Mood>(
      columnValues: columnValues(Mood.t.updateTable),
      where: where(Mood.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Mood.t),
      orderByList: orderByList?.call(Mood.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Mood]s in the list and returns the deleted rows.
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
  Future<List<Mood>> delete(
    _is.DatabaseSession session,
    List<Mood> rows, {
    _is.OrderByBuilder<MoodTable>? orderBy,
    _is.OrderByListBuilder<MoodTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Mood>(
      rows,
      orderBy: orderBy?.call(Mood.t),
      orderByList: orderByList?.call(Mood.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Mood].
  Future<Mood> deleteRow(
    _is.DatabaseSession session,
    Mood row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Mood>(
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
  Future<List<Mood>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MoodTable> where,
    _is.OrderByBuilder<MoodTable>? orderBy,
    _is.OrderByListBuilder<MoodTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Mood>(
      where: where(Mood.t),
      orderBy: orderBy?.call(Mood.t),
      orderByList: orderByList?.call(Mood.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MoodTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Mood>(
      where: where?.call(Mood.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Mood] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MoodTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Mood>(
      where: where(Mood.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
