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

/// Health body measurements and daily goals. One row per user.
abstract class HealthProfile
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  HealthProfile._({
    this.id,
    required this.userId,
    this.heightCm,
    this.weightGoalKg,
    this.weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) : stepsGoal = stepsGoal ?? 8000,
       workoutGoalMinutes = workoutGoalMinutes ?? 60,
       waterGoalMl = waterGoalMl ?? 2000,
       sleepGoalHours = sleepGoalHours ?? 8.0,
       updatedAt = updatedAt ?? DateTime.now();

  factory HealthProfile({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) = _HealthProfileImpl;

  factory HealthProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthProfile(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      heightCm: jsonSerialization['heightCm'] as int?,
      weightGoalKg: (jsonSerialization['weightGoalKg'] as num?)?.toDouble(),
      weightStartKg: (jsonSerialization['weightStartKg'] as num?)?.toDouble(),
      stepsGoal: jsonSerialization['stepsGoal'] as int?,
      workoutGoalMinutes: jsonSerialization['workoutGoalMinutes'] as int?,
      waterGoalMl: jsonSerialization['waterGoalMl'] as int?,
      sleepGoalHours: (jsonSerialization['sleepGoalHours'] as num?)?.toDouble(),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = HealthProfileTable();

  static const db = HealthProfileRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  /// Body metrics; height feeds BMI/BMR, so it is stored once.
  int? heightCm;

  double? weightGoalKg;

  double? weightStartKg;

  /// Daily goals shown on the dashboard hero cards.
  int stepsGoal;

  int workoutGoalMinutes;

  int waterGoalMl;

  double sleepGoalHours;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [HealthProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  HealthProfile copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (heightCm != null) 'heightCm': heightCm,
      if (weightGoalKg != null) 'weightGoalKg': weightGoalKg,
      if (weightStartKg != null) 'weightStartKg': weightStartKg,
      'stepsGoal': stepsGoal,
      'workoutGoalMinutes': workoutGoalMinutes,
      'waterGoalMl': waterGoalMl,
      'sleepGoalHours': sleepGoalHours,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthProfile',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (heightCm != null) 'heightCm': heightCm,
      if (weightGoalKg != null) 'weightGoalKg': weightGoalKg,
      if (weightStartKg != null) 'weightStartKg': weightStartKg,
      'stepsGoal': stepsGoal,
      'workoutGoalMinutes': workoutGoalMinutes,
      'waterGoalMl': waterGoalMl,
      'sleepGoalHours': sleepGoalHours,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static HealthProfileInclude include() {
    return HealthProfileInclude._();
  }

  static HealthProfileIncludeList includeList({
    _is.WhereExpressionBuilder<HealthProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthProfileTable>? orderBy,
    _is.OrderByListBuilder<HealthProfileTable>? orderByList,
    HealthProfileInclude? include,
  }) {
    return HealthProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthProfile.t),
      orderByList: orderByList?.call(HealthProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthProfileImpl extends HealthProfile {
  _HealthProfileImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    int? heightCm,
    double? weightGoalKg,
    double? weightStartKg,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         heightCm: heightCm,
         weightGoalKg: weightGoalKg,
         weightStartKg: weightStartKg,
         stepsGoal: stepsGoal,
         workoutGoalMinutes: workoutGoalMinutes,
         waterGoalMl: waterGoalMl,
         sleepGoalHours: sleepGoalHours,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HealthProfile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  HealthProfile copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    Object? heightCm = _Undefined,
    Object? weightGoalKg = _Undefined,
    Object? weightStartKg = _Undefined,
    int? stepsGoal,
    int? workoutGoalMinutes,
    int? waterGoalMl,
    double? sleepGoalHours,
    DateTime? updatedAt,
  }) {
    return HealthProfile(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      heightCm: heightCm is int? ? heightCm : this.heightCm,
      weightGoalKg: weightGoalKg is double? ? weightGoalKg : this.weightGoalKg,
      weightStartKg: weightStartKg is double?
          ? weightStartKg
          : this.weightStartKg,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      workoutGoalMinutes: workoutGoalMinutes ?? this.workoutGoalMinutes,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      sleepGoalHours: sleepGoalHours ?? this.sleepGoalHours,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class HealthProfileUpdateTable extends _is.UpdateTable<HealthProfileTable> {
  HealthProfileUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<int, int> heightCm(int? value) => _is.ColumnValue(
    table.heightCm,
    value,
  );

  _is.ColumnValue<double, double> weightGoalKg(double? value) =>
      _is.ColumnValue(
        table.weightGoalKg,
        value,
      );

  _is.ColumnValue<double, double> weightStartKg(double? value) =>
      _is.ColumnValue(
        table.weightStartKg,
        value,
      );

  _is.ColumnValue<int, int> stepsGoal(int value) => _is.ColumnValue(
    table.stepsGoal,
    value,
  );

  _is.ColumnValue<int, int> workoutGoalMinutes(int value) => _is.ColumnValue(
    table.workoutGoalMinutes,
    value,
  );

  _is.ColumnValue<int, int> waterGoalMl(int value) => _is.ColumnValue(
    table.waterGoalMl,
    value,
  );

  _is.ColumnValue<double, double> sleepGoalHours(double value) =>
      _is.ColumnValue(
        table.sleepGoalHours,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class HealthProfileTable extends _is.Table<_is.UuidValue?> {
  HealthProfileTable({super.tableRelation})
    : super(tableName: 'health_profiles') {
    updateTable = HealthProfileUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    heightCm = _is.ColumnInt(
      'heightCm',
      this,
    );
    weightGoalKg = _is.ColumnDouble(
      'weightGoalKg',
      this,
    );
    weightStartKg = _is.ColumnDouble(
      'weightStartKg',
      this,
    );
    stepsGoal = _is.ColumnInt(
      'stepsGoal',
      this,
      hasDefault: true,
    );
    workoutGoalMinutes = _is.ColumnInt(
      'workoutGoalMinutes',
      this,
      hasDefault: true,
    );
    waterGoalMl = _is.ColumnInt(
      'waterGoalMl',
      this,
      hasDefault: true,
    );
    sleepGoalHours = _is.ColumnDouble(
      'sleepGoalHours',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final HealthProfileUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  /// Body metrics; height feeds BMI/BMR, so it is stored once.
  late final _is.ColumnInt heightCm;

  late final _is.ColumnDouble weightGoalKg;

  late final _is.ColumnDouble weightStartKg;

  /// Daily goals shown on the dashboard hero cards.
  late final _is.ColumnInt stepsGoal;

  late final _is.ColumnInt workoutGoalMinutes;

  late final _is.ColumnInt waterGoalMl;

  late final _is.ColumnDouble sleepGoalHours;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    heightCm,
    weightGoalKg,
    weightStartKg,
    stepsGoal,
    workoutGoalMinutes,
    waterGoalMl,
    sleepGoalHours,
    updatedAt,
  ];
}

class HealthProfileInclude extends _is.IncludeObject {
  HealthProfileInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthProfile.t;
}

class HealthProfileIncludeList extends _is.IncludeList {
  HealthProfileIncludeList._({
    _is.WhereExpressionBuilder<HealthProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HealthProfile.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => HealthProfile.t;
}

class HealthProfileRepository {
  const HealthProfileRepository._();

  /// Returns a list of [HealthProfile]s matching the given query parameters.
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
  Future<List<HealthProfile>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthProfileTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthProfileTable>? orderBy,
    _is.OrderByListBuilder<HealthProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HealthProfile>(
      where: where?.call(HealthProfile.t),
      orderBy: orderBy?.call(HealthProfile.t),
      orderByList: orderByList?.call(HealthProfile.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HealthProfile] matching the given query parameters.
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
  Future<HealthProfile?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthProfileTable>? where,
    int? offset,
    _is.OrderByBuilder<HealthProfileTable>? orderBy,
    _is.OrderByListBuilder<HealthProfileTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HealthProfile>(
      where: where?.call(HealthProfile.t),
      orderBy: orderBy?.call(HealthProfile.t),
      orderByList: orderByList?.call(HealthProfile.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HealthProfile] by its [id] or null if no such row exists.
  Future<HealthProfile?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HealthProfile>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HealthProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [HealthProfile]s will have their `id` fields set.
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
  Future<List<HealthProfile>> insert(
    _is.DatabaseSession session,
    List<HealthProfile> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<HealthProfile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [HealthProfile] and returns the inserted row.
  ///
  /// The returned [HealthProfile] will have its `id` field set.
  Future<HealthProfile> insertRow(
    _is.DatabaseSession session,
    HealthProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<HealthProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [HealthProfile]s in the list and returns the resulting rows.
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
  /// The returned [HealthProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthProfile>> upsert(
    _is.DatabaseSession session,
    List<HealthProfile> rows, {
    required _is.ColumnSelections<HealthProfileTable> conflictColumns,
    _is.ColumnSelections<HealthProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthProfileTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<HealthProfile>(
      rows,
      conflictColumns: conflictColumns(HealthProfile.t),
      updateColumns: updateColumns?.call(HealthProfile.t),
      updateWhere: updateWhere?.call(HealthProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [HealthProfile] and returns the resulting row.
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
  /// The returned [HealthProfile] will have its `id` field set.
  Future<HealthProfile?> upsertRow(
    _is.DatabaseSession session,
    HealthProfile row, {
    required _is.ColumnSelections<HealthProfileTable> conflictColumns,
    _is.ColumnSelections<HealthProfileTable>? updateColumns,
    _is.WhereExpressionBuilder<HealthProfileTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<HealthProfile>(
      row,
      conflictColumns: conflictColumns(HealthProfile.t),
      updateColumns: updateColumns?.call(HealthProfile.t),
      updateWhere: updateWhere?.call(HealthProfile.t),
      transaction: transaction,
    );
  }

  /// Updates all [HealthProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthProfile>> update(
    _is.DatabaseSession session,
    List<HealthProfile> rows, {
    _is.ColumnSelections<HealthProfileTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<HealthProfile>(
      rows,
      columns: columns?.call(HealthProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [HealthProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HealthProfile> updateRow(
    _is.DatabaseSession session,
    HealthProfile row, {
    _is.ColumnSelections<HealthProfileTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<HealthProfile>(
      row,
      columns: columns?.call(HealthProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HealthProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HealthProfile?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<HealthProfileUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<HealthProfile>(
      id,
      columnValues: columnValues(HealthProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HealthProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<HealthProfile>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<HealthProfileUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<HealthProfileTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<HealthProfileTable>? orderBy,
    _is.OrderByListBuilder<HealthProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<HealthProfile>(
      columnValues: columnValues(HealthProfile.t.updateTable),
      where: where(HealthProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HealthProfile.t),
      orderByList: orderByList?.call(HealthProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [HealthProfile]s in the list and returns the deleted rows.
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
  Future<List<HealthProfile>> delete(
    _is.DatabaseSession session,
    List<HealthProfile> rows, {
    _is.OrderByBuilder<HealthProfileTable>? orderBy,
    _is.OrderByListBuilder<HealthProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<HealthProfile>(
      rows,
      orderBy: orderBy?.call(HealthProfile.t),
      orderByList: orderByList?.call(HealthProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [HealthProfile].
  Future<HealthProfile> deleteRow(
    _is.DatabaseSession session,
    HealthProfile row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HealthProfile>(
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
  Future<List<HealthProfile>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthProfileTable> where,
    _is.OrderByBuilder<HealthProfileTable>? orderBy,
    _is.OrderByListBuilder<HealthProfileTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<HealthProfile>(
      where: where(HealthProfile.t),
      orderBy: orderBy?.call(HealthProfile.t),
      orderByList: orderByList?.call(HealthProfile.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<HealthProfileTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<HealthProfile>(
      where: where?.call(HealthProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HealthProfile] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<HealthProfileTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HealthProfile>(
      where: where(HealthProfile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
