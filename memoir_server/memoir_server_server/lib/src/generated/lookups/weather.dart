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

/// Weather lookup (5 rows, seeded).
abstract class Weather
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Weather._({
    this.id,
    required this.code,
    required this.labelVi,
    required this.colorHex,
    required this.icon,
    int? sortOrder,
  }) : sortOrder = sortOrder ?? 0;

  factory Weather({
    int? id,
    required String code,
    required String labelVi,
    required String colorHex,
    required String icon,
    int? sortOrder,
  }) = _WeatherImpl;

  factory Weather.fromJson(Map<String, dynamic> jsonSerialization) {
    return Weather(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      labelVi: jsonSerialization['labelVi'] as String,
      colorHex: jsonSerialization['colorHex'] as String,
      icon: jsonSerialization['icon'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  static final t = WeatherTable();

  static const db = WeatherRepository._();

  @override
  int? id;

  String code;

  String labelVi;

  String colorHex;

  String icon;

  int sortOrder;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Weather]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Weather copyWith({
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
      '__className__': 'Weather',
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
      '__className__': 'Weather',
      if (id != null) 'id': id,
      'code': code,
      'labelVi': labelVi,
      'colorHex': colorHex,
      'icon': icon,
      'sortOrder': sortOrder,
    };
  }

  static WeatherInclude include() {
    return WeatherInclude._();
  }

  static WeatherIncludeList includeList({
    _is.WhereExpressionBuilder<WeatherTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WeatherTable>? orderBy,
    _is.OrderByListBuilder<WeatherTable>? orderByList,
    WeatherInclude? include,
  }) {
    return WeatherIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Weather.t),
      orderByList: orderByList?.call(Weather.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WeatherImpl extends Weather {
  _WeatherImpl({
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

  /// Returns a shallow copy of this [Weather]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Weather copyWith({
    Object? id = _Undefined,
    String? code,
    String? labelVi,
    String? colorHex,
    String? icon,
    int? sortOrder,
  }) {
    return Weather(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      labelVi: labelVi ?? this.labelVi,
      colorHex: colorHex ?? this.colorHex,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class WeatherUpdateTable extends _is.UpdateTable<WeatherTable> {
  WeatherUpdateTable(super.table);

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

class WeatherTable extends _is.Table<int?> {
  WeatherTable({super.tableRelation}) : super(tableName: 'weathers') {
    updateTable = WeatherUpdateTable(this);
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

  late final WeatherUpdateTable updateTable;

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

class WeatherInclude extends _is.IncludeObject {
  WeatherInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Weather.t;
}

class WeatherIncludeList extends _is.IncludeList {
  WeatherIncludeList._({
    _is.WhereExpressionBuilder<WeatherTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Weather.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Weather.t;
}

class WeatherRepository {
  const WeatherRepository._();

  /// Returns a list of [Weather]s matching the given query parameters.
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
  Future<List<Weather>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WeatherTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WeatherTable>? orderBy,
    _is.OrderByListBuilder<WeatherTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Weather>(
      where: where?.call(Weather.t),
      orderBy: orderBy?.call(Weather.t),
      orderByList: orderByList?.call(Weather.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Weather] matching the given query parameters.
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
  Future<Weather?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WeatherTable>? where,
    int? offset,
    _is.OrderByBuilder<WeatherTable>? orderBy,
    _is.OrderByListBuilder<WeatherTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Weather>(
      where: where?.call(Weather.t),
      orderBy: orderBy?.call(Weather.t),
      orderByList: orderByList?.call(Weather.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Weather] by its [id] or null if no such row exists.
  Future<Weather?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Weather>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Weather]s in the list and returns the inserted rows.
  ///
  /// The returned [Weather]s will have their `id` fields set.
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
  Future<List<Weather>> insert(
    _is.DatabaseSession session,
    List<Weather> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Weather>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Weather] and returns the inserted row.
  ///
  /// The returned [Weather] will have its `id` field set.
  Future<Weather> insertRow(
    _is.DatabaseSession session,
    Weather row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Weather>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Weather]s in the list and returns the resulting rows.
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
  /// The returned [Weather]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Weather>> upsert(
    _is.DatabaseSession session,
    List<Weather> rows, {
    required _is.ColumnSelections<WeatherTable> conflictColumns,
    _is.ColumnSelections<WeatherTable>? updateColumns,
    _is.WhereExpressionBuilder<WeatherTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Weather>(
      rows,
      conflictColumns: conflictColumns(Weather.t),
      updateColumns: updateColumns?.call(Weather.t),
      updateWhere: updateWhere?.call(Weather.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Weather] and returns the resulting row.
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
  /// The returned [Weather] will have its `id` field set.
  Future<Weather?> upsertRow(
    _is.DatabaseSession session,
    Weather row, {
    required _is.ColumnSelections<WeatherTable> conflictColumns,
    _is.ColumnSelections<WeatherTable>? updateColumns,
    _is.WhereExpressionBuilder<WeatherTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Weather>(
      row,
      conflictColumns: conflictColumns(Weather.t),
      updateColumns: updateColumns?.call(Weather.t),
      updateWhere: updateWhere?.call(Weather.t),
      transaction: transaction,
    );
  }

  /// Updates all [Weather]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Weather>> update(
    _is.DatabaseSession session,
    List<Weather> rows, {
    _is.ColumnSelections<WeatherTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Weather>(
      rows,
      columns: columns?.call(Weather.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Weather]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Weather> updateRow(
    _is.DatabaseSession session,
    Weather row, {
    _is.ColumnSelections<WeatherTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Weather>(
      row,
      columns: columns?.call(Weather.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Weather] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Weather?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<WeatherUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Weather>(
      id,
      columnValues: columnValues(Weather.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Weather]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Weather>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WeatherUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<WeatherTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WeatherTable>? orderBy,
    _is.OrderByListBuilder<WeatherTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Weather>(
      columnValues: columnValues(Weather.t.updateTable),
      where: where(Weather.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Weather.t),
      orderByList: orderByList?.call(Weather.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Weather]s in the list and returns the deleted rows.
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
  Future<List<Weather>> delete(
    _is.DatabaseSession session,
    List<Weather> rows, {
    _is.OrderByBuilder<WeatherTable>? orderBy,
    _is.OrderByListBuilder<WeatherTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Weather>(
      rows,
      orderBy: orderBy?.call(Weather.t),
      orderByList: orderByList?.call(Weather.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Weather].
  Future<Weather> deleteRow(
    _is.DatabaseSession session,
    Weather row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Weather>(
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
  Future<List<Weather>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WeatherTable> where,
    _is.OrderByBuilder<WeatherTable>? orderBy,
    _is.OrderByListBuilder<WeatherTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Weather>(
      where: where(Weather.t),
      orderBy: orderBy?.call(Weather.t),
      orderByList: orderByList?.call(Weather.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WeatherTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Weather>(
      where: where?.call(Weather.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Weather] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WeatherTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Weather>(
      where: where(Weather.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
