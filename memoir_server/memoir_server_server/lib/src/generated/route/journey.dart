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

/// A saved trip: the route, its weather snapshot and the diary link. Stops and
/// weather points live in their own tables so a trip can be reopened and shown
/// exactly as it was planned, separately from the latest forecast.
abstract class Journey
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Journey._({
    this.id,
    required this.userId,
    required this.title,
    required this.vehicle,
    required this.departureAt,
    required this.originName,
    required this.originLat,
    required this.originLon,
    required this.destinationName,
    required this.destinationLat,
    required this.destinationLon,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    this.notes,
    this.entryId,
    this.weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Journey({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required String originName,
    required double originLat,
    required double originLon,
    required String destinationName,
    required double destinationLat,
    required double destinationLon,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    String? notes,
    _is.UuidValue? entryId,
    DateTime? weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JourneyImpl;

  factory Journey.fromJson(Map<String, dynamic> jsonSerialization) {
    return Journey(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      title: jsonSerialization['title'] as String,
      vehicle: jsonSerialization['vehicle'] as String,
      departureAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['departureAt'],
      ),
      originName: jsonSerialization['originName'] as String,
      originLat: (jsonSerialization['originLat'] as num).toDouble(),
      originLon: (jsonSerialization['originLon'] as num).toDouble(),
      destinationName: jsonSerialization['destinationName'] as String,
      destinationLat: (jsonSerialization['destinationLat'] as num).toDouble(),
      destinationLon: (jsonSerialization['destinationLon'] as num).toDouble(),
      distanceMeters: jsonSerialization['distanceMeters'] as int,
      durationSeconds: jsonSerialization['durationSeconds'] as int,
      geometry: jsonSerialization['geometry'] as String,
      notes: jsonSerialization['notes'] as String?,
      entryId: jsonSerialization['entryId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['entryId']),
      weatherSavedAt: jsonSerialization['weatherSavedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['weatherSavedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = JourneyTable();

  static const db = JourneyRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  String title;

  /// car | bike | foot
  String vehicle;

  DateTime departureAt;

  String originName;

  double originLat;

  double originLon;

  String destinationName;

  double destinationLat;

  double destinationLon;

  int distanceMeters;

  int durationSeconds;

  /// GeoJSON LineString of the chosen route.
  String geometry;

  String? notes;

  /// Soft link to the diary entry, like `reflections.entryId`: deleting the
  /// entry leaves the trip intact.
  _is.UuidValue? entryId;

  /// When the weather snapshot below was taken.
  DateTime? weatherSavedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Journey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Journey copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    String? title,
    String? vehicle,
    DateTime? departureAt,
    String? originName,
    double? originLat,
    double? originLon,
    String? destinationName,
    double? destinationLat,
    double? destinationLon,
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
    String? notes,
    _is.UuidValue? entryId,
    DateTime? weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Journey',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      'vehicle': vehicle,
      'departureAt': departureAt.toJson(),
      'originName': originName,
      'originLat': originLat,
      'originLon': originLon,
      'destinationName': destinationName,
      'destinationLat': destinationLat,
      'destinationLon': destinationLon,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      if (notes != null) 'notes': notes,
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (weatherSavedAt != null) 'weatherSavedAt': weatherSavedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Journey',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'title': title,
      'vehicle': vehicle,
      'departureAt': departureAt.toJson(),
      'originName': originName,
      'originLat': originLat,
      'originLon': originLon,
      'destinationName': destinationName,
      'destinationLat': destinationLat,
      'destinationLon': destinationLon,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      if (notes != null) 'notes': notes,
      if (entryId != null) 'entryId': entryId?.toJson(),
      if (weatherSavedAt != null) 'weatherSavedAt': weatherSavedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static JourneyInclude include() {
    return JourneyInclude._();
  }

  static JourneyIncludeList includeList({
    _is.WhereExpressionBuilder<JourneyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyTable>? orderBy,
    _is.OrderByListBuilder<JourneyTable>? orderByList,
    JourneyInclude? include,
  }) {
    return JourneyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Journey.t),
      orderByList: orderByList?.call(Journey.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyImpl extends Journey {
  _JourneyImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required String originName,
    required double originLat,
    required double originLon,
    required String destinationName,
    required double destinationLat,
    required double destinationLon,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    String? notes,
    _is.UuidValue? entryId,
    DateTime? weatherSavedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         vehicle: vehicle,
         departureAt: departureAt,
         originName: originName,
         originLat: originLat,
         originLon: originLon,
         destinationName: destinationName,
         destinationLat: destinationLat,
         destinationLon: destinationLon,
         distanceMeters: distanceMeters,
         durationSeconds: durationSeconds,
         geometry: geometry,
         notes: notes,
         entryId: entryId,
         weatherSavedAt: weatherSavedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Journey]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Journey copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    String? title,
    String? vehicle,
    DateTime? departureAt,
    String? originName,
    double? originLat,
    double? originLon,
    String? destinationName,
    double? destinationLat,
    double? destinationLon,
    int? distanceMeters,
    int? durationSeconds,
    String? geometry,
    Object? notes = _Undefined,
    Object? entryId = _Undefined,
    Object? weatherSavedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Journey(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      vehicle: vehicle ?? this.vehicle,
      departureAt: departureAt ?? this.departureAt,
      originName: originName ?? this.originName,
      originLat: originLat ?? this.originLat,
      originLon: originLon ?? this.originLon,
      destinationName: destinationName ?? this.destinationName,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLon: destinationLon ?? this.destinationLon,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      geometry: geometry ?? this.geometry,
      notes: notes is String? ? notes : this.notes,
      entryId: entryId is _is.UuidValue? ? entryId : this.entryId,
      weatherSavedAt: weatherSavedAt is DateTime?
          ? weatherSavedAt
          : this.weatherSavedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class JourneyUpdateTable extends _is.UpdateTable<JourneyTable> {
  JourneyUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> vehicle(String value) => _is.ColumnValue(
    table.vehicle,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> departureAt(DateTime value) =>
      _is.ColumnValue(
        table.departureAt,
        value,
      );

  _is.ColumnValue<String, String> originName(String value) => _is.ColumnValue(
    table.originName,
    value,
  );

  _is.ColumnValue<double, double> originLat(double value) => _is.ColumnValue(
    table.originLat,
    value,
  );

  _is.ColumnValue<double, double> originLon(double value) => _is.ColumnValue(
    table.originLon,
    value,
  );

  _is.ColumnValue<String, String> destinationName(String value) =>
      _is.ColumnValue(
        table.destinationName,
        value,
      );

  _is.ColumnValue<double, double> destinationLat(double value) =>
      _is.ColumnValue(
        table.destinationLat,
        value,
      );

  _is.ColumnValue<double, double> destinationLon(double value) =>
      _is.ColumnValue(
        table.destinationLon,
        value,
      );

  _is.ColumnValue<int, int> distanceMeters(int value) => _is.ColumnValue(
    table.distanceMeters,
    value,
  );

  _is.ColumnValue<int, int> durationSeconds(int value) => _is.ColumnValue(
    table.durationSeconds,
    value,
  );

  _is.ColumnValue<String, String> geometry(String value) => _is.ColumnValue(
    table.geometry,
    value,
  );

  _is.ColumnValue<String, String> notes(String? value) => _is.ColumnValue(
    table.notes,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> entryId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.entryId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> weatherSavedAt(DateTime? value) =>
      _is.ColumnValue(
        table.weatherSavedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class JourneyTable extends _is.Table<_is.UuidValue?> {
  JourneyTable({super.tableRelation}) : super(tableName: 'journeys') {
    updateTable = JourneyUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    vehicle = _is.ColumnString(
      'vehicle',
      this,
    );
    departureAt = _is.ColumnDateTime(
      'departureAt',
      this,
    );
    originName = _is.ColumnString(
      'originName',
      this,
    );
    originLat = _is.ColumnDouble(
      'originLat',
      this,
    );
    originLon = _is.ColumnDouble(
      'originLon',
      this,
    );
    destinationName = _is.ColumnString(
      'destinationName',
      this,
    );
    destinationLat = _is.ColumnDouble(
      'destinationLat',
      this,
    );
    destinationLon = _is.ColumnDouble(
      'destinationLon',
      this,
    );
    distanceMeters = _is.ColumnInt(
      'distanceMeters',
      this,
    );
    durationSeconds = _is.ColumnInt(
      'durationSeconds',
      this,
    );
    geometry = _is.ColumnString(
      'geometry',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
    entryId = _is.ColumnUuid(
      'entryId',
      this,
    );
    weatherSavedAt = _is.ColumnDateTime(
      'weatherSavedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final JourneyUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnString title;

  /// car | bike | foot
  late final _is.ColumnString vehicle;

  late final _is.ColumnDateTime departureAt;

  late final _is.ColumnString originName;

  late final _is.ColumnDouble originLat;

  late final _is.ColumnDouble originLon;

  late final _is.ColumnString destinationName;

  late final _is.ColumnDouble destinationLat;

  late final _is.ColumnDouble destinationLon;

  late final _is.ColumnInt distanceMeters;

  late final _is.ColumnInt durationSeconds;

  /// GeoJSON LineString of the chosen route.
  late final _is.ColumnString geometry;

  late final _is.ColumnString notes;

  /// Soft link to the diary entry, like `reflections.entryId`: deleting the
  /// entry leaves the trip intact.
  late final _is.ColumnUuid entryId;

  /// When the weather snapshot below was taken.
  late final _is.ColumnDateTime weatherSavedAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    title,
    vehicle,
    departureAt,
    originName,
    originLat,
    originLon,
    destinationName,
    destinationLat,
    destinationLon,
    distanceMeters,
    durationSeconds,
    geometry,
    notes,
    entryId,
    weatherSavedAt,
    createdAt,
    updatedAt,
  ];
}

class JourneyInclude extends _is.IncludeObject {
  JourneyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Journey.t;
}

class JourneyIncludeList extends _is.IncludeList {
  JourneyIncludeList._({
    _is.WhereExpressionBuilder<JourneyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Journey.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Journey.t;
}

class JourneyRepository {
  const JourneyRepository._();

  /// Returns a list of [Journey]s matching the given query parameters.
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
  Future<List<Journey>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyTable>? orderBy,
    _is.OrderByListBuilder<JourneyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Journey>(
      where: where?.call(Journey.t),
      orderBy: orderBy?.call(Journey.t),
      orderByList: orderByList?.call(Journey.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Journey] matching the given query parameters.
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
  Future<Journey?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyTable>? where,
    int? offset,
    _is.OrderByBuilder<JourneyTable>? orderBy,
    _is.OrderByListBuilder<JourneyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Journey>(
      where: where?.call(Journey.t),
      orderBy: orderBy?.call(Journey.t),
      orderByList: orderByList?.call(Journey.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Journey] by its [id] or null if no such row exists.
  Future<Journey?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Journey>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Journey]s in the list and returns the inserted rows.
  ///
  /// The returned [Journey]s will have their `id` fields set.
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
  Future<List<Journey>> insert(
    _is.DatabaseSession session,
    List<Journey> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Journey>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Journey] and returns the inserted row.
  ///
  /// The returned [Journey] will have its `id` field set.
  Future<Journey> insertRow(
    _is.DatabaseSession session,
    Journey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Journey>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Journey]s in the list and returns the resulting rows.
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
  /// The returned [Journey]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Journey>> upsert(
    _is.DatabaseSession session,
    List<Journey> rows, {
    required _is.ColumnSelections<JourneyTable> conflictColumns,
    _is.ColumnSelections<JourneyTable>? updateColumns,
    _is.WhereExpressionBuilder<JourneyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Journey>(
      rows,
      conflictColumns: conflictColumns(Journey.t),
      updateColumns: updateColumns?.call(Journey.t),
      updateWhere: updateWhere?.call(Journey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Journey] and returns the resulting row.
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
  /// The returned [Journey] will have its `id` field set.
  Future<Journey?> upsertRow(
    _is.DatabaseSession session,
    Journey row, {
    required _is.ColumnSelections<JourneyTable> conflictColumns,
    _is.ColumnSelections<JourneyTable>? updateColumns,
    _is.WhereExpressionBuilder<JourneyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Journey>(
      row,
      conflictColumns: conflictColumns(Journey.t),
      updateColumns: updateColumns?.call(Journey.t),
      updateWhere: updateWhere?.call(Journey.t),
      transaction: transaction,
    );
  }

  /// Updates all [Journey]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Journey>> update(
    _is.DatabaseSession session,
    List<Journey> rows, {
    _is.ColumnSelections<JourneyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Journey>(
      rows,
      columns: columns?.call(Journey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Journey]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Journey> updateRow(
    _is.DatabaseSession session,
    Journey row, {
    _is.ColumnSelections<JourneyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Journey>(
      row,
      columns: columns?.call(Journey.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Journey] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Journey?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<JourneyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Journey>(
      id,
      columnValues: columnValues(Journey.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Journey]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Journey>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<JourneyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<JourneyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyTable>? orderBy,
    _is.OrderByListBuilder<JourneyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Journey>(
      columnValues: columnValues(Journey.t.updateTable),
      where: where(Journey.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Journey.t),
      orderByList: orderByList?.call(Journey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Journey]s in the list and returns the deleted rows.
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
  Future<List<Journey>> delete(
    _is.DatabaseSession session,
    List<Journey> rows, {
    _is.OrderByBuilder<JourneyTable>? orderBy,
    _is.OrderByListBuilder<JourneyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Journey>(
      rows,
      orderBy: orderBy?.call(Journey.t),
      orderByList: orderByList?.call(Journey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Journey].
  Future<Journey> deleteRow(
    _is.DatabaseSession session,
    Journey row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Journey>(
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
  Future<List<Journey>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JourneyTable> where,
    _is.OrderByBuilder<JourneyTable>? orderBy,
    _is.OrderByListBuilder<JourneyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Journey>(
      where: where(Journey.t),
      orderBy: orderBy?.call(Journey.t),
      orderByList: orderByList?.call(Journey.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Journey>(
      where: where?.call(Journey.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Journey] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JourneyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Journey>(
      where: where(Journey.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
