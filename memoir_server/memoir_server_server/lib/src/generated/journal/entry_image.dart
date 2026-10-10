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

/// Entry image metadata. Bytes live in object storage.
abstract class EntryImage
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  EntryImage._({
    this.id,
    required this.entryId,
    required this.objectKey,
    this.url,
    String? contentType,
    this.sizeBytes,
    this.width,
    this.height,
    this.caption,
    DateTime? createdAt,
  }) : contentType = contentType ?? 'image/jpeg',
       createdAt = createdAt ?? DateTime.now();

  factory EntryImage({
    _is.UuidValue? id,
    required _is.UuidValue entryId,
    required String objectKey,
    String? url,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
    DateTime? createdAt,
  }) = _EntryImageImpl;

  factory EntryImage.fromJson(Map<String, dynamic> jsonSerialization) {
    return EntryImage(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      entryId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['entryId'],
      ),
      objectKey: jsonSerialization['objectKey'] as String,
      url: jsonSerialization['url'] as String?,
      contentType: jsonSerialization['contentType'] as String?,
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      width: jsonSerialization['width'] as int?,
      height: jsonSerialization['height'] as int?,
      caption: jsonSerialization['caption'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = EntryImageTable();

  static const db = EntryImageRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue entryId;

  String objectKey;

  String? url;

  String contentType;

  int? sizeBytes;

  int? width;

  int? height;

  String? caption;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [EntryImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  EntryImage copyWith({
    _is.UuidValue? id,
    _is.UuidValue? entryId,
    String? objectKey,
    String? url,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EntryImage',
      if (id != null) 'id': id?.toJson(),
      'entryId': entryId.toJson(),
      'objectKey': objectKey,
      if (url != null) 'url': url,
      'contentType': contentType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (caption != null) 'caption': caption,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EntryImage',
      if (id != null) 'id': id?.toJson(),
      'entryId': entryId.toJson(),
      'objectKey': objectKey,
      if (url != null) 'url': url,
      'contentType': contentType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (caption != null) 'caption': caption,
      'createdAt': createdAt.toJson(),
    };
  }

  static EntryImageInclude include() {
    return EntryImageInclude._();
  }

  static EntryImageIncludeList includeList({
    _is.WhereExpressionBuilder<EntryImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EntryImageTable>? orderBy,
    _is.OrderByListBuilder<EntryImageTable>? orderByList,
    EntryImageInclude? include,
  }) {
    return EntryImageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EntryImage.t),
      orderByList: orderByList?.call(EntryImage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EntryImageImpl extends EntryImage {
  _EntryImageImpl({
    _is.UuidValue? id,
    required _is.UuidValue entryId,
    required String objectKey,
    String? url,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
    DateTime? createdAt,
  }) : super._(
         id: id,
         entryId: entryId,
         objectKey: objectKey,
         url: url,
         contentType: contentType,
         sizeBytes: sizeBytes,
         width: width,
         height: height,
         caption: caption,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [EntryImage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  EntryImage copyWith({
    Object? id = _Undefined,
    _is.UuidValue? entryId,
    String? objectKey,
    Object? url = _Undefined,
    String? contentType,
    Object? sizeBytes = _Undefined,
    Object? width = _Undefined,
    Object? height = _Undefined,
    Object? caption = _Undefined,
    DateTime? createdAt,
  }) {
    return EntryImage(
      id: id is _is.UuidValue? ? id : this.id,
      entryId: entryId ?? this.entryId,
      objectKey: objectKey ?? this.objectKey,
      url: url is String? ? url : this.url,
      contentType: contentType ?? this.contentType,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      width: width is int? ? width : this.width,
      height: height is int? ? height : this.height,
      caption: caption is String? ? caption : this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class EntryImageUpdateTable extends _is.UpdateTable<EntryImageTable> {
  EntryImageUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> entryId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.entryId,
        value,
      );

  _is.ColumnValue<String, String> objectKey(String value) => _is.ColumnValue(
    table.objectKey,
    value,
  );

  _is.ColumnValue<String, String> url(String? value) => _is.ColumnValue(
    table.url,
    value,
  );

  _is.ColumnValue<String, String> contentType(String value) => _is.ColumnValue(
    table.contentType,
    value,
  );

  _is.ColumnValue<int, int> sizeBytes(int? value) => _is.ColumnValue(
    table.sizeBytes,
    value,
  );

  _is.ColumnValue<int, int> width(int? value) => _is.ColumnValue(
    table.width,
    value,
  );

  _is.ColumnValue<int, int> height(int? value) => _is.ColumnValue(
    table.height,
    value,
  );

  _is.ColumnValue<String, String> caption(String? value) => _is.ColumnValue(
    table.caption,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class EntryImageTable extends _is.Table<_is.UuidValue?> {
  EntryImageTable({super.tableRelation}) : super(tableName: 'entry_images') {
    updateTable = EntryImageUpdateTable(this);
    entryId = _is.ColumnUuid(
      'entryId',
      this,
    );
    objectKey = _is.ColumnString(
      'objectKey',
      this,
    );
    url = _is.ColumnString(
      'url',
      this,
    );
    contentType = _is.ColumnString(
      'contentType',
      this,
      hasDefault: true,
    );
    sizeBytes = _is.ColumnInt(
      'sizeBytes',
      this,
    );
    width = _is.ColumnInt(
      'width',
      this,
    );
    height = _is.ColumnInt(
      'height',
      this,
    );
    caption = _is.ColumnString(
      'caption',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final EntryImageUpdateTable updateTable;

  late final _is.ColumnUuid entryId;

  late final _is.ColumnString objectKey;

  late final _is.ColumnString url;

  late final _is.ColumnString contentType;

  late final _is.ColumnInt sizeBytes;

  late final _is.ColumnInt width;

  late final _is.ColumnInt height;

  late final _is.ColumnString caption;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    entryId,
    objectKey,
    url,
    contentType,
    sizeBytes,
    width,
    height,
    caption,
    createdAt,
  ];
}

class EntryImageInclude extends _is.IncludeObject {
  EntryImageInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => EntryImage.t;
}

class EntryImageIncludeList extends _is.IncludeList {
  EntryImageIncludeList._({
    _is.WhereExpressionBuilder<EntryImageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EntryImage.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => EntryImage.t;
}

class EntryImageRepository {
  const EntryImageRepository._();

  /// Returns a list of [EntryImage]s matching the given query parameters.
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
  Future<List<EntryImage>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EntryImageTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EntryImageTable>? orderBy,
    _is.OrderByListBuilder<EntryImageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EntryImage>(
      where: where?.call(EntryImage.t),
      orderBy: orderBy?.call(EntryImage.t),
      orderByList: orderByList?.call(EntryImage.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EntryImage] matching the given query parameters.
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
  Future<EntryImage?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EntryImageTable>? where,
    int? offset,
    _is.OrderByBuilder<EntryImageTable>? orderBy,
    _is.OrderByListBuilder<EntryImageTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EntryImage>(
      where: where?.call(EntryImage.t),
      orderBy: orderBy?.call(EntryImage.t),
      orderByList: orderByList?.call(EntryImage.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EntryImage] by its [id] or null if no such row exists.
  Future<EntryImage?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EntryImage>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EntryImage]s in the list and returns the inserted rows.
  ///
  /// The returned [EntryImage]s will have their `id` fields set.
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
  Future<List<EntryImage>> insert(
    _is.DatabaseSession session,
    List<EntryImage> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EntryImage>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EntryImage] and returns the inserted row.
  ///
  /// The returned [EntryImage] will have its `id` field set.
  Future<EntryImage> insertRow(
    _is.DatabaseSession session,
    EntryImage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<EntryImage>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EntryImage]s in the list and returns the resulting rows.
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
  /// The returned [EntryImage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EntryImage>> upsert(
    _is.DatabaseSession session,
    List<EntryImage> rows, {
    required _is.ColumnSelections<EntryImageTable> conflictColumns,
    _is.ColumnSelections<EntryImageTable>? updateColumns,
    _is.WhereExpressionBuilder<EntryImageTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EntryImage>(
      rows,
      conflictColumns: conflictColumns(EntryImage.t),
      updateColumns: updateColumns?.call(EntryImage.t),
      updateWhere: updateWhere?.call(EntryImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EntryImage] and returns the resulting row.
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
  /// The returned [EntryImage] will have its `id` field set.
  Future<EntryImage?> upsertRow(
    _is.DatabaseSession session,
    EntryImage row, {
    required _is.ColumnSelections<EntryImageTable> conflictColumns,
    _is.ColumnSelections<EntryImageTable>? updateColumns,
    _is.WhereExpressionBuilder<EntryImageTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EntryImage>(
      row,
      conflictColumns: conflictColumns(EntryImage.t),
      updateColumns: updateColumns?.call(EntryImage.t),
      updateWhere: updateWhere?.call(EntryImage.t),
      transaction: transaction,
    );
  }

  /// Updates all [EntryImage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EntryImage>> update(
    _is.DatabaseSession session,
    List<EntryImage> rows, {
    _is.ColumnSelections<EntryImageTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EntryImage>(
      rows,
      columns: columns?.call(EntryImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EntryImage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EntryImage> updateRow(
    _is.DatabaseSession session,
    EntryImage row, {
    _is.ColumnSelections<EntryImageTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<EntryImage>(
      row,
      columns: columns?.call(EntryImage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EntryImage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EntryImage?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<EntryImageUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<EntryImage>(
      id,
      columnValues: columnValues(EntryImage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EntryImage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EntryImage>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<EntryImageUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<EntryImageTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<EntryImageTable>? orderBy,
    _is.OrderByListBuilder<EntryImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EntryImage>(
      columnValues: columnValues(EntryImage.t.updateTable),
      where: where(EntryImage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EntryImage.t),
      orderByList: orderByList?.call(EntryImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EntryImage]s in the list and returns the deleted rows.
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
  Future<List<EntryImage>> delete(
    _is.DatabaseSession session,
    List<EntryImage> rows, {
    _is.OrderByBuilder<EntryImageTable>? orderBy,
    _is.OrderByListBuilder<EntryImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EntryImage>(
      rows,
      orderBy: orderBy?.call(EntryImage.t),
      orderByList: orderByList?.call(EntryImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EntryImage].
  Future<EntryImage> deleteRow(
    _is.DatabaseSession session,
    EntryImage row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EntryImage>(
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
  Future<List<EntryImage>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EntryImageTable> where,
    _is.OrderByBuilder<EntryImageTable>? orderBy,
    _is.OrderByListBuilder<EntryImageTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EntryImage>(
      where: where(EntryImage.t),
      orderBy: orderBy?.call(EntryImage.t),
      orderByList: orderByList?.call(EntryImage.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<EntryImageTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<EntryImage>(
      where: where?.call(EntryImage.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EntryImage] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<EntryImageTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EntryImage>(
      where: where(EntryImage.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
