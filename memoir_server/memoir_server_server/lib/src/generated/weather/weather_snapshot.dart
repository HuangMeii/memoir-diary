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

/// Per-day weather snapshot so a past day's weather survives API outages.
abstract class WeatherSnapshot
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  WeatherSnapshot._({
    this.id,
    required this.userId,
    required this.forecastDate,
    required this.weatherCode,
    this.weatherId,
    this.tempMin,
    this.tempMax,
    this.tempAvg,
    this.precipitationMm,
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  factory WeatherSnapshot({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime forecastDate,
    required int weatherCode,
    int? weatherId,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
    DateTime? fetchedAt,
  }) = _WeatherSnapshotImpl;

  factory WeatherSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return WeatherSnapshot(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      forecastDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['forecastDate'],
      ),
      weatherCode: jsonSerialization['weatherCode'] as int,
      weatherId: jsonSerialization['weatherId'] as int?,
      tempMin: (jsonSerialization['tempMin'] as num?)?.toDouble(),
      tempMax: (jsonSerialization['tempMax'] as num?)?.toDouble(),
      tempAvg: (jsonSerialization['tempAvg'] as num?)?.toDouble(),
      precipitationMm: (jsonSerialization['precipitationMm'] as num?)
          ?.toDouble(),
      fetchedAt: jsonSerialization['fetchedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['fetchedAt']),
    );
  }

  static final t = WeatherSnapshotTable();

  static const db = WeatherSnapshotRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  DateTime forecastDate;

  /// Raw WMO code from the API.
  int weatherCode;

  /// Matching row in the weathers lookup.
  int? weatherId;

  double? tempMin;

  double? tempMax;

  double? tempAvg;

  double? precipitationMm;

  DateTime fetchedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [WeatherSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WeatherSnapshot copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    DateTime? forecastDate,
    int? weatherCode,
    int? weatherId,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
    DateTime? fetchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WeatherSnapshot',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'forecastDate': forecastDate.toJson(),
      'weatherCode': weatherCode,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempMin != null) 'tempMin': tempMin,
      if (tempMax != null) 'tempMax': tempMax,
      if (tempAvg != null) 'tempAvg': tempAvg,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WeatherSnapshot',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'forecastDate': forecastDate.toJson(),
      'weatherCode': weatherCode,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempMin != null) 'tempMin': tempMin,
      if (tempMax != null) 'tempMax': tempMax,
      if (tempAvg != null) 'tempAvg': tempAvg,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  static WeatherSnapshotInclude include() {
    return WeatherSnapshotInclude._();
  }

  static WeatherSnapshotIncludeList includeList({
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WeatherSnapshotTable>? orderBy,
    _is.OrderByListBuilder<WeatherSnapshotTable>? orderByList,
    WeatherSnapshotInclude? include,
  }) {
    return WeatherSnapshotIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WeatherSnapshot.t),
      orderByList: orderByList?.call(WeatherSnapshot.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WeatherSnapshotImpl extends WeatherSnapshot {
  _WeatherSnapshotImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime forecastDate,
    required int weatherCode,
    int? weatherId,
    double? tempMin,
    double? tempMax,
    double? tempAvg,
    double? precipitationMm,
    DateTime? fetchedAt,
  }) : super._(
         id: id,
         userId: userId,
         forecastDate: forecastDate,
         weatherCode: weatherCode,
         weatherId: weatherId,
         tempMin: tempMin,
         tempMax: tempMax,
         tempAvg: tempAvg,
         precipitationMm: precipitationMm,
         fetchedAt: fetchedAt,
       );

  /// Returns a shallow copy of this [WeatherSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WeatherSnapshot copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? forecastDate,
    int? weatherCode,
    Object? weatherId = _Undefined,
    Object? tempMin = _Undefined,
    Object? tempMax = _Undefined,
    Object? tempAvg = _Undefined,
    Object? precipitationMm = _Undefined,
    DateTime? fetchedAt,
  }) {
    return WeatherSnapshot(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      forecastDate: forecastDate ?? this.forecastDate,
      weatherCode: weatherCode ?? this.weatherCode,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      tempMin: tempMin is double? ? tempMin : this.tempMin,
      tempMax: tempMax is double? ? tempMax : this.tempMax,
      tempAvg: tempAvg is double? ? tempAvg : this.tempAvg,
      precipitationMm: precipitationMm is double?
          ? precipitationMm
          : this.precipitationMm,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }
}

class WeatherSnapshotUpdateTable extends _is.UpdateTable<WeatherSnapshotTable> {
  WeatherSnapshotUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> forecastDate(DateTime value) =>
      _is.ColumnValue(
        table.forecastDate,
        value,
      );

  _is.ColumnValue<int, int> weatherCode(int value) => _is.ColumnValue(
    table.weatherCode,
    value,
  );

  _is.ColumnValue<int, int> weatherId(int? value) => _is.ColumnValue(
    table.weatherId,
    value,
  );

  _is.ColumnValue<double, double> tempMin(double? value) => _is.ColumnValue(
    table.tempMin,
    value,
  );

  _is.ColumnValue<double, double> tempMax(double? value) => _is.ColumnValue(
    table.tempMax,
    value,
  );

  _is.ColumnValue<double, double> tempAvg(double? value) => _is.ColumnValue(
    table.tempAvg,
    value,
  );

  _is.ColumnValue<double, double> precipitationMm(double? value) =>
      _is.ColumnValue(
        table.precipitationMm,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> fetchedAt(DateTime value) =>
      _is.ColumnValue(
        table.fetchedAt,
        value,
      );
}

class WeatherSnapshotTable extends _is.Table<_is.UuidValue?> {
  WeatherSnapshotTable({super.tableRelation})
    : super(tableName: 'weather_snapshots') {
    updateTable = WeatherSnapshotUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    forecastDate = _is.ColumnDateTime(
      'forecastDate',
      this,
    );
    weatherCode = _is.ColumnInt(
      'weatherCode',
      this,
    );
    weatherId = _is.ColumnInt(
      'weatherId',
      this,
    );
    tempMin = _is.ColumnDouble(
      'tempMin',
      this,
    );
    tempMax = _is.ColumnDouble(
      'tempMax',
      this,
    );
    tempAvg = _is.ColumnDouble(
      'tempAvg',
      this,
    );
    precipitationMm = _is.ColumnDouble(
      'precipitationMm',
      this,
    );
    fetchedAt = _is.ColumnDateTime(
      'fetchedAt',
      this,
      hasDefault: true,
    );
  }

  late final WeatherSnapshotUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnDateTime forecastDate;

  /// Raw WMO code from the API.
  late final _is.ColumnInt weatherCode;

  /// Matching row in the weathers lookup.
  late final _is.ColumnInt weatherId;

  late final _is.ColumnDouble tempMin;

  late final _is.ColumnDouble tempMax;

  late final _is.ColumnDouble tempAvg;

  late final _is.ColumnDouble precipitationMm;

  late final _is.ColumnDateTime fetchedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    forecastDate,
    weatherCode,
    weatherId,
    tempMin,
    tempMax,
    tempAvg,
    precipitationMm,
    fetchedAt,
  ];
}

class WeatherSnapshotInclude extends _is.IncludeObject {
  WeatherSnapshotInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => WeatherSnapshot.t;
}

class WeatherSnapshotIncludeList extends _is.IncludeList {
  WeatherSnapshotIncludeList._({
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WeatherSnapshot.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => WeatherSnapshot.t;
}

class WeatherSnapshotRepository {
  const WeatherSnapshotRepository._();

  /// Returns a list of [WeatherSnapshot]s matching the given query parameters.
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
  Future<List<WeatherSnapshot>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WeatherSnapshotTable>? orderBy,
    _is.OrderByListBuilder<WeatherSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WeatherSnapshot>(
      where: where?.call(WeatherSnapshot.t),
      orderBy: orderBy?.call(WeatherSnapshot.t),
      orderByList: orderByList?.call(WeatherSnapshot.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WeatherSnapshot] matching the given query parameters.
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
  Future<WeatherSnapshot?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? where,
    int? offset,
    _is.OrderByBuilder<WeatherSnapshotTable>? orderBy,
    _is.OrderByListBuilder<WeatherSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WeatherSnapshot>(
      where: where?.call(WeatherSnapshot.t),
      orderBy: orderBy?.call(WeatherSnapshot.t),
      orderByList: orderByList?.call(WeatherSnapshot.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WeatherSnapshot] by its [id] or null if no such row exists.
  Future<WeatherSnapshot?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WeatherSnapshot>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WeatherSnapshot]s in the list and returns the inserted rows.
  ///
  /// The returned [WeatherSnapshot]s will have their `id` fields set.
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
  Future<List<WeatherSnapshot>> insert(
    _is.DatabaseSession session,
    List<WeatherSnapshot> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WeatherSnapshot>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WeatherSnapshot] and returns the inserted row.
  ///
  /// The returned [WeatherSnapshot] will have its `id` field set.
  Future<WeatherSnapshot> insertRow(
    _is.DatabaseSession session,
    WeatherSnapshot row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WeatherSnapshot>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WeatherSnapshot]s in the list and returns the resulting rows.
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
  /// The returned [WeatherSnapshot]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WeatherSnapshot>> upsert(
    _is.DatabaseSession session,
    List<WeatherSnapshot> rows, {
    required _is.ColumnSelections<WeatherSnapshotTable> conflictColumns,
    _is.ColumnSelections<WeatherSnapshotTable>? updateColumns,
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WeatherSnapshot>(
      rows,
      conflictColumns: conflictColumns(WeatherSnapshot.t),
      updateColumns: updateColumns?.call(WeatherSnapshot.t),
      updateWhere: updateWhere?.call(WeatherSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WeatherSnapshot] and returns the resulting row.
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
  /// The returned [WeatherSnapshot] will have its `id` field set.
  Future<WeatherSnapshot?> upsertRow(
    _is.DatabaseSession session,
    WeatherSnapshot row, {
    required _is.ColumnSelections<WeatherSnapshotTable> conflictColumns,
    _is.ColumnSelections<WeatherSnapshotTable>? updateColumns,
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WeatherSnapshot>(
      row,
      conflictColumns: conflictColumns(WeatherSnapshot.t),
      updateColumns: updateColumns?.call(WeatherSnapshot.t),
      updateWhere: updateWhere?.call(WeatherSnapshot.t),
      transaction: transaction,
    );
  }

  /// Updates all [WeatherSnapshot]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WeatherSnapshot>> update(
    _is.DatabaseSession session,
    List<WeatherSnapshot> rows, {
    _is.ColumnSelections<WeatherSnapshotTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WeatherSnapshot>(
      rows,
      columns: columns?.call(WeatherSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WeatherSnapshot]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WeatherSnapshot> updateRow(
    _is.DatabaseSession session,
    WeatherSnapshot row, {
    _is.ColumnSelections<WeatherSnapshotTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WeatherSnapshot>(
      row,
      columns: columns?.call(WeatherSnapshot.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WeatherSnapshot] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WeatherSnapshot?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<WeatherSnapshotUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WeatherSnapshot>(
      id,
      columnValues: columnValues(WeatherSnapshot.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WeatherSnapshot]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WeatherSnapshot>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WeatherSnapshotUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<WeatherSnapshotTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WeatherSnapshotTable>? orderBy,
    _is.OrderByListBuilder<WeatherSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WeatherSnapshot>(
      columnValues: columnValues(WeatherSnapshot.t.updateTable),
      where: where(WeatherSnapshot.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WeatherSnapshot.t),
      orderByList: orderByList?.call(WeatherSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WeatherSnapshot]s in the list and returns the deleted rows.
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
  Future<List<WeatherSnapshot>> delete(
    _is.DatabaseSession session,
    List<WeatherSnapshot> rows, {
    _is.OrderByBuilder<WeatherSnapshotTable>? orderBy,
    _is.OrderByListBuilder<WeatherSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WeatherSnapshot>(
      rows,
      orderBy: orderBy?.call(WeatherSnapshot.t),
      orderByList: orderByList?.call(WeatherSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WeatherSnapshot].
  Future<WeatherSnapshot> deleteRow(
    _is.DatabaseSession session,
    WeatherSnapshot row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WeatherSnapshot>(
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
  Future<List<WeatherSnapshot>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WeatherSnapshotTable> where,
    _is.OrderByBuilder<WeatherSnapshotTable>? orderBy,
    _is.OrderByListBuilder<WeatherSnapshotTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WeatherSnapshot>(
      where: where(WeatherSnapshot.t),
      orderBy: orderBy?.call(WeatherSnapshot.t),
      orderByList: orderByList?.call(WeatherSnapshot.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WeatherSnapshotTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WeatherSnapshot>(
      where: where?.call(WeatherSnapshot.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WeatherSnapshot] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WeatherSnapshotTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WeatherSnapshot>(
      where: where(WeatherSnapshot.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
