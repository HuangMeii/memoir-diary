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

/// Daily health tracking. One row per user per day.
abstract class HealthLog
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  HealthLog._({
    this.id,
    required this.userId,
    required this.logDate,
    this.steps,
    this.workoutMinutes,
    this.waterMl,
    this.sleepHours,
    this.weightKg,
    this.note,
    this.workoutType,
    this.workoutIntensity,
    this.sleepBedtime,
    this.sleepWake,
    this.sleepDeepMinutes,
    this.sleepQuality,
    this.sleepNote,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory HealthLog({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
    String? workoutType,
    String? workoutIntensity,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    DateTime? createdAt,
  }) = _HealthLogImpl;

  factory HealthLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthLog(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      logDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['logDate']),
      steps: jsonSerialization['steps'] as int?,
      workoutMinutes: jsonSerialization['workoutMinutes'] as int?,
      waterMl: jsonSerialization['waterMl'] as int?,
      sleepHours: (jsonSerialization['sleepHours'] as num?)?.toDouble(),
      weightKg: (jsonSerialization['weightKg'] as num?)?.toDouble(),
      note: jsonSerialization['note'] as String?,
      workoutType: jsonSerialization['workoutType'] as String?,
      workoutIntensity: jsonSerialization['workoutIntensity'] as String?,
      sleepBedtime: jsonSerialization['sleepBedtime'] as String?,
      sleepWake: jsonSerialization['sleepWake'] as String?,
      sleepDeepMinutes: jsonSerialization['sleepDeepMinutes'] as int?,
      sleepQuality: jsonSerialization['sleepQuality'] as String?,
      sleepNote: jsonSerialization['sleepNote'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = HealthLogTable();

  static const db = HealthLogRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  DateTime logDate;

  int? steps;

  int? workoutMinutes;

  int? waterMl;

  double? sleepHours;

  double? weightKg;

  String? note;

  /// Workout (ghi nhận nhanh tập luyện)
  String? workoutType;

  String? workoutIntensity;

  /// Sleep (ghi nhận nhanh giấc ngủ)
  String? sleepBedtime;

  String? sleepWake;

  int? sleepDeepMinutes;

  String? sleepQuality;

  String? sleepNote;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [HealthLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthLog copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    DateTime? logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
    String? workoutType,
    String? workoutIntensity,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthLog',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      if (steps != null) 'steps': steps,
      if (workoutMinutes != null) 'workoutMinutes': workoutMinutes,
      if (waterMl != null) 'waterMl': waterMl,
      if (sleepHours != null) 'sleepHours': sleepHours,
      if (weightKg != null) 'weightKg': weightKg,
      if (note != null) 'note': note,
      if (workoutType != null) 'workoutType': workoutType,
      if (workoutIntensity != null) 'workoutIntensity': workoutIntensity,
      if (sleepBedtime != null) 'sleepBedtime': sleepBedtime,
      if (sleepWake != null) 'sleepWake': sleepWake,
      if (sleepDeepMinutes != null) 'sleepDeepMinutes': sleepDeepMinutes,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (sleepNote != null) 'sleepNote': sleepNote,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthLog',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'logDate': logDate.toJson(),
      if (steps != null) 'steps': steps,
      if (workoutMinutes != null) 'workoutMinutes': workoutMinutes,
      if (waterMl != null) 'waterMl': waterMl,
      if (sleepHours != null) 'sleepHours': sleepHours,
      if (weightKg != null) 'weightKg': weightKg,
      if (note != null) 'note': note,
      if (workoutType != null) 'workoutType': workoutType,
      if (workoutIntensity != null) 'workoutIntensity': workoutIntensity,
      if (sleepBedtime != null) 'sleepBedtime': sleepBedtime,
      if (sleepWake != null) 'sleepWake': sleepWake,
      if (sleepDeepMinutes != null) 'sleepDeepMinutes': sleepDeepMinutes,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (sleepNote != null) 'sleepNote': sleepNote,
      'createdAt': createdAt.toJson(),
    };
  }

  static HealthLogInclude include() {
    return HealthLogInclude._();
  }

  static HealthLogIncludeList includeList({
    _is.WhereExpressionBuilder<HealthLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthLogTable>? orderBy,
    _is.OrderByListBuilder<HealthLogTable>? orderByList,
    HealthLogInclude? include,
  }) {
    return HealthLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthLog.t),
      orderByList: orderByList?.call(HealthLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthLogImpl extends HealthLog {
  _HealthLogImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
    String? workoutType,
    String? workoutIntensity,
    String? sleepBedtime,
    String? sleepWake,
    int? sleepDeepMinutes,
    String? sleepQuality,
    String? sleepNote,
    DateTime? createdAt,
  }) : super._(
         id: id,
         userId: userId,
         logDate: logDate,
         steps: steps,
         workoutMinutes: workoutMinutes,
         waterMl: waterMl,
         sleepHours: sleepHours,
         weightKg: weightKg,
         note: note,
         workoutType: workoutType,
         workoutIntensity: workoutIntensity,
         sleepBedtime: sleepBedtime,
         sleepWake: sleepWake,
         sleepDeepMinutes: sleepDeepMinutes,
         sleepQuality: sleepQuality,
         sleepNote: sleepNote,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthLog copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? logDate,
    Object? steps = _Undefined,
    Object? workoutMinutes = _Undefined,
    Object? waterMl = _Undefined,
    Object? sleepHours = _Undefined,
    Object? weightKg = _Undefined,
    Object? note = _Undefined,
    Object? workoutType = _Undefined,
    Object? workoutIntensity = _Undefined,
    Object? sleepBedtime = _Undefined,
    Object? sleepWake = _Undefined,
    Object? sleepDeepMinutes = _Undefined,
    Object? sleepQuality = _Undefined,
    Object? sleepNote = _Undefined,
    DateTime? createdAt,
  }) {
    return HealthLog(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      steps: steps is int? ? steps : this.steps,
      workoutMinutes: workoutMinutes is int?
          ? workoutMinutes
          : this.workoutMinutes,
      waterMl: waterMl is int? ? waterMl : this.waterMl,
      sleepHours: sleepHours is double? ? sleepHours : this.sleepHours,
      weightKg: weightKg is double? ? weightKg : this.weightKg,
      note: note is String? ? note : this.note,
      workoutType: workoutType is String? ? workoutType : this.workoutType,
      workoutIntensity: workoutIntensity is String?
          ? workoutIntensity
          : this.workoutIntensity,
      sleepBedtime: sleepBedtime is String? ? sleepBedtime : this.sleepBedtime,
      sleepWake: sleepWake is String? ? sleepWake : this.sleepWake,
      sleepDeepMinutes: sleepDeepMinutes is int?
          ? sleepDeepMinutes
          : this.sleepDeepMinutes,
      sleepQuality: sleepQuality is String? ? sleepQuality : this.sleepQuality,
      sleepNote: sleepNote is String? ? sleepNote : this.sleepNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HealthLogUpdateTable extends _is.UpdateTable<HealthLogTable> {
  HealthLogUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> logDate(DateTime value) =>
      _is.ColumnValue(
        table.logDate,
        value,
      );

  _is.ColumnValue<int, int> steps(int? value) => _is.ColumnValue(
    table.steps,
    value,
  );

  _is.ColumnValue<int, int> workoutMinutes(int? value) => _is.ColumnValue(
    table.workoutMinutes,
    value,
  );

  _is.ColumnValue<int, int> waterMl(int? value) => _is.ColumnValue(
    table.waterMl,
    value,
  );

  _is.ColumnValue<double, double> sleepHours(double? value) => _is.ColumnValue(
    table.sleepHours,
    value,
  );

  _is.ColumnValue<double, double> weightKg(double? value) => _is.ColumnValue(
    table.weightKg,
    value,
  );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<String, String> workoutType(String? value) => _is.ColumnValue(
    table.workoutType,
    value,
  );

  _is.ColumnValue<String, String> workoutIntensity(String? value) =>
      _is.ColumnValue(
        table.workoutIntensity,
        value,
      );

  _is.ColumnValue<String, String> sleepBedtime(String? value) =>
      _is.ColumnValue(
        table.sleepBedtime,
        value,
      );

  _is.ColumnValue<String, String> sleepWake(String? value) => _is.ColumnValue(
    table.sleepWake,
    value,
  );

  _is.ColumnValue<int, int> sleepDeepMinutes(int? value) => _is.ColumnValue(
    table.sleepDeepMinutes,
    value,
  );

  _is.ColumnValue<String, String> sleepQuality(String? value) =>
      _is.ColumnValue(
        table.sleepQuality,
        value,
      );

  _is.ColumnValue<String, String> sleepNote(String? value) => _is.ColumnValue(
    table.sleepNote,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class HealthLogTable extends _is.Table<_is.UuidValue?> {
  HealthLogTable({super.tableRelation}) : super(tableName: 'health_logs') {
    updateTable = HealthLogUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    logDate = _is.ColumnDateTime(
      'logDate',
      this,
    );
    steps = _is.ColumnInt(
      'steps',
      this,
    );
    workoutMinutes = _is.ColumnInt(
      'workoutMinutes',
      this,
    );
    waterMl = _is.ColumnInt(
      'waterMl',
      this,
    );
    sleepHours = _is.ColumnDouble(
      'sleepHours',
      this,
    );
    weightKg = _is.ColumnDouble(
      'weightKg',
      this,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    workoutType = _is.ColumnString(
      'workoutType',
      this,
    );
    workoutIntensity = _is.ColumnString(
      'workoutIntensity',
      this,
    );
    sleepBedtime = _is.ColumnString(
      'sleepBedtime',
      this,
    );
    sleepWake = _is.ColumnString(
      'sleepWake',
      this,
    );
    sleepDeepMinutes = _is.ColumnInt(
      'sleepDeepMinutes',
      this,
    );
    sleepQuality = _is.ColumnString(
      'sleepQuality',
      this,
    );
    sleepNote = _is.ColumnString(
      'sleepNote',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final HealthLogUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  late final _is.ColumnDateTime logDate;

  late final _is.ColumnInt steps;

  late final _is.ColumnInt workoutMinutes;

  late final _is.ColumnInt waterMl;

  late final _is.ColumnDouble sleepHours;

  late final _is.ColumnDouble weightKg;

  late final _is.ColumnString note;

  /// Workout (ghi nhận nhanh tập luyện)
  late final _is.ColumnString workoutType;

  late final _is.ColumnString workoutIntensity;

  /// Sleep (ghi nhận nhanh giấc ngủ)
  late final _is.ColumnString sleepBedtime;

  late final _is.ColumnString sleepWake;

  late final _is.ColumnInt sleepDeepMinutes;

  late final _is.ColumnString sleepQuality;

  late final _is.ColumnString sleepNote;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    logDate,
    steps,
    workoutMinutes,
    waterMl,
    sleepHours,
    weightKg,
    note,
    workoutType,
    workoutIntensity,
    sleepBedtime,
    sleepWake,
    sleepDeepMinutes,
    sleepQuality,
    sleepNote,
    createdAt,
  ];
}

class HealthLogInclude extends _is.IncludeObject {
  HealthLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthLog.t;
}

class HealthLogIncludeList extends _is.IncludeList {
  HealthLogIncludeList._({
    _is.WhereExpressionBuilder<HealthLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HealthLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthLog.t;
}

class HealthLogRepository {
  const HealthLogRepository._();

  /// Returns a list of [HealthLog]s matching the given query parameters.
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
  Future<List<HealthLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthLogTable>? orderBy,
    _is.OrderByListBuilder<HealthLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HealthLog>(
      where: where?.call(HealthLog.t),
      orderBy: orderBy?.call(HealthLog.t),
      orderByList: orderByList?.call(HealthLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HealthLog] matching the given query parameters.
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
  Future<HealthLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthLogTable>? where,
    int? offset,
    _is.OrderByBuilder<HealthLogTable>? orderBy,
    _is.OrderByListBuilder<HealthLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HealthLog>(
      where: where?.call(HealthLog.t),
      orderBy: orderBy?.call(HealthLog.t),
      orderByList: orderByList?.call(HealthLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HealthLog] by its [id] or null if no such row exists.
  Future<HealthLog?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HealthLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HealthLog]s in the list and returns the inserted rows.
  ///
  /// The returned [HealthLog]s will have their `id` fields set.
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
  Future<List<HealthLog>> insert(
    _is.DatabaseSession session,
    List<HealthLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<HealthLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [HealthLog] and returns the inserted row.
  ///
  /// The returned [HealthLog] will have its `id` field set.
  Future<HealthLog> insertRow(
    _is.DatabaseSession session,
    HealthLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<HealthLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [HealthLog]s in the list and returns the resulting rows.
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
  /// The returned [HealthLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthLog>> upsert(
    _is.DatabaseSession session,
    List<HealthLog> rows, {
    required _is.ColumnSelections<HealthLogTable> conflictColumns,
    _is.ColumnSelections<HealthLogTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<HealthLog>(
      rows,
      conflictColumns: conflictColumns(HealthLog.t),
      updateColumns: updateColumns?.call(HealthLog.t),
      updateWhere: updateWhere?.call(HealthLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [HealthLog] and returns the resulting row.
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
  /// The returned [HealthLog] will have its `id` field set.
  Future<HealthLog?> upsertRow(
    _is.DatabaseSession session,
    HealthLog row, {
    required _is.ColumnSelections<HealthLogTable> conflictColumns,
    _is.ColumnSelections<HealthLogTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<HealthLog>(
      row,
      conflictColumns: conflictColumns(HealthLog.t),
      updateColumns: updateColumns?.call(HealthLog.t),
      updateWhere: updateWhere?.call(HealthLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [HealthLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthLog>> update(
    _is.DatabaseSession session,
    List<HealthLog> rows, {
    _is.ColumnSelections<HealthLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<HealthLog>(
      rows,
      columns: columns?.call(HealthLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [HealthLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HealthLog> updateRow(
    _is.DatabaseSession session,
    HealthLog row, {
    _is.ColumnSelections<HealthLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<HealthLog>(
      row,
      columns: columns?.call(HealthLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HealthLog?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<HealthLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<HealthLog>(
      id,
      columnValues: columnValues(HealthLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HealthLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<HealthLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<HealthLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthLogTable>? orderBy,
    _is.OrderByListBuilder<HealthLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<HealthLog>(
      columnValues: columnValues(HealthLog.t.updateTable),
      where: where(HealthLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthLog.t),
      orderByList: orderByList?.call(HealthLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [HealthLog]s in the list and returns the deleted rows.
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
  Future<List<HealthLog>> delete(
    _is.DatabaseSession session,
    List<HealthLog> rows, {
    _is.OrderByBuilder<HealthLogTable>? orderBy,
    _is.OrderByListBuilder<HealthLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<HealthLog>(
      rows,
      orderBy: orderBy?.call(HealthLog.t),
      orderByList: orderByList?.call(HealthLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [HealthLog].
  Future<HealthLog> deleteRow(
    _is.DatabaseSession session,
    HealthLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HealthLog>(
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
  Future<List<HealthLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthLogTable> where,
    _is.OrderByBuilder<HealthLogTable>? orderBy,
    _is.OrderByListBuilder<HealthLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<HealthLog>(
      where: where(HealthLog.t),
      orderBy: orderBy?.call(HealthLog.t),
      orderByList: orderByList?.call(HealthLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<HealthLog>(
      where: where?.call(HealthLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HealthLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HealthLog>(
      where: where(HealthLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
