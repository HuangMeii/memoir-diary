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
import 'package:memoir_server_server/src/generated/health/health_trend_point.dart'
    as _iycockxs;
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
import 'package:memoir_server_server/src/generated/route/journey.dart'
    as _idopqiek;
import 'package:memoir_server_server/src/generated/route/place_candidate.dart'
    as _ile7spz5;
import 'package:memoir_server_server/src/generated/route/route_departure_option.dart'
    as _i5y2yltz;
import 'package:memoir_server_server/src/generated/route/route_stop.dart'
    as _imxvpk9j;
import 'package:memoir_server_server/src/generated/route/route_weather_sample.dart'
    as _iiotk9u0;
import 'package:memoir_server_server/src/generated/stats/grid_cell.dart'
    as _iq2zvbrw;
import 'package:memoir_server_server/src/generated/weather/weather_day.dart'
    as _izbqdxvp;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'auth/auth_result.dart' as _i2iwynut;
import 'auth/auth_token.dart' as _i3olc4tp;
import 'auth/user.dart' as _ihzw26wp;
import 'health/health_activity.dart' as _ig3owv0r;
import 'health/health_day_overview.dart' as _if2dee0k;
import 'health/health_log.dart' as _ipi876o6;
import 'health/health_profile.dart' as _ik3vhv8i;
import 'health/health_trend_point.dart' as _ip5lfgde;
import 'health/health_water_entry.dart' as _imk6mzsq;
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
import 'route/journey.dart' as _is36joid;
import 'route/journey_detail.dart' as _iknanxwr;
import 'route/journey_stop.dart' as _igofjck1;
import 'route/journey_weather_point.dart' as _ibs4q8yo;
import 'route/place_candidate.dart' as _ino3yrjt;
import 'route/route_alert.dart' as _izwu4g79;
import 'route/route_alternative.dart' as _iidrek38;
import 'route/route_departure_option.dart' as _ixslv2d7;
import 'route/route_leg.dart' as _inhn4us6;
import 'route/route_plan.dart' as _ize64pbg;
import 'route/route_plan_with_weather.dart' as _i1mr55ne;
import 'route/route_stop.dart' as _ia9lknw1;
import 'route/route_weather_report.dart' as _ipvx79ch;
import 'route/route_weather_sample.dart' as _iodoclik;
import 'shared/api_exception.dart' as _iatey69s;
import 'stats/grid_cell.dart' as _idkvug70;
import 'stats/stats_summary.dart' as _iaxcfmie;
import 'weather/weather_day.dart' as _i5dryx1t;
import 'weather/weather_forecast.dart' as _ivf1lbpe;
import 'weather/weather_snapshot.dart' as _i7z01835;
export 'auth/auth_result.dart';
export 'auth/auth_token.dart';
export 'auth/user.dart';
export 'health/health_activity.dart';
export 'health/health_day_overview.dart';
export 'health/health_log.dart';
export 'health/health_profile.dart';
export 'health/health_trend_point.dart';
export 'health/health_water_entry.dart';
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
export 'route/journey.dart';
export 'route/journey_detail.dart';
export 'route/journey_stop.dart';
export 'route/journey_weather_point.dart';
export 'route/place_candidate.dart';
export 'route/route_alert.dart';
export 'route/route_alternative.dart';
export 'route/route_departure_option.dart';
export 'route/route_leg.dart';
export 'route/route_plan.dart';
export 'route/route_plan_with_weather.dart';
export 'route/route_stop.dart';
export 'route/route_weather_report.dart';
export 'route/route_weather_sample.dart';
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
      name: 'health_activities',
      dartName: 'HealthActivity',
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
          name: 'atTime',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'detail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'note\'',
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
          constraintName: 'health_activities_fk_0',
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
          indexName: 'idx_health_activity_user_date',
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
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'atTime',
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
          name: 'workoutType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'workoutIntensity',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepBedtime',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepWake',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepDeepMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepQuality',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepNote',
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
        _isp.IndexDefinition(
          indexName: 'idx_health_logs_user_date',
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
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'health_profiles',
      dartName: 'HealthProfile',
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
          name: 'heightCm',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'weightGoalKg',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'weightStartKg',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'stepsGoal',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '8000',
        ),
        _isp.ColumnDefinition(
          name: 'workoutGoalMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '60',
        ),
        _isp.ColumnDefinition(
          name: 'waterGoalMl',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '2000',
        ),
        _isp.ColumnDefinition(
          name: 'sleepGoalHours',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '8',
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
          constraintName: 'health_profiles_fk_0',
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
          indexName: 'health_profiles__userId__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
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
      name: 'health_water_entries',
      dartName: 'HealthWaterEntry',
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
          name: 'amountMl',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'recordedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
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
          constraintName: 'health_water_entries_fk_0',
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
          indexName: 'idx_health_water_user_date',
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
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'recordedAt',
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
      name: 'journey_stops',
      dartName: 'JourneyStop',
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
          name: 'journeyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'seq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'lat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'lon',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'dwellMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'arrivalAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'distanceFromStartMeters',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'journey_stops_fk_0',
          columns: ['journeyId'],
          referenceTable: 'journeys',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'journey_stops__journeyId__seq__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'journeyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'seq',
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
      name: 'journey_weather_points',
      dartName: 'JourneyWeatherPoint',
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
          name: 'journeyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'seq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'sampleAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'lon',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherGroup',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'tempC',
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
          name: 'precipitationProbability',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'windSpeedKmh',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
          constraintName: 'journey_weather_points_fk_0',
          columns: ['journeyId'],
          referenceTable: 'journeys',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'journey_weather_points__journeyId__seq__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'journeyId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'seq',
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
      name: 'journeys',
      dartName: 'Journey',
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
          name: 'vehicle',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'departureAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'originName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'originLat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'originLon',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'destinationName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'destinationLat',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'destinationLon',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'distanceMeters',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'durationSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'geometry',
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
          name: 'entryId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'weatherSavedAt',
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
          constraintName: 'journeys_fk_0',
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
    if (t == _ig3owv0r.HealthActivity) {
      return _ig3owv0r.HealthActivity.fromJson(data) as T;
    }
    if (t == _if2dee0k.HealthDayOverview) {
      return _if2dee0k.HealthDayOverview.fromJson(data) as T;
    }
    if (t == _ipi876o6.HealthLog) {
      return _ipi876o6.HealthLog.fromJson(data) as T;
    }
    if (t == _ik3vhv8i.HealthProfile) {
      return _ik3vhv8i.HealthProfile.fromJson(data) as T;
    }
    if (t == _ip5lfgde.HealthTrendPoint) {
      return _ip5lfgde.HealthTrendPoint.fromJson(data) as T;
    }
    if (t == _imk6mzsq.HealthWaterEntry) {
      return _imk6mzsq.HealthWaterEntry.fromJson(data) as T;
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
    if (t == _is36joid.Journey) {
      return _is36joid.Journey.fromJson(data) as T;
    }
    if (t == _iknanxwr.JourneyDetail) {
      return _iknanxwr.JourneyDetail.fromJson(data) as T;
    }
    if (t == _igofjck1.JourneyStop) {
      return _igofjck1.JourneyStop.fromJson(data) as T;
    }
    if (t == _ibs4q8yo.JourneyWeatherPoint) {
      return _ibs4q8yo.JourneyWeatherPoint.fromJson(data) as T;
    }
    if (t == _ino3yrjt.PlaceCandidate) {
      return _ino3yrjt.PlaceCandidate.fromJson(data) as T;
    }
    if (t == _izwu4g79.RouteAlert) {
      return _izwu4g79.RouteAlert.fromJson(data) as T;
    }
    if (t == _iidrek38.RouteAlternative) {
      return _iidrek38.RouteAlternative.fromJson(data) as T;
    }
    if (t == _ixslv2d7.RouteDepartureOption) {
      return _ixslv2d7.RouteDepartureOption.fromJson(data) as T;
    }
    if (t == _inhn4us6.RouteLeg) {
      return _inhn4us6.RouteLeg.fromJson(data) as T;
    }
    if (t == _ize64pbg.RoutePlan) {
      return _ize64pbg.RoutePlan.fromJson(data) as T;
    }
    if (t == _i1mr55ne.RoutePlanWithWeather) {
      return _i1mr55ne.RoutePlanWithWeather.fromJson(data) as T;
    }
    if (t == _ia9lknw1.RouteStop) {
      return _ia9lknw1.RouteStop.fromJson(data) as T;
    }
    if (t == _ipvx79ch.RouteWeatherReport) {
      return _ipvx79ch.RouteWeatherReport.fromJson(data) as T;
    }
    if (t == _iodoclik.RouteWeatherSample) {
      return _iodoclik.RouteWeatherSample.fromJson(data) as T;
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
    if (t == _is.getType<_ig3owv0r.HealthActivity?>()) {
      return (data != null ? _ig3owv0r.HealthActivity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if2dee0k.HealthDayOverview?>()) {
      return (data != null ? _if2dee0k.HealthDayOverview.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ipi876o6.HealthLog?>()) {
      return (data != null ? _ipi876o6.HealthLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ik3vhv8i.HealthProfile?>()) {
      return (data != null ? _ik3vhv8i.HealthProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip5lfgde.HealthTrendPoint?>()) {
      return (data != null ? _ip5lfgde.HealthTrendPoint.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imk6mzsq.HealthWaterEntry?>()) {
      return (data != null ? _imk6mzsq.HealthWaterEntry.fromJson(data) : null)
          as T;
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
    if (t == _is.getType<_is36joid.Journey?>()) {
      return (data != null ? _is36joid.Journey.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iknanxwr.JourneyDetail?>()) {
      return (data != null ? _iknanxwr.JourneyDetail.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igofjck1.JourneyStop?>()) {
      return (data != null ? _igofjck1.JourneyStop.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibs4q8yo.JourneyWeatherPoint?>()) {
      return (data != null
              ? _ibs4q8yo.JourneyWeatherPoint.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ino3yrjt.PlaceCandidate?>()) {
      return (data != null ? _ino3yrjt.PlaceCandidate.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izwu4g79.RouteAlert?>()) {
      return (data != null ? _izwu4g79.RouteAlert.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iidrek38.RouteAlternative?>()) {
      return (data != null ? _iidrek38.RouteAlternative.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixslv2d7.RouteDepartureOption?>()) {
      return (data != null
              ? _ixslv2d7.RouteDepartureOption.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_inhn4us6.RouteLeg?>()) {
      return (data != null ? _inhn4us6.RouteLeg.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ize64pbg.RoutePlan?>()) {
      return (data != null ? _ize64pbg.RoutePlan.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1mr55ne.RoutePlanWithWeather?>()) {
      return (data != null
              ? _i1mr55ne.RoutePlanWithWeather.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ia9lknw1.RouteStop?>()) {
      return (data != null ? _ia9lknw1.RouteStop.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipvx79ch.RouteWeatherReport?>()) {
      return (data != null ? _ipvx79ch.RouteWeatherReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iodoclik.RouteWeatherSample?>()) {
      return (data != null ? _iodoclik.RouteWeatherSample.fromJson(data) : null)
          as T;
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
    if (t == List<_imk6mzsq.HealthWaterEntry>) {
      return (data as List)
              .map((e) => deserialize<_imk6mzsq.HealthWaterEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_ig3owv0r.HealthActivity>) {
      return (data as List)
              .map((e) => deserialize<_ig3owv0r.HealthActivity>(e))
              .toList()
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
    if (t == List<_igofjck1.JourneyStop>) {
      return (data as List)
              .map((e) => deserialize<_igofjck1.JourneyStop>(e))
              .toList()
          as T;
    }
    if (t == List<_ibs4q8yo.JourneyWeatherPoint>) {
      return (data as List)
              .map((e) => deserialize<_ibs4q8yo.JourneyWeatherPoint>(e))
              .toList()
          as T;
    }
    if (t == List<_ia9lknw1.RouteStop>) {
      return (data as List)
              .map((e) => deserialize<_ia9lknw1.RouteStop>(e))
              .toList()
          as T;
    }
    if (t == List<_inhn4us6.RouteLeg>) {
      return (data as List)
              .map((e) => deserialize<_inhn4us6.RouteLeg>(e))
              .toList()
          as T;
    }
    if (t == List<_iidrek38.RouteAlternative>) {
      return (data as List)
              .map((e) => deserialize<_iidrek38.RouteAlternative>(e))
              .toList()
          as T;
    }
    if (t == List<_iodoclik.RouteWeatherSample>) {
      return (data as List)
              .map((e) => deserialize<_iodoclik.RouteWeatherSample>(e))
              .toList()
          as T;
    }
    if (t == List<_izwu4g79.RouteAlert>) {
      return (data as List)
              .map((e) => deserialize<_izwu4g79.RouteAlert>(e))
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
    if (t == List<_iycockxs.HealthTrendPoint>) {
      return (data as List)
              .map((e) => deserialize<_iycockxs.HealthTrendPoint>(e))
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
    if (t == List<_idopqiek.Journey>) {
      return (data as List)
              .map((e) => deserialize<_idopqiek.Journey>(e))
              .toList()
          as T;
    }
    if (t == List<_imxvpk9j.RouteStop>) {
      return (data as List)
              .map((e) => deserialize<_imxvpk9j.RouteStop>(e))
              .toList()
          as T;
    }
    if (t == List<_iiotk9u0.RouteWeatherSample>) {
      return (data as List)
              .map((e) => deserialize<_iiotk9u0.RouteWeatherSample>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_iiotk9u0.RouteWeatherSample>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iiotk9u0.RouteWeatherSample>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ile7spz5.PlaceCandidate>) {
      return (data as List)
              .map((e) => deserialize<_ile7spz5.PlaceCandidate>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_imxvpk9j.RouteStop>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_imxvpk9j.RouteStop>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i5y2yltz.RouteDepartureOption>) {
      return (data as List)
              .map((e) => deserialize<_i5y2yltz.RouteDepartureOption>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _is.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
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
      _ig3owv0r.HealthActivity => 'HealthActivity',
      _if2dee0k.HealthDayOverview => 'HealthDayOverview',
      _ipi876o6.HealthLog => 'HealthLog',
      _ik3vhv8i.HealthProfile => 'HealthProfile',
      _ip5lfgde.HealthTrendPoint => 'HealthTrendPoint',
      _imk6mzsq.HealthWaterEntry => 'HealthWaterEntry',
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
      _is36joid.Journey => 'Journey',
      _iknanxwr.JourneyDetail => 'JourneyDetail',
      _igofjck1.JourneyStop => 'JourneyStop',
      _ibs4q8yo.JourneyWeatherPoint => 'JourneyWeatherPoint',
      _ino3yrjt.PlaceCandidate => 'PlaceCandidate',
      _izwu4g79.RouteAlert => 'RouteAlert',
      _iidrek38.RouteAlternative => 'RouteAlternative',
      _ixslv2d7.RouteDepartureOption => 'RouteDepartureOption',
      _inhn4us6.RouteLeg => 'RouteLeg',
      _ize64pbg.RoutePlan => 'RoutePlan',
      _i1mr55ne.RoutePlanWithWeather => 'RoutePlanWithWeather',
      _ia9lknw1.RouteStop => 'RouteStop',
      _ipvx79ch.RouteWeatherReport => 'RouteWeatherReport',
      _iodoclik.RouteWeatherSample => 'RouteWeatherSample',
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
      case _ig3owv0r.HealthActivity():
        return 'HealthActivity';
      case _if2dee0k.HealthDayOverview():
        return 'HealthDayOverview';
      case _ipi876o6.HealthLog():
        return 'HealthLog';
      case _ik3vhv8i.HealthProfile():
        return 'HealthProfile';
      case _ip5lfgde.HealthTrendPoint():
        return 'HealthTrendPoint';
      case _imk6mzsq.HealthWaterEntry():
        return 'HealthWaterEntry';
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
      case _is36joid.Journey():
        return 'Journey';
      case _iknanxwr.JourneyDetail():
        return 'JourneyDetail';
      case _igofjck1.JourneyStop():
        return 'JourneyStop';
      case _ibs4q8yo.JourneyWeatherPoint():
        return 'JourneyWeatherPoint';
      case _ino3yrjt.PlaceCandidate():
        return 'PlaceCandidate';
      case _izwu4g79.RouteAlert():
        return 'RouteAlert';
      case _iidrek38.RouteAlternative():
        return 'RouteAlternative';
      case _ixslv2d7.RouteDepartureOption():
        return 'RouteDepartureOption';
      case _inhn4us6.RouteLeg():
        return 'RouteLeg';
      case _ize64pbg.RoutePlan():
        return 'RoutePlan';
      case _i1mr55ne.RoutePlanWithWeather():
        return 'RoutePlanWithWeather';
      case _ia9lknw1.RouteStop():
        return 'RouteStop';
      case _ipvx79ch.RouteWeatherReport():
        return 'RouteWeatherReport';
      case _iodoclik.RouteWeatherSample():
        return 'RouteWeatherSample';
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
    if (dataClassName == 'HealthActivity') {
      return deserialize<_ig3owv0r.HealthActivity>(data['data']);
    }
    if (dataClassName == 'HealthDayOverview') {
      return deserialize<_if2dee0k.HealthDayOverview>(data['data']);
    }
    if (dataClassName == 'HealthLog') {
      return deserialize<_ipi876o6.HealthLog>(data['data']);
    }
    if (dataClassName == 'HealthProfile') {
      return deserialize<_ik3vhv8i.HealthProfile>(data['data']);
    }
    if (dataClassName == 'HealthTrendPoint') {
      return deserialize<_ip5lfgde.HealthTrendPoint>(data['data']);
    }
    if (dataClassName == 'HealthWaterEntry') {
      return deserialize<_imk6mzsq.HealthWaterEntry>(data['data']);
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
    if (dataClassName == 'Journey') {
      return deserialize<_is36joid.Journey>(data['data']);
    }
    if (dataClassName == 'JourneyDetail') {
      return deserialize<_iknanxwr.JourneyDetail>(data['data']);
    }
    if (dataClassName == 'JourneyStop') {
      return deserialize<_igofjck1.JourneyStop>(data['data']);
    }
    if (dataClassName == 'JourneyWeatherPoint') {
      return deserialize<_ibs4q8yo.JourneyWeatherPoint>(data['data']);
    }
    if (dataClassName == 'PlaceCandidate') {
      return deserialize<_ino3yrjt.PlaceCandidate>(data['data']);
    }
    if (dataClassName == 'RouteAlert') {
      return deserialize<_izwu4g79.RouteAlert>(data['data']);
    }
    if (dataClassName == 'RouteAlternative') {
      return deserialize<_iidrek38.RouteAlternative>(data['data']);
    }
    if (dataClassName == 'RouteDepartureOption') {
      return deserialize<_ixslv2d7.RouteDepartureOption>(data['data']);
    }
    if (dataClassName == 'RouteLeg') {
      return deserialize<_inhn4us6.RouteLeg>(data['data']);
    }
    if (dataClassName == 'RoutePlan') {
      return deserialize<_ize64pbg.RoutePlan>(data['data']);
    }
    if (dataClassName == 'RoutePlanWithWeather') {
      return deserialize<_i1mr55ne.RoutePlanWithWeather>(data['data']);
    }
    if (dataClassName == 'RouteStop') {
      return deserialize<_ia9lknw1.RouteStop>(data['data']);
    }
    if (dataClassName == 'RouteWeatherReport') {
      return deserialize<_ipvx79ch.RouteWeatherReport>(data['data']);
    }
    if (dataClassName == 'RouteWeatherSample') {
      return deserialize<_iodoclik.RouteWeatherSample>(data['data']);
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
      case _ig3owv0r.HealthActivity:
        return _ig3owv0r.HealthActivity.t;
      case _ipi876o6.HealthLog:
        return _ipi876o6.HealthLog.t;
      case _ik3vhv8i.HealthProfile:
        return _ik3vhv8i.HealthProfile.t;
      case _imk6mzsq.HealthWaterEntry:
        return _imk6mzsq.HealthWaterEntry.t;
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
      case _is36joid.Journey:
        return _is36joid.Journey.t;
      case _igofjck1.JourneyStop:
        return _igofjck1.JourneyStop.t;
      case _ibs4q8yo.JourneyWeatherPoint:
        return _ibs4q8yo.JourneyWeatherPoint.t;
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
