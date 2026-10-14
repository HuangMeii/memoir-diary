/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:memoir_server_server/src/generated/auth/user.dart' as _ijdnq3k2;
import 'package:memoir_server_server/src/generated/health/health_log.dart'
    as _izb6cxrd;
import 'package:memoir_server_server/src/generated/journal/diary_entry.dart'
    as _irepgc45;
import 'package:memoir_server_server/src/generated/journal/entry_image_view.dart'
    as _iqimgcp7;
import 'package:memoir_server_server/src/generated/lookups/mood.dart'
    as _ivwgwn86;
import 'package:memoir_server_server/src/generated/lookups/weather.dart'
    as _i1e4r54y;
import 'package:memoir_server_server/src/generated/notes/note.dart'
    as _ikw68uhq;
import 'package:memoir_server_server/src/generated/notes/note_checklist_item.dart'
    as _i6aehc7v;
import 'package:memoir_server_server/src/generated/planner/event.dart'
    as _ispcnwj0;
import 'package:memoir_server_server/src/generated/planner/schedule_item.dart'
    as _i24him69;
import 'package:memoir_server_server/src/generated/planner/todo.dart'
    as _i88ur6fx;
import 'package:memoir_server_server/src/generated/quotes/daily_quote_pair.dart'
    as _iheiqx9t;
import 'package:memoir_server_server/src/generated/quotes/quote.dart'
    as _iv6p5134;
import 'package:memoir_server_server/src/generated/quotes/reflection.dart'
    as _i6c9evrp;
import 'package:memoir_server_server/src/generated/quotes/self_message.dart'
    as _in6lippz;
import 'package:memoir_server_server/src/generated/stats/grid_cell.dart'
    as _iq2zvbrw;
import 'package:memoir_server_server/src/generated/weather/weather_day.dart'
    as _izbqdxvp;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'auth/auth_result.dart' as _i2iwynut;
import 'auth/auth_token.dart' as _i3olc4tp;
import 'auth/user.dart' as _ihzw26wp;
import 'health/health_log.dart' as _ipi876o6;
import 'journal/diary_entry.dart' as _isn947xq;
import 'journal/entry_image.dart' as _i22rqx9f;
import 'journal/entry_image_view.dart' as _iop7kemj;
import 'journal/image_upload_ticket.dart' as _ir6xzchz;
import 'lookups/mood.dart' as _ie2xden6;
import 'lookups/weather.dart' as _i262ionk;
import 'notes/note.dart' as _iylmodbg;
import 'notes/note_checklist_item.dart' as _iv4f5jvm;
import 'notes/note_detail.dart' as _i7hg4pp3;
import 'notes/note_entry_link.dart' as _ifh3czcz;
import 'planner/event.dart' as _itmremj5;
import 'planner/schedule_item.dart' as _ixsuwyrb;
import 'planner/todo.dart' as _ila1vkid;
import 'quotes/daily_quote.dart' as _ivolu13p;
import 'quotes/daily_quote_pair.dart' as _ip1ndbg5;
import 'quotes/quote.dart' as _ijvippl1;
import 'quotes/reflection.dart' as _ie2y0yiy;
import 'quotes/self_message.dart' as _iyriup1i;
import 'shared/api_exception.dart' as _iatey69s;
import 'stats/grid_cell.dart' as _idkvug70;
import 'stats/stats_summary.dart' as _iaxcfmie;
import 'weather/weather_day.dart' as _i5dryx1t;
import 'weather/weather_forecast.dart' as _ivf1lbpe;
import 'weather/weather_snapshot.dart' as _i7z01835;
export 'auth/auth_result.dart';
export 'auth/auth_token.dart';
export 'auth/user.dart';
export 'health/health_log.dart';
export 'journal/diary_entry.dart';
export 'journal/entry_image.dart';
export 'journal/entry_image_view.dart';
export 'journal/image_upload_ticket.dart';
export 'lookups/mood.dart';
export 'lookups/weather.dart';
export 'notes/note.dart';
export 'notes/note_checklist_item.dart';
export 'notes/note_detail.dart';
export 'notes/note_entry_link.dart';
export 'planner/event.dart';
export 'planner/schedule_item.dart';
export 'planner/todo.dart';
export 'quotes/daily_quote.dart';
export 'quotes/daily_quote_pair.dart';
export 'quotes/quote.dart';
export 'quotes/reflection.dart';
export 'quotes/self_message.dart';
export 'shared/api_exception.dart';
export 'stats/grid_cell.dart';
export 'stats/stats_summary.dart';
export 'weather/weather_day.dart';
export 'weather/weather_forecast.dart';
export 'weather/weather_snapshot.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'auth_tokens',
      dartName: 'AuthToken',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'token',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'auth_tokens__token__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'daily_quotes',
      dartName: 'DailyQuote',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'quoteDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'quoteId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'quoteId2',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'selfMessageId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'daily_quotes_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'daily_quotes__userId__quoteDate__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'quoteDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'diary_entries',
      dartName: 'DiaryEntry',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'entryDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'moodId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'diaryText',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'otherPerspective',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'futureMessage',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'selfCare',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'tomorrowHope',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'gratitude',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'dream',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'diary_entries_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'diary_entries__userId__entryDate__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'entryDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'entry_images',
      dartName: 'EntryImage',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'entryId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'objectKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'url',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contentType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'image/jpeg\'',
        ),
        _isp.ColumnDefinition(
          name: 'sizeBytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'width',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'height',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'caption',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'entry_images_fk_0',
          columns: ['entryId'],
          referenceTable: 'diary_entries',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'events',
      dartName: 'Event',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'startAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'location',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isAllDay',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'reminderMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'events_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'health_logs',
      dartName: 'HealthLog',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'logDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'steps',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'workoutMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'waterMl',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepHours',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'weightKg',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'health_logs_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'health_logs__userId__logDate__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'logDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'moods',
      dartName: 'Mood',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'labelVi',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'colorHex',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'icon',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'moods__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'note_checklist_items',
      dartName: 'NoteChecklistItem',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'noteId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'isDone',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'note_checklist_items_fk_0',
          columns: ['noteId'],
          referenceTable: 'notes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'idx_note_checklist_note',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'noteId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sortOrder',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'note_entry_links',
      dartName: 'NoteEntryLink',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'noteId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'entryId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'note_entry_links_fk_0',
          columns: ['noteId'],
          referenceTable: 'notes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'note_entry_links_fk_1',
          columns: ['entryId'],
          referenceTable: 'diary_entries',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'note_entry_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'noteId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'entryId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'notes',
      dartName: 'Note',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'color',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'tags',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'isPinned',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'isArchived',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'isTrashed',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'notes_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'idx_notes_user_updated',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'updatedAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idx_notes_user_flags',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'isTrashed',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'isArchived',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'quotes',
      dartName: 'Quote',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'author',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'reflections',
      dartName: 'Reflection',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'entryId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'quoteId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'selfMessageId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'thought',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'reflections_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'schedule_items',
      dartName: 'ScheduleItem',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'startAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'recurrenceRule',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'reminderMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'schedule_items_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'self_messages',
      dartName: 'SelfMessage',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'entryId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'self_messages_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'todos',
      dartName: 'Todo',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'dueDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'weekLabel',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'priority',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '2',
        ),
        _isp.ColumnDefinition(
          name: 'isDone',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'todos_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'users',
      dartName: 'User',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'username',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'passwordHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'user\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'weatherLat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherLon',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherLocationName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'users__email__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'users__username__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'username',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'weather_snapshots',
      dartName: 'WeatherSnapshot',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'forecastDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'weatherCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'weatherId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'tempMin',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'tempMax',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'tempAvg',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'precipitationMm',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'fetchedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'weather_snapshots_fk_0',
          columns: ['userId'],
          referenceTable: 'users',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'weather_snapshots__userId__forecastDate__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'forecastDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'weathers',
      dartName: 'Weather',
      schema: 'public',
      module: 'memoir_server',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'labelVi',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'colorHex',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'icon',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'weathers__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2iwynut.AuthResult) {
      return _i2iwynut.AuthResult.fromJson(data) as T;
    }
    if (t == _i3olc4tp.AuthToken) {
      return _i3olc4tp.AuthToken.fromJson(data) as T;
    }
    if (t == _ihzw26wp.User) {
      return _ihzw26wp.User.fromJson(data) as T;
    }
    if (t == _ipi876o6.HealthLog) {
      return _ipi876o6.HealthLog.fromJson(data) as T;
    }
    if (t == _isn947xq.DiaryEntry) {
      return _isn947xq.DiaryEntry.fromJson(data) as T;
    }
    if (t == _i22rqx9f.EntryImage) {
      return _i22rqx9f.EntryImage.fromJson(data) as T;
    }
    if (t == _iop7kemj.EntryImageView) {
      return _iop7kemj.EntryImageView.fromJson(data) as T;
    }
    if (t == _ir6xzchz.ImageUploadTicket) {
      return _ir6xzchz.ImageUploadTicket.fromJson(data) as T;
    }
    if (t == _ie2xden6.Mood) {
      return _ie2xden6.Mood.fromJson(data) as T;
    }
    if (t == _i262ionk.Weather) {
      return _i262ionk.Weather.fromJson(data) as T;
    }
    if (t == _iylmodbg.Note) {
      return _iylmodbg.Note.fromJson(data) as T;
    }
    if (t == _iv4f5jvm.NoteChecklistItem) {
      return _iv4f5jvm.NoteChecklistItem.fromJson(data) as T;
    }
    if (t == _i7hg4pp3.NoteDetail) {
      return _i7hg4pp3.NoteDetail.fromJson(data) as T;
    }
    if (t == _ifh3czcz.NoteEntryLink) {
      return _ifh3czcz.NoteEntryLink.fromJson(data) as T;
    }
    if (t == _itmremj5.Event) {
      return _itmremj5.Event.fromJson(data) as T;
    }
    if (t == _ixsuwyrb.ScheduleItem) {
      return _ixsuwyrb.ScheduleItem.fromJson(data) as T;
    }
    if (t == _ila1vkid.Todo) {
      return _ila1vkid.Todo.fromJson(data) as T;
    }
    if (t == _ivolu13p.DailyQuote) {
      return _ivolu13p.DailyQuote.fromJson(data) as T;
    }
    if (t == _ip1ndbg5.DailyQuotePair) {
      return _ip1ndbg5.DailyQuotePair.fromJson(data) as T;
    }
    if (t == _ijvippl1.Quote) {
      return _ijvippl1.Quote.fromJson(data) as T;
    }
    if (t == _ie2y0yiy.Reflection) {
      return _ie2y0yiy.Reflection.fromJson(data) as T;
    }
    if (t == _iyriup1i.SelfMessage) {
      return _iyriup1i.SelfMessage.fromJson(data) as T;
    }
    if (t == _iatey69s.ApiException) {
      return _iatey69s.ApiException.fromJson(data) as T;
    }
    if (t == _idkvug70.GridCell) {
      return _idkvug70.GridCell.fromJson(data) as T;
    }
    if (t == _iaxcfmie.StatsSummary) {
      return _iaxcfmie.StatsSummary.fromJson(data) as T;
    }
    if (t == _i5dryx1t.WeatherDay) {
      return _i5dryx1t.WeatherDay.fromJson(data) as T;
    }
    if (t == _ivf1lbpe.WeatherForecast) {
      return _ivf1lbpe.WeatherForecast.fromJson(data) as T;
    }
    if (t == _i7z01835.WeatherSnapshot) {
      return _i7z01835.WeatherSnapshot.fromJson(data) as T;
    }
    if (t == _is.getType<_i2iwynut.AuthResult?>()) {
      return (data != null ? _i2iwynut.AuthResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3olc4tp.AuthToken?>()) {
      return (data != null ? _i3olc4tp.AuthToken.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihzw26wp.User?>()) {
      return (data != null ? _ihzw26wp.User.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipi876o6.HealthLog?>()) {
      return (data != null ? _ipi876o6.HealthLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isn947xq.DiaryEntry?>()) {
      return (data != null ? _isn947xq.DiaryEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i22rqx9f.EntryImage?>()) {
      return (data != null ? _i22rqx9f.EntryImage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iop7kemj.EntryImageView?>()) {
      return (data != null ? _iop7kemj.EntryImageView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ir6xzchz.ImageUploadTicket?>()) {
      return (data != null ? _ir6xzchz.ImageUploadTicket.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ie2xden6.Mood?>()) {
      return (data != null ? _ie2xden6.Mood.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i262ionk.Weather?>()) {
      return (data != null ? _i262ionk.Weather.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iylmodbg.Note?>()) {
      return (data != null ? _iylmodbg.Note.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iv4f5jvm.NoteChecklistItem?>()) {
      return (data != null ? _iv4f5jvm.NoteChecklistItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7hg4pp3.NoteDetail?>()) {
      return (data != null ? _i7hg4pp3.NoteDetail.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifh3czcz.NoteEntryLink?>()) {
      return (data != null ? _ifh3czcz.NoteEntryLink.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itmremj5.Event?>()) {
      return (data != null ? _itmremj5.Event.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixsuwyrb.ScheduleItem?>()) {
      return (data != null ? _ixsuwyrb.ScheduleItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ila1vkid.Todo?>()) {
      return (data != null ? _ila1vkid.Todo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivolu13p.DailyQuote?>()) {
      return (data != null ? _ivolu13p.DailyQuote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip1ndbg5.DailyQuotePair?>()) {
      return (data != null ? _ip1ndbg5.DailyQuotePair.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijvippl1.Quote?>()) {
      return (data != null ? _ijvippl1.Quote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie2y0yiy.Reflection?>()) {
      return (data != null ? _ie2y0yiy.Reflection.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyriup1i.SelfMessage?>()) {
      return (data != null ? _iyriup1i.SelfMessage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iatey69s.ApiException?>()) {
      return (data != null ? _iatey69s.ApiException.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idkvug70.GridCell?>()) {
      return (data != null ? _idkvug70.GridCell.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iaxcfmie.StatsSummary?>()) {
      return (data != null ? _iaxcfmie.StatsSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5dryx1t.WeatherDay?>()) {
      return (data != null ? _i5dryx1t.WeatherDay.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivf1lbpe.WeatherForecast?>()) {
      return (data != null ? _ivf1lbpe.WeatherForecast.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i7z01835.WeatherSnapshot?>()) {
      return (data != null ? _i7z01835.WeatherSnapshot.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iv4f5jvm.NoteChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_iv4f5jvm.NoteChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isn947xq.DiaryEntry>) {
      return (data as List)
              .map((e) => deserialize<_isn947xq.DiaryEntry>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i5dryx1t.WeatherDay>) {
      return (data as List)
              .map((e) => deserialize<_i5dryx1t.WeatherDay>(e))
              .toList()
          as T;
    }
    if (t == List<_ijdnq3k2.User>) {
      return (data as List).map((e) => deserialize<_ijdnq3k2.User>(e)).toList()
          as T;
    }
    if (t == List<_iv6p5134.Quote>) {
      return (data as List).map((e) => deserialize<_iv6p5134.Quote>(e)).toList()
          as T;
    }
    if (t == List<_izb6cxrd.HealthLog>) {
      return (data as List)
              .map((e) => deserialize<_izb6cxrd.HealthLog>(e))
              .toList()
          as T;
    }
    if (t == List<_irepgc45.DiaryEntry>) {
      return (data as List)
              .map((e) => deserialize<_irepgc45.DiaryEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_iqimgcp7.EntryImageView>) {
      return (data as List)
              .map((e) => deserialize<_iqimgcp7.EntryImageView>(e))
              .toList()
          as T;
    }
    if (t == List<_ivwgwn86.Mood>) {
      return (data as List).map((e) => deserialize<_ivwgwn86.Mood>(e)).toList()
          as T;
    }
    if (t == List<_i1e4r54y.Weather>) {
      return (data as List)
              .map((e) => deserialize<_i1e4r54y.Weather>(e))
              .toList()
          as T;
    }
    if (t == List<_ikw68uhq.Note>) {
      return (data as List).map((e) => deserialize<_ikw68uhq.Note>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i6aehc7v.NoteChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_i6aehc7v.NoteChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i6aehc7v.NoteChecklistItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i6aehc7v.NoteChecklistItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_is.UuidValue>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_is.UuidValue>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ispcnwj0.Event>) {
      return (data as List).map((e) => deserialize<_ispcnwj0.Event>(e)).toList()
          as T;
    }
    if (t == List<_i24him69.ScheduleItem>) {
      return (data as List)
              .map((e) => deserialize<_i24him69.ScheduleItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i88ur6fx.Todo>) {
      return (data as List).map((e) => deserialize<_i88ur6fx.Todo>(e)).toList()
          as T;
    }
    if (t == List<_iheiqx9t.DailyQuotePair>) {
      return (data as List)
              .map((e) => deserialize<_iheiqx9t.DailyQuotePair>(e))
              .toList()
          as T;
    }
    if (t == List<_i6c9evrp.Reflection>) {
      return (data as List)
              .map((e) => deserialize<_i6c9evrp.Reflection>(e))
              .toList()
          as T;
    }
    if (t == List<_in6lippz.SelfMessage>) {
      return (data as List)
              .map((e) => deserialize<_in6lippz.SelfMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_iq2zvbrw.GridCell>) {
      return (data as List)
              .map((e) => deserialize<_iq2zvbrw.GridCell>(e))
              .toList()
          as T;
    }
    if (t == List<_izbqdxvp.WeatherDay>) {
      return (data as List)
              .map((e) => deserialize<_izbqdxvp.WeatherDay>(e))
              .toList()
          as T;
    }
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2iwynut.AuthResult => 'AuthResult',
      _i3olc4tp.AuthToken => 'AuthToken',
      _ihzw26wp.User => 'User',
      _ipi876o6.HealthLog => 'HealthLog',
      _isn947xq.DiaryEntry => 'DiaryEntry',
      _i22rqx9f.EntryImage => 'EntryImage',
      _iop7kemj.EntryImageView => 'EntryImageView',
      _ir6xzchz.ImageUploadTicket => 'ImageUploadTicket',
      _ie2xden6.Mood => 'Mood',
      _i262ionk.Weather => 'Weather',
      _iylmodbg.Note => 'Note',
      _iv4f5jvm.NoteChecklistItem => 'NoteChecklistItem',
      _i7hg4pp3.NoteDetail => 'NoteDetail',
      _ifh3czcz.NoteEntryLink => 'NoteEntryLink',
      _itmremj5.Event => 'Event',
      _ixsuwyrb.ScheduleItem => 'ScheduleItem',
      _ila1vkid.Todo => 'Todo',
      _ivolu13p.DailyQuote => 'DailyQuote',
      _ip1ndbg5.DailyQuotePair => 'DailyQuotePair',
      _ijvippl1.Quote => 'Quote',
      _ie2y0yiy.Reflection => 'Reflection',
      _iyriup1i.SelfMessage => 'SelfMessage',
      _iatey69s.ApiException => 'ApiException',
      _idkvug70.GridCell => 'GridCell',
      _iaxcfmie.StatsSummary => 'StatsSummary',
      _i5dryx1t.WeatherDay => 'WeatherDay',
      _ivf1lbpe.WeatherForecast => 'WeatherForecast',
      _i7z01835.WeatherSnapshot => 'WeatherSnapshot',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'memoir_server.',
        '',
      );
    }

    switch (data) {
      case _i2iwynut.AuthResult():
        return 'AuthResult';
      case _i3olc4tp.AuthToken():
        return 'AuthToken';
      case _ihzw26wp.User():
        return 'User';
      case _ipi876o6.HealthLog():
        return 'HealthLog';
      case _isn947xq.DiaryEntry():
        return 'DiaryEntry';
      case _i22rqx9f.EntryImage():
        return 'EntryImage';
      case _iop7kemj.EntryImageView():
        return 'EntryImageView';
      case _ir6xzchz.ImageUploadTicket():
        return 'ImageUploadTicket';
      case _ie2xden6.Mood():
        return 'Mood';
      case _i262ionk.Weather():
        return 'Weather';
      case _iylmodbg.Note():
        return 'Note';
      case _iv4f5jvm.NoteChecklistItem():
        return 'NoteChecklistItem';
      case _i7hg4pp3.NoteDetail():
        return 'NoteDetail';
      case _ifh3czcz.NoteEntryLink():
        return 'NoteEntryLink';
      case _itmremj5.Event():
        return 'Event';
      case _ixsuwyrb.ScheduleItem():
        return 'ScheduleItem';
      case _ila1vkid.Todo():
        return 'Todo';
      case _ivolu13p.DailyQuote():
        return 'DailyQuote';
      case _ip1ndbg5.DailyQuotePair():
        return 'DailyQuotePair';
      case _ijvippl1.Quote():
        return 'Quote';
      case _ie2y0yiy.Reflection():
        return 'Reflection';
      case _iyriup1i.SelfMessage():
        return 'SelfMessage';
      case _iatey69s.ApiException():
        return 'ApiException';
      case _idkvug70.GridCell():
        return 'GridCell';
      case _iaxcfmie.StatsSummary():
        return 'StatsSummary';
      case _i5dryx1t.WeatherDay():
        return 'WeatherDay';
      case _ivf1lbpe.WeatherForecast():
        return 'WeatherForecast';
      case _i7z01835.WeatherSnapshot():
        return 'WeatherSnapshot';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthResult') {
      return deserialize<_i2iwynut.AuthResult>(data['data']);
    }
    if (dataClassName == 'AuthToken') {
      return deserialize<_i3olc4tp.AuthToken>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_ihzw26wp.User>(data['data']);
    }
    if (dataClassName == 'HealthLog') {
      return deserialize<_ipi876o6.HealthLog>(data['data']);
    }
    if (dataClassName == 'DiaryEntry') {
      return deserialize<_isn947xq.DiaryEntry>(data['data']);
    }
    if (dataClassName == 'EntryImage') {
      return deserialize<_i22rqx9f.EntryImage>(data['data']);
    }
    if (dataClassName == 'EntryImageView') {
      return deserialize<_iop7kemj.EntryImageView>(data['data']);
    }
    if (dataClassName == 'ImageUploadTicket') {
      return deserialize<_ir6xzchz.ImageUploadTicket>(data['data']);
    }
    if (dataClassName == 'Mood') {
      return deserialize<_ie2xden6.Mood>(data['data']);
    }
    if (dataClassName == 'Weather') {
      return deserialize<_i262ionk.Weather>(data['data']);
    }
    if (dataClassName == 'Note') {
      return deserialize<_iylmodbg.Note>(data['data']);
    }
    if (dataClassName == 'NoteChecklistItem') {
      return deserialize<_iv4f5jvm.NoteChecklistItem>(data['data']);
    }
    if (dataClassName == 'NoteDetail') {
      return deserialize<_i7hg4pp3.NoteDetail>(data['data']);
    }
    if (dataClassName == 'NoteEntryLink') {
      return deserialize<_ifh3czcz.NoteEntryLink>(data['data']);
    }
    if (dataClassName == 'Event') {
      return deserialize<_itmremj5.Event>(data['data']);
    }
    if (dataClassName == 'ScheduleItem') {
      return deserialize<_ixsuwyrb.ScheduleItem>(data['data']);
    }
    if (dataClassName == 'Todo') {
      return deserialize<_ila1vkid.Todo>(data['data']);
    }
    if (dataClassName == 'DailyQuote') {
      return deserialize<_ivolu13p.DailyQuote>(data['data']);
    }
    if (dataClassName == 'DailyQuotePair') {
      return deserialize<_ip1ndbg5.DailyQuotePair>(data['data']);
    }
    if (dataClassName == 'Quote') {
      return deserialize<_ijvippl1.Quote>(data['data']);
    }
    if (dataClassName == 'Reflection') {
      return deserialize<_ie2y0yiy.Reflection>(data['data']);
    }
    if (dataClassName == 'SelfMessage') {
      return deserialize<_iyriup1i.SelfMessage>(data['data']);
    }
    if (dataClassName == 'ApiException') {
      return deserialize<_iatey69s.ApiException>(data['data']);
    }
    if (dataClassName == 'GridCell') {
      return deserialize<_idkvug70.GridCell>(data['data']);
    }
    if (dataClassName == 'StatsSummary') {
      return deserialize<_iaxcfmie.StatsSummary>(data['data']);
    }
    if (dataClassName == 'WeatherDay') {
      return deserialize<_i5dryx1t.WeatherDay>(data['data']);
    }
    if (dataClassName == 'WeatherForecast') {
      return deserialize<_ivf1lbpe.WeatherForecast>(data['data']);
    }
    if (dataClassName == 'WeatherSnapshot') {
      return deserialize<_i7z01835.WeatherSnapshot>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3olc4tp.AuthToken:
        return _i3olc4tp.AuthToken.t;
      case _ihzw26wp.User:
        return _ihzw26wp.User.t;
      case _ipi876o6.HealthLog:
        return _ipi876o6.HealthLog.t;
      case _isn947xq.DiaryEntry:
        return _isn947xq.DiaryEntry.t;
      case _i22rqx9f.EntryImage:
        return _i22rqx9f.EntryImage.t;
      case _ie2xden6.Mood:
        return _ie2xden6.Mood.t;
      case _i262ionk.Weather:
        return _i262ionk.Weather.t;
      case _iylmodbg.Note:
        return _iylmodbg.Note.t;
      case _iv4f5jvm.NoteChecklistItem:
        return _iv4f5jvm.NoteChecklistItem.t;
      case _ifh3czcz.NoteEntryLink:
        return _ifh3czcz.NoteEntryLink.t;
      case _itmremj5.Event:
        return _itmremj5.Event.t;
      case _ixsuwyrb.ScheduleItem:
        return _ixsuwyrb.ScheduleItem.t;
      case _ila1vkid.Todo:
        return _ila1vkid.Todo.t;
      case _ivolu13p.DailyQuote:
        return _ivolu13p.DailyQuote.t;
      case _ijvippl1.Quote:
        return _ijvippl1.Quote.t;
      case _ie2y0yiy.Reflection:
        return _ie2y0yiy.Reflection.t;
      case _iyriup1i.SelfMessage:
        return _iyriup1i.SelfMessage.t;
      case _i7z01835.WeatherSnapshot:
        return _i7z01835.WeatherSnapshot.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'memoir_server';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
