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

/// The forecast snapshot saved with a journey, so a past trip keeps the summary
/// it was planned with even after the provider's data moved on.
abstract class JourneyWeatherPoint
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  JourneyWeatherPoint._({
    this.id,
    required this.journeyId,
    required this.seq,
    required this.sampleAt,
    required this.lat,
    required this.lon,
    this.label,
    this.weatherCode,
    this.weatherGroup,
    this.weatherId,
    this.tempC,
    this.precipitationMm,
    this.precipitationProbability,
    this.windSpeedKmh,
    this.severity,
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  factory JourneyWeatherPoint({
    _is.UuidValue? id,
    required _is.UuidValue journeyId,
    required int seq,
    required DateTime sampleAt,
    required double lat,
    required double lon,
    String? label,
    int? weatherCode,
    String? weatherGroup,
    int? weatherId,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    DateTime? fetchedAt,
  }) = _JourneyWeatherPointImpl;

  factory JourneyWeatherPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyWeatherPoint(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      journeyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['journeyId'],
      ),
      seq: jsonSerialization['seq'] as int,
      sampleAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['sampleAt'],
      ),
      lat: (jsonSerialization['lat'] as num).toDouble(),
      lon: (jsonSerialization['lon'] as num).toDouble(),
      label: jsonSerialization['label'] as String?,
      weatherCode: jsonSerialization['weatherCode'] as int?,
      weatherGroup: jsonSerialization['weatherGroup'] as String?,
      weatherId: jsonSerialization['weatherId'] as int?,
      tempC: (jsonSerialization['tempC'] as num?)?.toDouble(),
      precipitationMm: (jsonSerialization['precipitationMm'] as num?)
          ?.toDouble(),
      precipitationProbability:
          jsonSerialization['precipitationProbability'] as int?,
      windSpeedKmh: (jsonSerialization['windSpeedKmh'] as num?)?.toDouble(),
      severity: jsonSerialization['severity'] as String?,
      fetchedAt: jsonSerialization['fetchedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['fetchedAt']),
    );
  }

  static final t = JourneyWeatherPointTable();

  static const db = JourneyWeatherPointRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue journeyId;

  int seq;

  DateTime sampleAt;

  double lat;

  double lon;

  String? label;

  int? weatherCode;

  /// `weathers.code` group of [weatherCode].
  String? weatherGroup;

  int? weatherId;

  double? tempC;

  double? precipitationMm;

  int? precipitationProbability;

  double? windSpeedKmh;

  /// info | caution | warning
  String? severity;

  DateTime fetchedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [JourneyWeatherPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JourneyWeatherPoint copyWith({
    _is.UuidValue? id,
    _is.UuidValue? journeyId,
    int? seq,
    DateTime? sampleAt,
    double? lat,
    double? lon,
    String? label,
    int? weatherCode,
    String? weatherGroup,
    int? weatherId,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    DateTime? fetchedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyWeatherPoint',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'sampleAt': sampleAt.toJson(),
      'lat': lat,
      'lon': lon,
      if (label != null) 'label': label,
      if (weatherCode != null) 'weatherCode': weatherCode,
      if (weatherGroup != null) 'weatherGroup': weatherGroup,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempC != null) 'tempC': tempC,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      if (precipitationProbability != null)
        'precipitationProbability': precipitationProbability,
      if (windSpeedKmh != null) 'windSpeedKmh': windSpeedKmh,
      if (severity != null) 'severity': severity,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyWeatherPoint',
      if (id != null) 'id': id?.toJson(),
      'journeyId': journeyId.toJson(),
      'seq': seq,
      'sampleAt': sampleAt.toJson(),
      'lat': lat,
      'lon': lon,
      if (label != null) 'label': label,
      if (weatherCode != null) 'weatherCode': weatherCode,
      if (weatherGroup != null) 'weatherGroup': weatherGroup,
      if (weatherId != null) 'weatherId': weatherId,
      if (tempC != null) 'tempC': tempC,
      if (precipitationMm != null) 'precipitationMm': precipitationMm,
      if (precipitationProbability != null)
        'precipitationProbability': precipitationProbability,
      if (windSpeedKmh != null) 'windSpeedKmh': windSpeedKmh,
      if (severity != null) 'severity': severity,
      'fetchedAt': fetchedAt.toJson(),
    };
  }

  static JourneyWeatherPointInclude include() {
    return JourneyWeatherPointInclude._();
  }

  static JourneyWeatherPointIncludeList includeList({
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyWeatherPointTable>? orderBy,
    _is.OrderByListBuilder<JourneyWeatherPointTable>? orderByList,
    JourneyWeatherPointInclude? include,
  }) {
    return JourneyWeatherPointIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JourneyWeatherPoint.t),
      orderByList: orderByList?.call(JourneyWeatherPoint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyWeatherPointImpl extends JourneyWeatherPoint {
  _JourneyWeatherPointImpl({
    _is.UuidValue? id,
    required _is.UuidValue journeyId,
    required int seq,
    required DateTime sampleAt,
    required double lat,
    required double lon,
    String? label,
    int? weatherCode,
    String? weatherGroup,
    int? weatherId,
    double? tempC,
    double? precipitationMm,
    int? precipitationProbability,
    double? windSpeedKmh,
    String? severity,
    DateTime? fetchedAt,
  }) : super._(
         id: id,
         journeyId: journeyId,
         seq: seq,
         sampleAt: sampleAt,
         lat: lat,
         lon: lon,
         label: label,
         weatherCode: weatherCode,
         weatherGroup: weatherGroup,
         weatherId: weatherId,
         tempC: tempC,
         precipitationMm: precipitationMm,
         precipitationProbability: precipitationProbability,
         windSpeedKmh: windSpeedKmh,
         severity: severity,
         fetchedAt: fetchedAt,
       );

  /// Returns a shallow copy of this [JourneyWeatherPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JourneyWeatherPoint copyWith({
    Object? id = _Undefined,
    _is.UuidValue? journeyId,
    int? seq,
    DateTime? sampleAt,
    double? lat,
    double? lon,
    Object? label = _Undefined,
    Object? weatherCode = _Undefined,
    Object? weatherGroup = _Undefined,
    Object? weatherId = _Undefined,
    Object? tempC = _Undefined,
    Object? precipitationMm = _Undefined,
    Object? precipitationProbability = _Undefined,
    Object? windSpeedKmh = _Undefined,
    Object? severity = _Undefined,
    DateTime? fetchedAt,
  }) {
    return JourneyWeatherPoint(
      id: id is _is.UuidValue? ? id : this.id,
      journeyId: journeyId ?? this.journeyId,
      seq: seq ?? this.seq,
      sampleAt: sampleAt ?? this.sampleAt,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      label: label is String? ? label : this.label,
      weatherCode: weatherCode is int? ? weatherCode : this.weatherCode,
      weatherGroup: weatherGroup is String? ? weatherGroup : this.weatherGroup,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      tempC: tempC is double? ? tempC : this.tempC,
      precipitationMm: precipitationMm is double?
          ? precipitationMm
          : this.precipitationMm,
      precipitationProbability: precipitationProbability is int?
          ? precipitationProbability
          : this.precipitationProbability,
      windSpeedKmh: windSpeedKmh is double? ? windSpeedKmh : this.windSpeedKmh,
      severity: severity is String? ? severity : this.severity,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }
}

class JourneyWeatherPointUpdateTable
    extends _is.UpdateTable<JourneyWeatherPointTable> {
  JourneyWeatherPointUpdateTable(super.table);

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

  _is.ColumnValue<DateTime, DateTime> sampleAt(DateTime value) =>
      _is.ColumnValue(
        table.sampleAt,
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

  _is.ColumnValue<String, String> label(String? value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<int, int> weatherCode(int? value) => _is.ColumnValue(
    table.weatherCode,
    value,
  );

  _is.ColumnValue<String, String> weatherGroup(String? value) =>
      _is.ColumnValue(
        table.weatherGroup,
        value,
      );

  _is.ColumnValue<int, int> weatherId(int? value) => _is.ColumnValue(
    table.weatherId,
    value,
  );

  _is.ColumnValue<double, double> tempC(double? value) => _is.ColumnValue(
    table.tempC,
    value,
  );

  _is.ColumnValue<double, double> precipitationMm(double? value) =>
      _is.ColumnValue(
        table.precipitationMm,
        value,
      );

  _is.ColumnValue<int, int> precipitationProbability(int? value) =>
      _is.ColumnValue(
        table.precipitationProbability,
        value,
      );

  _is.ColumnValue<double, double> windSpeedKmh(double? value) =>
      _is.ColumnValue(
        table.windSpeedKmh,
        value,
      );

  _is.ColumnValue<String, String> severity(String? value) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> fetchedAt(DateTime value) =>
      _is.ColumnValue(
        table.fetchedAt,
        value,
      );
}

class JourneyWeatherPointTable extends _is.Table<_is.UuidValue?> {
  JourneyWeatherPointTable({super.tableRelation})
    : super(tableName: 'journey_weather_points') {
    updateTable = JourneyWeatherPointUpdateTable(this);
    journeyId = _is.ColumnUuid(
      'journeyId',
      this,
    );
    seq = _is.ColumnInt(
      'seq',
      this,
    );
    sampleAt = _is.ColumnDateTime(
      'sampleAt',
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
    label = _is.ColumnString(
      'label',
      this,
    );
    weatherCode = _is.ColumnInt(
      'weatherCode',
      this,
    );
    weatherGroup = _is.ColumnString(
      'weatherGroup',
      this,
    );
    weatherId = _is.ColumnInt(
      'weatherId',
      this,
    );
    tempC = _is.ColumnDouble(
      'tempC',
      this,
    );
    precipitationMm = _is.ColumnDouble(
      'precipitationMm',
      this,
    );
    precipitationProbability = _is.ColumnInt(
      'precipitationProbability',
      this,
    );
    windSpeedKmh = _is.ColumnDouble(
      'windSpeedKmh',
      this,
    );
    severity = _is.ColumnString(
      'severity',
      this,
    );
    fetchedAt = _is.ColumnDateTime(
      'fetchedAt',
      this,
      hasDefault: true,
    );
  }

  late final JourneyWeatherPointUpdateTable updateTable;

  late final _is.ColumnUuid journeyId;

  late final _is.ColumnInt seq;

  late final _is.ColumnDateTime sampleAt;

  late final _is.ColumnDouble lat;

  late final _is.ColumnDouble lon;

  late final _is.ColumnString label;

  late final _is.ColumnInt weatherCode;

  /// `weathers.code` group of [weatherCode].
  late final _is.ColumnString weatherGroup;

  late final _is.ColumnInt weatherId;

  late final _is.ColumnDouble tempC;

  late final _is.ColumnDouble precipitationMm;

  late final _is.ColumnInt precipitationProbability;

  late final _is.ColumnDouble windSpeedKmh;

  /// info | caution | warning
  late final _is.ColumnString severity;

  late final _is.ColumnDateTime fetchedAt;

  @override
  List<_is.Column> get columns => [
    id,
    journeyId,
    seq,
    sampleAt,
    lat,
    lon,
    label,
    weatherCode,
    weatherGroup,
    weatherId,
    tempC,
    precipitationMm,
    precipitationProbability,
    windSpeedKmh,
    severity,
    fetchedAt,
  ];
}

class JourneyWeatherPointInclude extends _is.IncludeObject {
  JourneyWeatherPointInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => JourneyWeatherPoint.t;
}

class JourneyWeatherPointIncludeList extends _is.IncludeList {
  JourneyWeatherPointIncludeList._({
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JourneyWeatherPoint.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => JourneyWeatherPoint.t;
}

class JourneyWeatherPointRepository {
  const JourneyWeatherPointRepository._();

  /// Returns a list of [JourneyWeatherPoint]s matching the given query parameters.
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
  Future<List<JourneyWeatherPoint>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyWeatherPointTable>? orderBy,
    _is.OrderByListBuilder<JourneyWeatherPointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<JourneyWeatherPoint>(
      where: where?.call(JourneyWeatherPoint.t),
      orderBy: orderBy?.call(JourneyWeatherPoint.t),
      orderByList: orderByList?.call(JourneyWeatherPoint.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [JourneyWeatherPoint] matching the given query parameters.
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
  Future<JourneyWeatherPoint?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? where,
    int? offset,
    _is.OrderByBuilder<JourneyWeatherPointTable>? orderBy,
    _is.OrderByListBuilder<JourneyWeatherPointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<JourneyWeatherPoint>(
      where: where?.call(JourneyWeatherPoint.t),
      orderBy: orderBy?.call(JourneyWeatherPoint.t),
      orderByList: orderByList?.call(JourneyWeatherPoint.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [JourneyWeatherPoint] by its [id] or null if no such row exists.
  Future<JourneyWeatherPoint?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<JourneyWeatherPoint>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [JourneyWeatherPoint]s in the list and returns the inserted rows.
  ///
  /// The returned [JourneyWeatherPoint]s will have their `id` fields set.
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
  Future<List<JourneyWeatherPoint>> insert(
    _is.DatabaseSession session,
    List<JourneyWeatherPoint> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<JourneyWeatherPoint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [JourneyWeatherPoint] and returns the inserted row.
  ///
  /// The returned [JourneyWeatherPoint] will have its `id` field set.
  Future<JourneyWeatherPoint> insertRow(
    _is.DatabaseSession session,
    JourneyWeatherPoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<JourneyWeatherPoint>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [JourneyWeatherPoint]s in the list and returns the resulting rows.
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
  /// The returned [JourneyWeatherPoint]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JourneyWeatherPoint>> upsert(
    _is.DatabaseSession session,
    List<JourneyWeatherPoint> rows, {
    required _is.ColumnSelections<JourneyWeatherPointTable> conflictColumns,
    _is.ColumnSelections<JourneyWeatherPointTable>? updateColumns,
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<JourneyWeatherPoint>(
      rows,
      conflictColumns: conflictColumns(JourneyWeatherPoint.t),
      updateColumns: updateColumns?.call(JourneyWeatherPoint.t),
      updateWhere: updateWhere?.call(JourneyWeatherPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [JourneyWeatherPoint] and returns the resulting row.
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
  /// The returned [JourneyWeatherPoint] will have its `id` field set.
  Future<JourneyWeatherPoint?> upsertRow(
    _is.DatabaseSession session,
    JourneyWeatherPoint row, {
    required _is.ColumnSelections<JourneyWeatherPointTable> conflictColumns,
    _is.ColumnSelections<JourneyWeatherPointTable>? updateColumns,
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<JourneyWeatherPoint>(
      row,
      conflictColumns: conflictColumns(JourneyWeatherPoint.t),
      updateColumns: updateColumns?.call(JourneyWeatherPoint.t),
      updateWhere: updateWhere?.call(JourneyWeatherPoint.t),
      transaction: transaction,
    );
  }

  /// Updates all [JourneyWeatherPoint]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JourneyWeatherPoint>> update(
    _is.DatabaseSession session,
    List<JourneyWeatherPoint> rows, {
    _is.ColumnSelections<JourneyWeatherPointTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<JourneyWeatherPoint>(
      rows,
      columns: columns?.call(JourneyWeatherPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [JourneyWeatherPoint]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JourneyWeatherPoint> updateRow(
    _is.DatabaseSession session,
    JourneyWeatherPoint row, {
    _is.ColumnSelections<JourneyWeatherPointTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<JourneyWeatherPoint>(
      row,
      columns: columns?.call(JourneyWeatherPoint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JourneyWeatherPoint] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JourneyWeatherPoint?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<JourneyWeatherPointUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<JourneyWeatherPoint>(
      id,
      columnValues: columnValues(JourneyWeatherPoint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JourneyWeatherPoint]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JourneyWeatherPoint>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<JourneyWeatherPointUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<JourneyWeatherPointTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JourneyWeatherPointTable>? orderBy,
    _is.OrderByListBuilder<JourneyWeatherPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<JourneyWeatherPoint>(
      columnValues: columnValues(JourneyWeatherPoint.t.updateTable),
      where: where(JourneyWeatherPoint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JourneyWeatherPoint.t),
      orderByList: orderByList?.call(JourneyWeatherPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [JourneyWeatherPoint]s in the list and returns the deleted rows.
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
  Future<List<JourneyWeatherPoint>> delete(
    _is.DatabaseSession session,
    List<JourneyWeatherPoint> rows, {
    _is.OrderByBuilder<JourneyWeatherPointTable>? orderBy,
    _is.OrderByListBuilder<JourneyWeatherPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<JourneyWeatherPoint>(
      rows,
      orderBy: orderBy?.call(JourneyWeatherPoint.t),
      orderByList: orderByList?.call(JourneyWeatherPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [JourneyWeatherPoint].
  Future<JourneyWeatherPoint> deleteRow(
    _is.DatabaseSession session,
    JourneyWeatherPoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JourneyWeatherPoint>(
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
  Future<List<JourneyWeatherPoint>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JourneyWeatherPointTable> where,
    _is.OrderByBuilder<JourneyWeatherPointTable>? orderBy,
    _is.OrderByListBuilder<JourneyWeatherPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<JourneyWeatherPoint>(
      where: where(JourneyWeatherPoint.t),
      orderBy: orderBy?.call(JourneyWeatherPoint.t),
      orderByList: orderByList?.call(JourneyWeatherPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JourneyWeatherPointTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<JourneyWeatherPoint>(
      where: where?.call(JourneyWeatherPoint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [JourneyWeatherPoint] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JourneyWeatherPointTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<JourneyWeatherPoint>(
      where: where(JourneyWeatherPoint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
