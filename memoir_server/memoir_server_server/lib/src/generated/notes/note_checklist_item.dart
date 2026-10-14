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

/// One checklist line inside a note (interactive to-do block).
abstract class NoteChecklistItem
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  NoteChecklistItem._({
    this.id,
    required this.noteId,
    required this.text,
    bool? isDone,
    int? sortOrder,
  }) : isDone = isDone ?? false,
       sortOrder = sortOrder ?? 0;

  factory NoteChecklistItem({
    _is.UuidValue? id,
    required _is.UuidValue noteId,
    required String text,
    bool? isDone,
    int? sortOrder,
  }) = _NoteChecklistItemImpl;

  factory NoteChecklistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return NoteChecklistItem(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      noteId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['noteId']),
      text: jsonSerialization['text'] as String,
      isDone: jsonSerialization['isDone'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDone']),
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  static final t = NoteChecklistItemTable();

  static const db = NoteChecklistItemRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue noteId;

  String text;

  bool isDone;

  /// Thứ tự hiển thị; 0-based, tăng dần từ trên xuống.
  int sortOrder;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [NoteChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  NoteChecklistItem copyWith({
    _is.UuidValue? id,
    _is.UuidValue? noteId,
    String? text,
    bool? isDone,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NoteChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'noteId': noteId.toJson(),
      'text': text,
      'isDone': isDone,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NoteChecklistItem',
      if (id != null) 'id': id?.toJson(),
      'noteId': noteId.toJson(),
      'text': text,
      'isDone': isDone,
      'sortOrder': sortOrder,
    };
  }

  static NoteChecklistItemInclude include() {
    return NoteChecklistItemInclude._();
  }

  static NoteChecklistItemIncludeList includeList({
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NoteChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<NoteChecklistItemTable>? orderByList,
    NoteChecklistItemInclude? include,
  }) {
    return NoteChecklistItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NoteChecklistItem.t),
      orderByList: orderByList?.call(NoteChecklistItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NoteChecklistItemImpl extends NoteChecklistItem {
  _NoteChecklistItemImpl({
    _is.UuidValue? id,
    required _is.UuidValue noteId,
    required String text,
    bool? isDone,
    int? sortOrder,
  }) : super._(
         id: id,
         noteId: noteId,
         text: text,
         isDone: isDone,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [NoteChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  NoteChecklistItem copyWith({
    Object? id = _Undefined,
    _is.UuidValue? noteId,
    String? text,
    bool? isDone,
    int? sortOrder,
  }) {
    return NoteChecklistItem(
      id: id is _is.UuidValue? ? id : this.id,
      noteId: noteId ?? this.noteId,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class NoteChecklistItemUpdateTable
    extends _is.UpdateTable<NoteChecklistItemTable> {
  NoteChecklistItemUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> noteId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.noteId,
        value,
      );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<bool, bool> isDone(bool value) => _is.ColumnValue(
    table.isDone,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );
}

class NoteChecklistItemTable extends _is.Table<_is.UuidValue?> {
  NoteChecklistItemTable({super.tableRelation})
    : super(tableName: 'note_checklist_items') {
    updateTable = NoteChecklistItemUpdateTable(this);
    noteId = _is.ColumnUuid(
      'noteId',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
    );
    isDone = _is.ColumnBool(
      'isDone',
      this,
      hasDefault: true,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
  }

  late final NoteChecklistItemUpdateTable updateTable;

  late final _is.ColumnUuid noteId;

  late final _is.ColumnString text;

  late final _is.ColumnBool isDone;

  /// Thứ tự hiển thị; 0-based, tăng dần từ trên xuống.
  late final _is.ColumnInt sortOrder;

  @override
  List<_is.Column> get columns => [
    id,
    noteId,
    text,
    isDone,
    sortOrder,
  ];
}

class NoteChecklistItemInclude extends _is.IncludeObject {
  NoteChecklistItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => NoteChecklistItem.t;
}

class NoteChecklistItemIncludeList extends _is.IncludeList {
  NoteChecklistItemIncludeList._({
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(NoteChecklistItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => NoteChecklistItem.t;
}

class NoteChecklistItemRepository {
  const NoteChecklistItemRepository._();

  /// Returns a list of [NoteChecklistItem]s matching the given query parameters.
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
  Future<List<NoteChecklistItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NoteChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<NoteChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<NoteChecklistItem>(
      where: where?.call(NoteChecklistItem.t),
      orderBy: orderBy?.call(NoteChecklistItem.t),
      orderByList: orderByList?.call(NoteChecklistItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [NoteChecklistItem] matching the given query parameters.
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
  Future<NoteChecklistItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? where,
    int? offset,
    _is.OrderByBuilder<NoteChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<NoteChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<NoteChecklistItem>(
      where: where?.call(NoteChecklistItem.t),
      orderBy: orderBy?.call(NoteChecklistItem.t),
      orderByList: orderByList?.call(NoteChecklistItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [NoteChecklistItem] by its [id] or null if no such row exists.
  Future<NoteChecklistItem?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<NoteChecklistItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [NoteChecklistItem]s in the list and returns the inserted rows.
  ///
  /// The returned [NoteChecklistItem]s will have their `id` fields set.
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
  Future<List<NoteChecklistItem>> insert(
    _is.DatabaseSession session,
    List<NoteChecklistItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<NoteChecklistItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [NoteChecklistItem] and returns the inserted row.
  ///
  /// The returned [NoteChecklistItem] will have its `id` field set.
  Future<NoteChecklistItem> insertRow(
    _is.DatabaseSession session,
    NoteChecklistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<NoteChecklistItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [NoteChecklistItem]s in the list and returns the resulting rows.
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
  /// The returned [NoteChecklistItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NoteChecklistItem>> upsert(
    _is.DatabaseSession session,
    List<NoteChecklistItem> rows, {
    required _is.ColumnSelections<NoteChecklistItemTable> conflictColumns,
    _is.ColumnSelections<NoteChecklistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<NoteChecklistItem>(
      rows,
      conflictColumns: conflictColumns(NoteChecklistItem.t),
      updateColumns: updateColumns?.call(NoteChecklistItem.t),
      updateWhere: updateWhere?.call(NoteChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [NoteChecklistItem] and returns the resulting row.
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
  /// The returned [NoteChecklistItem] will have its `id` field set.
  Future<NoteChecklistItem?> upsertRow(
    _is.DatabaseSession session,
    NoteChecklistItem row, {
    required _is.ColumnSelections<NoteChecklistItemTable> conflictColumns,
    _is.ColumnSelections<NoteChecklistItemTable>? updateColumns,
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<NoteChecklistItem>(
      row,
      conflictColumns: conflictColumns(NoteChecklistItem.t),
      updateColumns: updateColumns?.call(NoteChecklistItem.t),
      updateWhere: updateWhere?.call(NoteChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [NoteChecklistItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NoteChecklistItem>> update(
    _is.DatabaseSession session,
    List<NoteChecklistItem> rows, {
    _is.ColumnSelections<NoteChecklistItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<NoteChecklistItem>(
      rows,
      columns: columns?.call(NoteChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [NoteChecklistItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<NoteChecklistItem> updateRow(
    _is.DatabaseSession session,
    NoteChecklistItem row, {
    _is.ColumnSelections<NoteChecklistItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<NoteChecklistItem>(
      row,
      columns: columns?.call(NoteChecklistItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [NoteChecklistItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<NoteChecklistItem?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NoteChecklistItemUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<NoteChecklistItem>(
      id,
      columnValues: columnValues(NoteChecklistItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [NoteChecklistItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<NoteChecklistItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NoteChecklistItemUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<NoteChecklistItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NoteChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<NoteChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<NoteChecklistItem>(
      columnValues: columnValues(NoteChecklistItem.t.updateTable),
      where: where(NoteChecklistItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(NoteChecklistItem.t),
      orderByList: orderByList?.call(NoteChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [NoteChecklistItem]s in the list and returns the deleted rows.
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
  Future<List<NoteChecklistItem>> delete(
    _is.DatabaseSession session,
    List<NoteChecklistItem> rows, {
    _is.OrderByBuilder<NoteChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<NoteChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<NoteChecklistItem>(
      rows,
      orderBy: orderBy?.call(NoteChecklistItem.t),
      orderByList: orderByList?.call(NoteChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [NoteChecklistItem].
  Future<NoteChecklistItem> deleteRow(
    _is.DatabaseSession session,
    NoteChecklistItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<NoteChecklistItem>(
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
  Future<List<NoteChecklistItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NoteChecklistItemTable> where,
    _is.OrderByBuilder<NoteChecklistItemTable>? orderBy,
    _is.OrderByListBuilder<NoteChecklistItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<NoteChecklistItem>(
      where: where(NoteChecklistItem.t),
      orderBy: orderBy?.call(NoteChecklistItem.t),
      orderByList: orderByList?.call(NoteChecklistItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NoteChecklistItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<NoteChecklistItem>(
      where: where?.call(NoteChecklistItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [NoteChecklistItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NoteChecklistItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<NoteChecklistItem>(
      where: where(NoteChecklistItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
