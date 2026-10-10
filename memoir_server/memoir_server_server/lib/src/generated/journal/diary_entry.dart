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

/// Diary entry (central entity). One row per user per day.
abstract class DiaryEntry
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  DiaryEntry._({
    this.id,
    required this.userId,
    required this.entryDate,
    this.moodId,
    this.weatherId,
    this.diaryText,
    this.otherPerspective,
    this.futureMessage,
    this.selfCare,
    this.tomorrowHope,
    this.gratitude,
    this.dream,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory DiaryEntry({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime entryDate,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DiaryEntryImpl;

  factory DiaryEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return DiaryEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['entryDate'],
      ),
      moodId: jsonSerialization['moodId'] as int?,
      weatherId: jsonSerialization['weatherId'] as int?,
      diaryText: jsonSerialization['diaryText'] as String?,
      otherPerspective: jsonSerialization['otherPerspective'] as String?,
      futureMessage: jsonSerialization['futureMessage'] as String?,
      selfCare: jsonSerialization['selfCare'] as String?,
      tomorrowHope: jsonSerialization['tomorrowHope'] as String?,
      gratitude: jsonSerialization['gratitude'] as String?,
      dream: jsonSerialization['dream'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = DiaryEntryTable();

  static const db = DiaryEntryRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue userId;

  /// Date-only value; time component is ignored.
  DateTime entryDate;

  int? moodId;

  int? weatherId;

  String? diaryText;

  String? otherPerspective;

  String? futureMessage;

  String? selfCare;

  String? tomorrowHope;

  String? gratitude;

  String? dream;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DiaryEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DiaryEntry copyWith({
    _is.UuidValue? id,
    _is.UuidValue? userId,
    DateTime? entryDate,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DiaryEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'entryDate': entryDate.toJson(),
      if (moodId != null) 'moodId': moodId,
      if (weatherId != null) 'weatherId': weatherId,
      if (diaryText != null) 'diaryText': diaryText,
      if (otherPerspective != null) 'otherPerspective': otherPerspective,
      if (futureMessage != null) 'futureMessage': futureMessage,
      if (selfCare != null) 'selfCare': selfCare,
      if (tomorrowHope != null) 'tomorrowHope': tomorrowHope,
      if (gratitude != null) 'gratitude': gratitude,
      if (dream != null) 'dream': dream,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DiaryEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'entryDate': entryDate.toJson(),
      if (moodId != null) 'moodId': moodId,
      if (weatherId != null) 'weatherId': weatherId,
      if (diaryText != null) 'diaryText': diaryText,
      if (otherPerspective != null) 'otherPerspective': otherPerspective,
      if (futureMessage != null) 'futureMessage': futureMessage,
      if (selfCare != null) 'selfCare': selfCare,
      if (tomorrowHope != null) 'tomorrowHope': tomorrowHope,
      if (gratitude != null) 'gratitude': gratitude,
      if (dream != null) 'dream': dream,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static DiaryEntryInclude include() {
    return DiaryEntryInclude._();
  }

  static DiaryEntryIncludeList includeList({
    _is.WhereExpressionBuilder<DiaryEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DiaryEntryTable>? orderBy,
    _is.OrderByListBuilder<DiaryEntryTable>? orderByList,
    DiaryEntryInclude? include,
  }) {
    return DiaryEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DiaryEntry.t),
      orderByList: orderByList?.call(DiaryEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DiaryEntryImpl extends DiaryEntry {
  _DiaryEntryImpl({
    _is.UuidValue? id,
    required _is.UuidValue userId,
    required DateTime entryDate,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         entryDate: entryDate,
         moodId: moodId,
         weatherId: weatherId,
         diaryText: diaryText,
         otherPerspective: otherPerspective,
         futureMessage: futureMessage,
         selfCare: selfCare,
         tomorrowHope: tomorrowHope,
         gratitude: gratitude,
         dream: dream,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DiaryEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DiaryEntry copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? entryDate,
    Object? moodId = _Undefined,
    Object? weatherId = _Undefined,
    Object? diaryText = _Undefined,
    Object? otherPerspective = _Undefined,
    Object? futureMessage = _Undefined,
    Object? selfCare = _Undefined,
    Object? tomorrowHope = _Undefined,
    Object? gratitude = _Undefined,
    Object? dream = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      id: id is _is.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      entryDate: entryDate ?? this.entryDate,
      moodId: moodId is int? ? moodId : this.moodId,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      diaryText: diaryText is String? ? diaryText : this.diaryText,
      otherPerspective: otherPerspective is String?
          ? otherPerspective
          : this.otherPerspective,
      futureMessage: futureMessage is String?
          ? futureMessage
          : this.futureMessage,
      selfCare: selfCare is String? ? selfCare : this.selfCare,
      tomorrowHope: tomorrowHope is String? ? tomorrowHope : this.tomorrowHope,
      gratitude: gratitude is String? ? gratitude : this.gratitude,
      dream: dream is String? ? dream : this.dream,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class DiaryEntryUpdateTable extends _is.UpdateTable<DiaryEntryTable> {
  DiaryEntryUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> entryDate(DateTime value) =>
      _is.ColumnValue(
        table.entryDate,
        value,
      );

  _is.ColumnValue<int, int> moodId(int? value) => _is.ColumnValue(
    table.moodId,
    value,
  );

  _is.ColumnValue<int, int> weatherId(int? value) => _is.ColumnValue(
    table.weatherId,
    value,
  );

  _is.ColumnValue<String, String> diaryText(String? value) => _is.ColumnValue(
    table.diaryText,
    value,
  );

  _is.ColumnValue<String, String> otherPerspective(String? value) =>
      _is.ColumnValue(
        table.otherPerspective,
        value,
      );

  _is.ColumnValue<String, String> futureMessage(String? value) =>
      _is.ColumnValue(
        table.futureMessage,
        value,
      );

  _is.ColumnValue<String, String> selfCare(String? value) => _is.ColumnValue(
    table.selfCare,
    value,
  );

  _is.ColumnValue<String, String> tomorrowHope(String? value) =>
      _is.ColumnValue(
        table.tomorrowHope,
        value,
      );

  _is.ColumnValue<String, String> gratitude(String? value) => _is.ColumnValue(
    table.gratitude,
    value,
  );

  _is.ColumnValue<String, String> dream(String? value) => _is.ColumnValue(
    table.dream,
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

class DiaryEntryTable extends _is.Table<_is.UuidValue?> {
  DiaryEntryTable({super.tableRelation}) : super(tableName: 'diary_entries') {
    updateTable = DiaryEntryUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    entryDate = _is.ColumnDateTime(
      'entryDate',
      this,
    );
    moodId = _is.ColumnInt(
      'moodId',
      this,
    );
    weatherId = _is.ColumnInt(
      'weatherId',
      this,
    );
    diaryText = _is.ColumnString(
      'diaryText',
      this,
    );
    otherPerspective = _is.ColumnString(
      'otherPerspective',
      this,
    );
    futureMessage = _is.ColumnString(
      'futureMessage',
      this,
    );
    selfCare = _is.ColumnString(
      'selfCare',
      this,
    );
    tomorrowHope = _is.ColumnString(
      'tomorrowHope',
      this,
    );
    gratitude = _is.ColumnString(
      'gratitude',
      this,
    );
    dream = _is.ColumnString(
      'dream',
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

  late final DiaryEntryUpdateTable updateTable;

  late final _is.ColumnUuid userId;

  /// Date-only value; time component is ignored.
  late final _is.ColumnDateTime entryDate;

  late final _is.ColumnInt moodId;

  late final _is.ColumnInt weatherId;

  late final _is.ColumnString diaryText;

  late final _is.ColumnString otherPerspective;

  late final _is.ColumnString futureMessage;

  late final _is.ColumnString selfCare;

  late final _is.ColumnString tomorrowHope;

  late final _is.ColumnString gratitude;

  late final _is.ColumnString dream;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    entryDate,
    moodId,
    weatherId,
    diaryText,
    otherPerspective,
    futureMessage,
    selfCare,
    tomorrowHope,
    gratitude,
    dream,
    createdAt,
    updatedAt,
  ];
}

class DiaryEntryInclude extends _is.IncludeObject {
  DiaryEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => DiaryEntry.t;
}

class DiaryEntryIncludeList extends _is.IncludeList {
  DiaryEntryIncludeList._({
    _is.WhereExpressionBuilder<DiaryEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DiaryEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => DiaryEntry.t;
}

class DiaryEntryRepository {
  const DiaryEntryRepository._();

  /// Returns a list of [DiaryEntry]s matching the given query parameters.
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
  Future<List<DiaryEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DiaryEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DiaryEntryTable>? orderBy,
    _is.OrderByListBuilder<DiaryEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DiaryEntry>(
      where: where?.call(DiaryEntry.t),
      orderBy: orderBy?.call(DiaryEntry.t),
      orderByList: orderByList?.call(DiaryEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DiaryEntry] matching the given query parameters.
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
  Future<DiaryEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DiaryEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<DiaryEntryTable>? orderBy,
    _is.OrderByListBuilder<DiaryEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DiaryEntry>(
      where: where?.call(DiaryEntry.t),
      orderBy: orderBy?.call(DiaryEntry.t),
      orderByList: orderByList?.call(DiaryEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DiaryEntry] by its [id] or null if no such row exists.
  Future<DiaryEntry?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DiaryEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DiaryEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [DiaryEntry]s will have their `id` fields set.
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
  Future<List<DiaryEntry>> insert(
    _is.DatabaseSession session,
    List<DiaryEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DiaryEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DiaryEntry] and returns the inserted row.
  ///
  /// The returned [DiaryEntry] will have its `id` field set.
  Future<DiaryEntry> insertRow(
    _is.DatabaseSession session,
    DiaryEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DiaryEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DiaryEntry]s in the list and returns the resulting rows.
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
  /// The returned [DiaryEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DiaryEntry>> upsert(
    _is.DatabaseSession session,
    List<DiaryEntry> rows, {
    required _is.ColumnSelections<DiaryEntryTable> conflictColumns,
    _is.ColumnSelections<DiaryEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<DiaryEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DiaryEntry>(
      rows,
      conflictColumns: conflictColumns(DiaryEntry.t),
      updateColumns: updateColumns?.call(DiaryEntry.t),
      updateWhere: updateWhere?.call(DiaryEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DiaryEntry] and returns the resulting row.
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
  /// The returned [DiaryEntry] will have its `id` field set.
  Future<DiaryEntry?> upsertRow(
    _is.DatabaseSession session,
    DiaryEntry row, {
    required _is.ColumnSelections<DiaryEntryTable> conflictColumns,
    _is.ColumnSelections<DiaryEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<DiaryEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DiaryEntry>(
      row,
      conflictColumns: conflictColumns(DiaryEntry.t),
      updateColumns: updateColumns?.call(DiaryEntry.t),
      updateWhere: updateWhere?.call(DiaryEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [DiaryEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DiaryEntry>> update(
    _is.DatabaseSession session,
    List<DiaryEntry> rows, {
    _is.ColumnSelections<DiaryEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DiaryEntry>(
      rows,
      columns: columns?.call(DiaryEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DiaryEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DiaryEntry> updateRow(
    _is.DatabaseSession session,
    DiaryEntry row, {
    _is.ColumnSelections<DiaryEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DiaryEntry>(
      row,
      columns: columns?.call(DiaryEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DiaryEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DiaryEntry?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<DiaryEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DiaryEntry>(
      id,
      columnValues: columnValues(DiaryEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DiaryEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DiaryEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DiaryEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DiaryEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DiaryEntryTable>? orderBy,
    _is.OrderByListBuilder<DiaryEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DiaryEntry>(
      columnValues: columnValues(DiaryEntry.t.updateTable),
      where: where(DiaryEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DiaryEntry.t),
      orderByList: orderByList?.call(DiaryEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DiaryEntry]s in the list and returns the deleted rows.
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
  Future<List<DiaryEntry>> delete(
    _is.DatabaseSession session,
    List<DiaryEntry> rows, {
    _is.OrderByBuilder<DiaryEntryTable>? orderBy,
    _is.OrderByListBuilder<DiaryEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DiaryEntry>(
      rows,
      orderBy: orderBy?.call(DiaryEntry.t),
      orderByList: orderByList?.call(DiaryEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DiaryEntry].
  Future<DiaryEntry> deleteRow(
    _is.DatabaseSession session,
    DiaryEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DiaryEntry>(
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
  Future<List<DiaryEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DiaryEntryTable> where,
    _is.OrderByBuilder<DiaryEntryTable>? orderBy,
    _is.OrderByListBuilder<DiaryEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DiaryEntry>(
      where: where(DiaryEntry.t),
      orderBy: orderBy?.call(DiaryEntry.t),
      orderByList: orderByList?.call(DiaryEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DiaryEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DiaryEntry>(
      where: where?.call(DiaryEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DiaryEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DiaryEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DiaryEntry>(
      where: where(DiaryEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
