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

/// One stop of a saved journey, in travel order.
abstract class JourneyStop
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  JourneyStop._({
    this.id,
    required this.journeyId,
    required this.seq,
    required this.kind,
    required this.name,
    required this.lat,
    required this.lon,
    int? dwellMinutes,
    this.arrivalAt,
    this.distanceFromStartMeters,
  }) : dwellMinutes = dwellMinutes ?? 0;

  factory JourneyStop({
    _is.UuidValue? id,
    required _is.UuidValue journeyId,
    required int seq,
    required String kind,
    required String name,
    required double lat,
    required double lon,
    int? dwellMinutes,
    DateTime? arrivalAt,
    int? distanceFromStartMeters,
  }) = _JourneyStopImpl;

  factory JourneyStop.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyStop(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      journeyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['journeyId'],
      ),
      seq: jsonSerialization['seq'] as int,
      kind: jsonSerialization['kind'] as String,
      name: jsonSerialization['name'] as String,
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
      dwellMinutes: jsonSerialization['dwellMinutes'] as int?,
      arrivalAt: jsonSerialization['arrivalAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['arrivalAt']),
      distanceFromStartMeters:
          jsonSerialization['distanceFromStartMeters'] as int?,
    );
  }

  static final t = JourneyStopTable();

  static const db = JourneyStopRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue journeyId;

  int seq;

  /// origin | waypoint | destination
  String kind;

  String name;

  double lat;

  double lon;

  int dwellMinutes;

  DateTime? arrivalAt;

  int? distanceFromStartMeters;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [JourneyStop]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JourneyStop copyWith({
    _is.UuidValue? id,
    _is.UuidValue? journeyId,
    int? seq,
    String? kind,
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    DateTime? arrivalAt,
    int? distanceFromStartMeters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyStop',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'kind': kind,
      'name': name,
      'lat': lat,
      'lon': lon,
      'dwellMinutes': dwellMinutes,
      if (arrivalAt != null) 'arrivalAt': arrivalAt?.toJson(),
      if (distanceFromStartMeters != null)
        'distanceFromStartMeters': distanceFromStartMeters,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyStop',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'kind': kind,
      'name': name,
      'lat': lat,
      'lon': lon,
      'dwellMinutes': dwellMinutes,
      if (arrivalAt != null) 'arrivalAt': arrivalAt?.toJson(),
      if (distanceFromStartMeters != null)
        'distanceFromStartMeters': distanceFromStartMeters,
    };
  }

  static JourneyStopInclude include() {
    return JourneyStopInclude._();
  }

  static JourneyStopIncludeList includeList({
    _is.WhereExpressionBuilder<JourneyStopTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyStopTable>? orderBy,
    _is.OrderByListBuilder<JourneyStopTable>? orderByList,
    JourneyStopInclude? include,
  }) {
    return JourneyStopIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JourneyStop.t),
      orderByList: orderByList?.call(JourneyStop.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyStopImpl extends JourneyStop {
  _JourneyStopImpl({
    _is.UuidValue? id,
    required _is.UuidValue journeyId,
    required int seq,
    required String kind,
    required String name,
    required double lat,
    required double lon,
    int? dwellMinutes,
    DateTime? arrivalAt,
    int? distanceFromStartMeters,
  }) : super._(
         id: id,
         journeyId: journeyId,
         seq: seq,
         kind: kind,
         name: name,
         lat: lat,
         lon: lon,
         dwellMinutes: dwellMinutes,
         arrivalAt: arrivalAt,
         distanceFromStartMeters: distanceFromStartMeters,
       );

  /// Returns a shallow copy of this [JourneyStop]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JourneyStop copyWith({
    Object? id = _Undefined,
    _is.UuidValue? journeyId,
    int? seq,
    String? kind,
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    Object? arrivalAt = _Undefined,
    Object? distanceFromStartMeters = _Undefined,
  }) {
    return JourneyStop(
      id: id is _is.UuidValue? ? id : this.id,
      journeyId: journeyId ?? this.journeyId,
      seq: seq ?? this.seq,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      dwellMinutes: dwellMinutes ?? this.dwellMinutes,
      arrivalAt: arrivalAt is DateTime? ? arrivalAt : this.arrivalAt,
      distanceFromStartMeters: distanceFromStartMeters is int?
          ? distanceFromStartMeters
          : this.distanceFromStartMeters,
    );
  }
}

class JourneyStopUpdateTable extends _is.UpdateTable<JourneyStopTable> {
  JourneyStopUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> journeyId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.journeyId,
    value,
  );

  _is.ColumnValue<int, int> seq(int value) => _is.ColumnValue(
    table.seq,
    value,
  );

  _is.ColumnValue<String, String> kind(String value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<double, double> lat(double value) => _is.ColumnValue(
    table.lat,
    value,
  );

  _is.ColumnValue<double, double> lon(double value) => _is.ColumnValue(
    table.lon,
    value,
  );

  _is.ColumnValue<int, int> dwellMinutes(int value) => _is.ColumnValue(
    table.dwellMinutes,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> arrivalAt(DateTime? value) =>
      _is.ColumnValue(
        table.arrivalAt,
        value,
      );

  _is.ColumnValue<int, int> distanceFromStartMeters(int? value) =>
      _is.ColumnValue(
        table.distanceFromStartMeters,
        value,
      );
}

class JourneyStopTable extends _is.Table<_is.UuidValue?> {
  JourneyStopTable({super.tableRelation}) : super(tableName: 'journey_stops') {
    updateTable = JourneyStopUpdateTable(this);
    journeyId = _is.ColumnUuid(
      'journeyId',
      this,
    );
    seq = _is.ColumnInt(
      'seq',
      this,
    );
    kind = _is.ColumnString(
      'kind',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    lat = _is.ColumnDouble(
      'lat',
      this,
    );
    lon = _is.ColumnDouble(
      'lon',
      this,
    );
    dwellMinutes = _is.ColumnInt(
      'dwellMinutes',
      this,
      hasDefault: true,
    );
    arrivalAt = _is.ColumnDateTime(
      'arrivalAt',
      this,
    );
    distanceFromStartMeters = _is.ColumnInt(
      'distanceFromStartMeters',
      this,
    );
  }

  late final JourneyStopUpdateTable updateTable;

  late final _is.ColumnUuid journeyId;

  late final _is.ColumnInt seq;

  /// origin | waypoint | destination
  late final _is.ColumnString kind;

  late final _is.ColumnString name;

  late final _is.ColumnDouble lat;

  late final _is.ColumnDouble lon;

  late final _is.ColumnInt dwellMinutes;

  late final _is.ColumnDateTime arrivalAt;

  late final _is.ColumnInt distanceFromStartMeters;

  @override
  List<_is.Column> get columns => [
    id,
    journeyId,
    seq,
    kind,
    name,
    lat,
    lon,
    dwellMinutes,
    arrivalAt,
    distanceFromStartMeters,
  ];
}

class JourneyStopInclude extends _is.IncludeObject {
  JourneyStopInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => JourneyStop.t;
}

class JourneyStopIncludeList extends _is.IncludeList {
  JourneyStopIncludeList._({
    _is.WhereExpressionBuilder<JourneyStopTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JourneyStop.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => JourneyStop.t;
}

class JourneyStopRepository {
  const JourneyStopRepository._();

  /// Returns a list of [JourneyStop]s matching the given query parameters.
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
  Future<List<JourneyStop>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyStopTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyStopTable>? orderBy,
    _is.OrderByListBuilder<JourneyStopTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<JourneyStop>(
      where: where?.call(JourneyStop.t),
      orderBy: orderBy?.call(JourneyStop.t),
      orderByList: orderByList?.call(JourneyStop.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [JourneyStop] matching the given query parameters.
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
  Future<JourneyStop?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyStopTable>? where,
    int? offset,
    _is.OrderByBuilder<JourneyStopTable>? orderBy,
    _is.OrderByListBuilder<JourneyStopTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<JourneyStop>(
      where: where?.call(JourneyStop.t),
      orderBy: orderBy?.call(JourneyStop.t),
      orderByList: orderByList?.call(JourneyStop.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [JourneyStop] by its [id] or null if no such row exists.
  Future<JourneyStop?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<JourneyStop>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [JourneyStop]s in the list and returns the inserted rows.
  ///
  /// The returned [JourneyStop]s will have their `id` fields set.
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
  Future<List<JourneyStop>> insert(
    _is.DatabaseSession session,
    List<JourneyStop> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<JourneyStop>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [JourneyStop] and returns the inserted row.
  ///
  /// The returned [JourneyStop] will have its `id` field set.
  Future<JourneyStop> insertRow(
    _is.DatabaseSession session,
    JourneyStop row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<JourneyStop>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [JourneyStop]s in the list and returns the resulting rows.
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
  /// The returned [JourneyStop]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JourneyStop>> upsert(
    _is.DatabaseSession session,
    List<JourneyStop> rows, {
    required _is.ColumnSelections<JourneyStopTable> conflictColumns,
    _is.ColumnSelections<JourneyStopTable>? updateColumns,
    _is.WhereExpressionBuilder<JourneyStopTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<JourneyStop>(
      rows,
      conflictColumns: conflictColumns(JourneyStop.t),
      updateColumns: updateColumns?.call(JourneyStop.t),
      updateWhere: updateWhere?.call(JourneyStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [JourneyStop] and returns the resulting row.
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
  /// The returned [JourneyStop] will have its `id` field set.
  Future<JourneyStop?> upsertRow(
    _is.DatabaseSession session,
    JourneyStop row, {
    required _is.ColumnSelections<JourneyStopTable> conflictColumns,
    _is.ColumnSelections<JourneyStopTable>? updateColumns,
    _is.WhereExpressionBuilder<JourneyStopTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<JourneyStop>(
      row,
      conflictColumns: conflictColumns(JourneyStop.t),
      updateColumns: updateColumns?.call(JourneyStop.t),
      updateWhere: updateWhere?.call(JourneyStop.t),
      transaction: transaction,
    );
  }

  /// Updates all [JourneyStop]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JourneyStop>> update(
    _is.DatabaseSession session,
    List<JourneyStop> rows, {
    _is.ColumnSelections<JourneyStopTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<JourneyStop>(
      rows,
      columns: columns?.call(JourneyStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [JourneyStop]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JourneyStop> updateRow(
    _is.DatabaseSession session,
    JourneyStop row, {
    _is.ColumnSelections<JourneyStopTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<JourneyStop>(
      row,
      columns: columns?.call(JourneyStop.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JourneyStop] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JourneyStop?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<JourneyStopUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<JourneyStop>(
      id,
      columnValues: columnValues(JourneyStop.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JourneyStop]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JourneyStop>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<JourneyStopUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<JourneyStopTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyStopTable>? orderBy,
    _is.OrderByListBuilder<JourneyStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<JourneyStop>(
      columnValues: columnValues(JourneyStop.t.updateTable),
      where: where(JourneyStop.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JourneyStop.t),
      orderByList: orderByList?.call(JourneyStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [JourneyStop]s in the list and returns the deleted rows.
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
  Future<List<JourneyStop>> delete(
    _is.DatabaseSession session,
    List<JourneyStop> rows, {
    _is.OrderByBuilder<JourneyStopTable>? orderBy,
    _is.OrderByListBuilder<JourneyStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<JourneyStop>(
      rows,
      orderBy: orderBy?.call(JourneyStop.t),
      orderByList: orderByList?.call(JourneyStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [JourneyStop].
  Future<JourneyStop> deleteRow(
    _is.DatabaseSession session,
    JourneyStop row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JourneyStop>(
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
  Future<List<JourneyStop>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JourneyStopTable> where,
    _is.OrderByBuilder<JourneyStopTable>? orderBy,
    _is.OrderByListBuilder<JourneyStopTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<JourneyStop>(
      where: where(JourneyStop.t),
      orderBy: orderBy?.call(JourneyStop.t),
      orderByList: orderByList?.call(JourneyStop.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyStopTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<JourneyStop>(
      where: where?.call(JourneyStop.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [JourneyStop] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JourneyStopTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<JourneyStop>(
      where: where(JourneyStop.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
