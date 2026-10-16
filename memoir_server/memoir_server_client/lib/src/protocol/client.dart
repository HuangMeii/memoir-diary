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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:memoir_server_client/src/protocol/auth/auth_result.dart'
    as _irsh1fu5;
import 'package:memoir_server_client/src/protocol/auth/user.dart' as _i0oax80e;
import 'package:memoir_server_client/src/protocol/health/health_log.dart'
    as _ikfsn92p;
import 'package:memoir_server_client/src/protocol/journal/diary_entry.dart'
    as _i7ztga34;
import 'package:memoir_server_client/src/protocol/journal/entry_image.dart'
    as _ij0vjl03;
import 'package:memoir_server_client/src/protocol/journal/entry_image_view.dart'
    as _itedwayj;
import 'package:memoir_server_client/src/protocol/journal/image_upload_ticket.dart'
    as _i2nv2rse;
import 'package:memoir_server_client/src/protocol/lookups/mood.dart'
    as _i7s3fkt2;
import 'package:memoir_server_client/src/protocol/lookups/weather.dart'
    as _icswdq95;
import 'package:memoir_server_client/src/protocol/notes/note.dart' as _i8gjk5qx;
import 'package:memoir_server_client/src/protocol/notes/note_checklist_item.dart'
    as _izn2v3c7;
import 'package:memoir_server_client/src/protocol/notes/note_detail.dart'
    as _iz4r32s3;
import 'package:memoir_server_client/src/protocol/planner/event.dart'
    as _ijprwagz;
import 'package:memoir_server_client/src/protocol/planner/schedule_item.dart'
    as _ijhdkgyn;
import 'package:memoir_server_client/src/protocol/planner/todo.dart'
    as _isxzecl5;
import 'package:memoir_server_client/src/protocol/quotes/daily_quote_pair.dart'
    as _i9w1lcsl;
import 'package:memoir_server_client/src/protocol/quotes/quote.dart'
    as _igszo10w;
import 'package:memoir_server_client/src/protocol/quotes/reflection.dart'
    as _ivmwvttz;
import 'package:memoir_server_client/src/protocol/quotes/self_message.dart'
    as _i4smoveg;
import 'package:memoir_server_client/src/protocol/route/journey.dart'
    as _i8cgeaon;
import 'package:memoir_server_client/src/protocol/route/journey_detail.dart'
    as _irr74z0a;
import 'package:memoir_server_client/src/protocol/route/place_candidate.dart'
    as _i972nhj2;
import 'package:memoir_server_client/src/protocol/route/route_departure_option.dart'
    as _ia1gr6j3;
import 'package:memoir_server_client/src/protocol/route/route_plan.dart'
    as _ivfcqbu8;
import 'package:memoir_server_client/src/protocol/route/route_plan_with_weather.dart'
    as _idn1z7ab;
import 'package:memoir_server_client/src/protocol/route/route_stop.dart'
    as _isj44i7w;
import 'package:memoir_server_client/src/protocol/route/route_weather_report.dart'
    as _iaiilleq;
import 'package:memoir_server_client/src/protocol/route/route_weather_sample.dart'
    as _iw3tlfli;
import 'package:memoir_server_client/src/protocol/stats/grid_cell.dart'
    as _idxtic5g;
import 'package:memoir_server_client/src/protocol/stats/stats_summary.dart'
    as _iei6d93o;
import 'package:memoir_server_client/src/protocol/weather/weather_day.dart'
    as _ituibxbp;
import 'package:memoir_server_client/src/protocol/weather/weather_forecast.dart'
    as _i4p3ynlu;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// Admin-only operations, mirroring FastAPI `/admin`.
///
/// The endpoint requires the `admin` scope; a regular user is refused before
/// any method body runs.
/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _ida.Future<List<_i0oax80e.User>> listUsers() =>
      caller.callServerEndpoint<List<_i0oax80e.User>>(
        'admin',
        'listUsers',
        {},
      );

  _ida.Future<_i0oax80e.User> setUserActive({
    required _isc.UuidValue id,
    required bool isActive,
  }) => caller.callServerEndpoint<_i0oax80e.User>(
    'admin',
    'setUserActive',
    {
      'id': id,
      'isActive': isActive,
    },
  );

  /// Promotes/demotes a user. `role` is `user` or `admin`.
  _ida.Future<_i0oax80e.User> setUserRole({
    required _isc.UuidValue id,
    required String role,
  }) => caller.callServerEndpoint<_i0oax80e.User>(
    'admin',
    'setUserRole',
    {
      'id': id,
      'role': role,
    },
  );

  /// System quotes have a null owner and are visible to everyone.
  _ida.Future<List<_igszo10w.Quote>> systemQuotes() =>
      caller.callServerEndpoint<List<_igszo10w.Quote>>(
        'admin',
        'systemQuotes',
        {},
      );

  _ida.Future<_igszo10w.Quote> createSystemQuote({
    required String text,
    String? author,
    String? source,
    String? category,
  }) => caller.callServerEndpoint<_igszo10w.Quote>(
    'admin',
    'createSystemQuote',
    {
      'text': text,
      'author': author,
      'source': source,
      'category': category,
    },
  );

  _ida.Future<_igszo10w.Quote> updateSystemQuote({
    required _isc.UuidValue id,
    String? text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
  }) => caller.callServerEndpoint<_igszo10w.Quote>(
    'admin',
    'updateSystemQuote',
    {
      'id': id,
      'text': text,
      'author': author,
      'source': source,
      'category': category,
      'isActive': isActive,
    },
  );

  _ida.Future<void> deleteSystemQuote(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'admin',
        'deleteSystemQuote',
        {'id': id},
      );
}

/// Authentication endpoints, mirroring FastAPI `/auth/*`.
///
/// `register`/`login` are public, so the endpoint itself does not require a
/// login; [me] and [logout] check the session explicitly.
/// {@category Endpoint}
class EndpointAuth extends _isc.EndpointRef {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  _ida.Future<_irsh1fu5.AuthResult> register({
    required String email,
    required String username,
    required String password,
    String? displayName,
  }) => caller.callServerEndpoint<_irsh1fu5.AuthResult>(
    'auth',
    'register',
    {
      'email': email,
      'username': username,
      'password': password,
      'displayName': displayName,
    },
  );

  _ida.Future<_irsh1fu5.AuthResult> login({
    required String username,
    required String password,
  }) => caller.callServerEndpoint<_irsh1fu5.AuthResult>(
    'auth',
    'login',
    {
      'username': username,
      'password': password,
    },
  );

  _ida.Future<_i0oax80e.User> me() => caller.callServerEndpoint<_i0oax80e.User>(
    'auth',
    'me',
    {},
  );

  /// Revokes the token used for this call.
  _ida.Future<void> logout() => caller.callServerEndpoint<void>(
    'auth',
    'logout',
    {},
  );
}

/// Health log CRUD, mirroring FastAPI `/health-logs`.
/// {@category Endpoint}
class EndpointHealth extends _isc.EndpointRef {
  EndpointHealth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  _ida.Future<List<_ikfsn92p.HealthLog>> list({
    required DateTime from,
    required DateTime to,
  }) => caller.callServerEndpoint<List<_ikfsn92p.HealthLog>>(
    'health',
    'list',
    {
      'from': from,
      'to': to,
    },
  );

  /// Upserts the day's log, so the form can be submitted repeatedly.
  _ida.Future<_ikfsn92p.HealthLog> save({
    required DateTime logDate,
    int? steps,
    int? workoutMinutes,
    int? waterMl,
    double? sleepHours,
    double? weightKg,
    String? note,
  }) => caller.callServerEndpoint<_ikfsn92p.HealthLog>(
    'health',
    'save',
    {
      'logDate': logDate,
      'steps': steps,
      'workoutMinutes': workoutMinutes,
      'waterMl': waterMl,
      'sleepHours': sleepHours,
      'weightKg': weightKg,
      'note': note,
    },
  );
}

/// Diary entry CRUD, mirroring FastAPI `/entries`.
/// {@category Endpoint}
class EndpointEntries extends _isc.EndpointRef {
  EndpointEntries(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'entries';

  _ida.Future<List<_i7ztga34.DiaryEntry>> list({
    String? month,
    DateTime? from,
    DateTime? to,
  }) => caller.callServerEndpoint<List<_i7ztga34.DiaryEntry>>(
    'entries',
    'list',
    {
      'month': month,
      'from': from,
      'to': to,
    },
  );

  _ida.Future<_i7ztga34.DiaryEntry?> get(_isc.UuidValue id) =>
      caller.callServerEndpoint<_i7ztga34.DiaryEntry?>(
        'entries',
        'get',
        {'id': id},
      );

  _ida.Future<_i7ztga34.DiaryEntry?> byDate(String isoDate) =>
      caller.callServerEndpoint<_i7ztga34.DiaryEntry?>(
        'entries',
        'byDate',
        {'isoDate': isoDate},
      );

  _ida.Future<_i7ztga34.DiaryEntry> create({
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
  }) => caller.callServerEndpoint<_i7ztga34.DiaryEntry>(
    'entries',
    'create',
    {
      'entryDate': entryDate,
      'moodId': moodId,
      'weatherId': weatherId,
      'diaryText': diaryText,
      'otherPerspective': otherPerspective,
      'futureMessage': futureMessage,
      'selfCare': selfCare,
      'tomorrowHope': tomorrowHope,
      'gratitude': gratitude,
      'dream': dream,
    },
  );

  _ida.Future<_i7ztga34.DiaryEntry> update({
    required _isc.UuidValue id,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
  }) => caller.callServerEndpoint<_i7ztga34.DiaryEntry>(
    'entries',
    'update',
    {
      'id': id,
      'moodId': moodId,
      'weatherId': weatherId,
      'diaryText': diaryText,
      'otherPerspective': otherPerspective,
      'futureMessage': futureMessage,
      'selfCare': selfCare,
      'tomorrowHope': tomorrowHope,
      'gratitude': gratitude,
      'dream': dream,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'entries',
        'delete',
        {'id': id},
      );
}

/// Entry image upload and gallery, mirroring FastAPI `/entries/{id}/images`.
///
/// Flow: [createUploadDescription] -> client uploads to that URL ->
/// [confirmUpload] verifies and stores the metadata row.
/// {@category Endpoint}
class EndpointImages extends _isc.EndpointRef {
  EndpointImages(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'images';

  _ida.Future<_i2nv2rse.ImageUploadTicket> createUploadDescription({
    required _isc.UuidValue entryId,
    required String filename,
  }) => caller.callServerEndpoint<_i2nv2rse.ImageUploadTicket>(
    'images',
    'createUploadDescription',
    {
      'entryId': entryId,
      'filename': filename,
    },
  );

  _ida.Future<_ij0vjl03.EntryImage> confirmUpload({
    required _isc.UuidValue entryId,
    required String objectKey,
    String? contentType,
    int? sizeBytes,
    int? width,
    int? height,
    String? caption,
  }) => caller.callServerEndpoint<_ij0vjl03.EntryImage>(
    'images',
    'confirmUpload',
    {
      'entryId': entryId,
      'objectKey': objectKey,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'width': width,
      'height': height,
      'caption': caption,
    },
  );

  /// Returns the entry's images each with a short-lived download URL. A
  /// missing object does not hide the rest of the gallery.
  _ida.Future<List<_itedwayj.EntryImageView>> forEntry(
    _isc.UuidValue entryId,
  ) => caller.callServerEndpoint<List<_itedwayj.EntryImageView>>(
    'images',
    'forEntry',
    {'entryId': entryId},
  );

  _ida.Future<void> delete(_isc.UuidValue imageId) =>
      caller.callServerEndpoint<void>(
        'images',
        'delete',
        {'imageId': imageId},
      );
}

/// Mood and weather lookups. Public: the login screen needs them too.
/// {@category Endpoint}
class EndpointLookups extends _isc.EndpointRef {
  EndpointLookups(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'lookups';

  _ida.Future<List<_i7s3fkt2.Mood>> moods() =>
      caller.callServerEndpoint<List<_i7s3fkt2.Mood>>(
        'lookups',
        'moods',
        {},
      );

  _ida.Future<List<_icswdq95.Weather>> weathers() =>
      caller.callServerEndpoint<List<_icswdq95.Weather>>(
        'lookups',
        'weathers',
        {},
      );
}

/// Quick notes CRUD, mirroring FastAPI `/notes`.
///
/// Supports title, tags, pin/archive/trash flags, interactive checklist
/// ([NoteChecklistItem]) and many-to-many diary links ([NoteEntryLink]).
/// {@category Endpoint}
class EndpointNotes extends _isc.EndpointRef {
  EndpointNotes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notes';

  _ida.Future<List<_i8gjk5qx.Note>> list({
    required bool includeArchived,
    required bool trashedOnly,
  }) => caller.callServerEndpoint<List<_i8gjk5qx.Note>>(
    'notes',
    'list',
    {
      'includeArchived': includeArchived,
      'trashedOnly': trashedOnly,
    },
  );

  _ida.Future<_iz4r32s3.NoteDetail> get(_isc.UuidValue id) =>
      caller.callServerEndpoint<_iz4r32s3.NoteDetail>(
        'notes',
        'get',
        {'id': id},
      );

  _ida.Future<_i8gjk5qx.Note> create({
    required String content,
    String? title,
    String? color,
    List<String>? tags,
    bool? isPinned,
    List<_izn2v3c7.NoteChecklistItem>? checklist,
    List<_isc.UuidValue>? entryIds,
  }) => caller.callServerEndpoint<_i8gjk5qx.Note>(
    'notes',
    'create',
    {
      'content': content,
      'title': title,
      'color': color,
      'tags': tags,
      'isPinned': isPinned,
      'checklist': checklist,
      'entryIds': entryIds,
    },
  );

  _ida.Future<_i8gjk5qx.Note> update({
    required _isc.UuidValue id,
    String? title,
    String? content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
    List<_izn2v3c7.NoteChecklistItem>? checklist,
    List<_isc.UuidValue>? entryIds,
  }) => caller.callServerEndpoint<_i8gjk5qx.Note>(
    'notes',
    'update',
    {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'tags': tags,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'isTrashed': isTrashed,
      'checklist': checklist,
      'entryIds': entryIds,
    },
  );

  _ida.Future<void> restore(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'notes',
        'restore',
        {'id': id},
      );

  _ida.Future<_i8gjk5qx.Note> archive(
    _isc.UuidValue id,
    bool isArchived,
  ) => caller.callServerEndpoint<_i8gjk5qx.Note>(
    'notes',
    'archive',
    {
      'id': id,
      'isArchived': isArchived,
    },
  );

  _ida.Future<void> purge(_isc.UuidValue id) => caller.callServerEndpoint<void>(
    'notes',
    'purge',
    {'id': id},
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'notes',
        'delete',
        {'id': id},
      );
}

/// Special event CRUD, mirroring FastAPI `/events`.
/// {@category Endpoint}
class EndpointEvents extends _isc.EndpointRef {
  EndpointEvents(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'events';

  _ida.Future<List<_ijprwagz.Event>> list({
    DateTime? from,
    DateTime? to,
  }) => caller.callServerEndpoint<List<_ijprwagz.Event>>(
    'events',
    'list',
    {
      'from': from,
      'to': to,
    },
  );

  _ida.Future<_ijprwagz.Event> create({
    required String title,
    required DateTime startAt,
    String? description,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
  }) => caller.callServerEndpoint<_ijprwagz.Event>(
    'events',
    'create',
    {
      'title': title,
      'startAt': startAt,
      'description': description,
      'endAt': endAt,
      'location': location,
      'isAllDay': isAllDay,
      'reminderMinutes': reminderMinutes,
    },
  );

  _ida.Future<_ijprwagz.Event> update({
    required _isc.UuidValue id,
    String? title,
    String? description,
    DateTime? startAt,
    DateTime? endAt,
    String? location,
    bool? isAllDay,
    int? reminderMinutes,
  }) => caller.callServerEndpoint<_ijprwagz.Event>(
    'events',
    'update',
    {
      'id': id,
      'title': title,
      'description': description,
      'startAt': startAt,
      'endAt': endAt,
      'location': location,
      'isAllDay': isAllDay,
      'reminderMinutes': reminderMinutes,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'events',
        'delete',
        {'id': id},
      );
}

/// Schedule (timetable) item CRUD, mirroring FastAPI `/schedule-items`.
/// {@category Endpoint}
class EndpointSchedules extends _isc.EndpointRef {
  EndpointSchedules(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'schedules';

  _ida.Future<List<_ijhdkgyn.ScheduleItem>> list() =>
      caller.callServerEndpoint<List<_ijhdkgyn.ScheduleItem>>(
        'schedules',
        'list',
        {},
      );

  _ida.Future<_ijhdkgyn.ScheduleItem> create({
    required String title,
    required DateTime startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
  }) => caller.callServerEndpoint<_ijhdkgyn.ScheduleItem>(
    'schedules',
    'create',
    {
      'title': title,
      'startAt': startAt,
      'endAt': endAt,
      'recurrenceRule': recurrenceRule,
      'reminderMinutes': reminderMinutes,
    },
  );

  _ida.Future<_ijhdkgyn.ScheduleItem> update({
    required _isc.UuidValue id,
    String? title,
    DateTime? startAt,
    DateTime? endAt,
    String? recurrenceRule,
    int? reminderMinutes,
  }) => caller.callServerEndpoint<_ijhdkgyn.ScheduleItem>(
    'schedules',
    'update',
    {
      'id': id,
      'title': title,
      'startAt': startAt,
      'endAt': endAt,
      'recurrenceRule': recurrenceRule,
      'reminderMinutes': reminderMinutes,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'schedules',
        'delete',
        {'id': id},
      );
}

/// Weekly goal / todo CRUD, mirroring FastAPI `/todos`.
/// {@category Endpoint}
class EndpointTodos extends _isc.EndpointRef {
  EndpointTodos(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'todos';

  _ida.Future<List<_isxzecl5.Todo>> list({String? weekLabel}) =>
      caller.callServerEndpoint<List<_isxzecl5.Todo>>(
        'todos',
        'list',
        {'weekLabel': weekLabel},
      );

  _ida.Future<_isxzecl5.Todo> create({
    required String title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
  }) => caller.callServerEndpoint<_isxzecl5.Todo>(
    'todos',
    'create',
    {
      'title': title,
      'notes': notes,
      'dueDate': dueDate,
      'weekLabel': weekLabel,
      'priority': priority,
    },
  );

  _ida.Future<_isxzecl5.Todo> update({
    required _isc.UuidValue id,
    String? title,
    String? notes,
    DateTime? dueDate,
    String? weekLabel,
    int? priority,
    bool? isDone,
  }) => caller.callServerEndpoint<_isxzecl5.Todo>(
    'todos',
    'update',
    {
      'id': id,
      'title': title,
      'notes': notes,
      'dueDate': dueDate,
      'weekLabel': weekLabel,
      'priority': priority,
      'isDone': isDone,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'todos',
        'delete',
        {'id': id},
      );
}

/// Daily quote pair, mirroring FastAPI `/daily-quotes`.
/// {@category Endpoint}
class EndpointDailyQuotes extends _isc.EndpointRef {
  EndpointDailyQuotes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dailyQuotes';

  _ida.Future<_i9w1lcsl.DailyQuotePair> today() =>
      caller.callServerEndpoint<_i9w1lcsl.DailyQuotePair>(
        'dailyQuotes',
        'today',
        {},
      );

  _ida.Future<List<_i9w1lcsl.DailyQuotePair>> history({
    required String month,
  }) => caller.callServerEndpoint<List<_i9w1lcsl.DailyQuotePair>>(
    'dailyQuotes',
    'history',
    {'month': month},
  );

  /// Drops the stored pair for the day and draws a new one.
  _ida.Future<_i9w1lcsl.DailyQuotePair> reshuffle(_isc.UuidValue id) =>
      caller.callServerEndpoint<_i9w1lcsl.DailyQuotePair>(
        'dailyQuotes',
        'reshuffle',
        {'id': id},
      );
}

/// Quote library CRUD, mirroring FastAPI `/quotes`.
///
/// System quotes (null owner) are read-only here; admins manage them through
/// the admin endpoint.
/// {@category Endpoint}
class EndpointQuotes extends _isc.EndpointRef {
  EndpointQuotes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'quotes';

  _ida.Future<List<_igszo10w.Quote>> list({String? category}) =>
      caller.callServerEndpoint<List<_igszo10w.Quote>>(
        'quotes',
        'list',
        {'category': category},
      );

  _ida.Future<_igszo10w.Quote> create({
    required String text,
    String? author,
    String? source,
    String? category,
  }) => caller.callServerEndpoint<_igszo10w.Quote>(
    'quotes',
    'create',
    {
      'text': text,
      'author': author,
      'source': source,
      'category': category,
    },
  );

  _ida.Future<_igszo10w.Quote> update({
    required _isc.UuidValue id,
    String? text,
    String? author,
    String? source,
    String? category,
    bool? isActive,
  }) => caller.callServerEndpoint<_igszo10w.Quote>(
    'quotes',
    'update',
    {
      'id': id,
      'text': text,
      'author': author,
      'source': source,
      'category': category,
      'isActive': isActive,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'quotes',
        'delete',
        {'id': id},
      );
}

/// Reflections about the daily pair, mirroring FastAPI `/reflections`.
/// {@category Endpoint}
class EndpointReflections extends _isc.EndpointRef {
  EndpointReflections(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reflections';

  _ida.Future<List<_ivmwvttz.Reflection>> list({_isc.UuidValue? entryId}) =>
      caller.callServerEndpoint<List<_ivmwvttz.Reflection>>(
        'reflections',
        'list',
        {'entryId': entryId},
      );

  _ida.Future<_ivmwvttz.Reflection> create({
    required String thought,
    _isc.UuidValue? entryId,
    _isc.UuidValue? quoteId,
    _isc.UuidValue? selfMessageId,
  }) => caller.callServerEndpoint<_ivmwvttz.Reflection>(
    'reflections',
    'create',
    {
      'thought': thought,
      'entryId': entryId,
      'quoteId': quoteId,
      'selfMessageId': selfMessageId,
    },
  );

  _ida.Future<_ivmwvttz.Reflection> update({
    required _isc.UuidValue id,
    required String thought,
  }) => caller.callServerEndpoint<_ivmwvttz.Reflection>(
    'reflections',
    'update',
    {
      'id': id,
      'thought': thought,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'reflections',
        'delete',
        {'id': id},
      );
}

/// The user's own messages to self, mirroring FastAPI `/self-messages`.
/// {@category Endpoint}
class EndpointSelfMessages extends _isc.EndpointRef {
  EndpointSelfMessages(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'selfMessages';

  _ida.Future<List<_i4smoveg.SelfMessage>> list() =>
      caller.callServerEndpoint<List<_i4smoveg.SelfMessage>>(
        'selfMessages',
        'list',
        {},
      );

  _ida.Future<_i4smoveg.SelfMessage> create({
    required String content,
    _isc.UuidValue? entryId,
  }) => caller.callServerEndpoint<_i4smoveg.SelfMessage>(
    'selfMessages',
    'create',
    {
      'content': content,
      'entryId': entryId,
    },
  );

  _ida.Future<_i4smoveg.SelfMessage> update({
    required _isc.UuidValue id,
    required String content,
  }) => caller.callServerEndpoint<_i4smoveg.SelfMessage>(
    'selfMessages',
    'update',
    {
      'id': id,
      'content': content,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'selfMessages',
        'delete',
        {'id': id},
      );
}

/// Saved trips and their weather snapshot (docs/12-route-weather.md §8, §9).
///
/// A journey is written only when the user asks for it, and it keeps the
/// forecast it was planned with: reopening a trip shows that snapshot next to a
/// separately fetched, fresher forecast instead of mixing the two.
/// {@category Endpoint}
class EndpointJourneys extends _isc.EndpointRef {
  EndpointJourneys(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'journeys';

  /// The user's trips, newest departure first.
  _ida.Future<List<_i8cgeaon.Journey>> list() =>
      caller.callServerEndpoint<List<_i8cgeaon.Journey>>(
        'journeys',
        'list',
        {},
      );

  /// One trip with its stops and its saved weather snapshot.
  _ida.Future<_irr74z0a.JourneyDetail> detail(_isc.UuidValue id) =>
      caller.callServerEndpoint<_irr74z0a.JourneyDetail>(
        'journeys',
        'detail',
        {'id': id},
      );

  /// Stores a trip, its stops and its weather snapshot.
  ///
  /// [entryId] links an existing diary entry. [createEntry] instead writes the
  /// departure day's entry — or updates it, since there is one row per day —
  /// with [entryText], and links that. Passing neither saves the trip alone.
  _ida.Future<_irr74z0a.JourneyDetail> save({
    required String title,
    required String vehicle,
    required DateTime departureAt,
    required List<_isj44i7w.RouteStop> stops,
    required int distanceMeters,
    required int durationSeconds,
    required String geometry,
    String? notes,
    _isc.UuidValue? entryId,
    List<_iw3tlfli.RouteWeatherSample>? weatherSamples,
    bool? createEntry,
    String? entryText,
    int? weatherId,
  }) => caller.callServerEndpoint<_irr74z0a.JourneyDetail>(
    'journeys',
    'save',
    {
      'title': title,
      'vehicle': vehicle,
      'departureAt': departureAt,
      'stops': stops,
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'geometry': geometry,
      'notes': notes,
      'entryId': entryId,
      'weatherSamples': weatherSamples,
      'createEntry': createEntry,
      'entryText': entryText,
      'weatherId': weatherId,
    },
  );

  _ida.Future<void> delete(_isc.UuidValue id) =>
      caller.callServerEndpoint<void>(
        'journeys',
        'delete',
        {'id': id},
      );
}

/// Route planning and the weather along a route
/// (docs/12-route-weather.md §9).
///
/// The client never talks to OSRM or Open-Meteo directly: this endpoint owns the
/// provider choice, the sampling rules, the adverse-weather rules and the
/// 30-minute cache, so all of that can change without touching the app.
/// {@category Endpoint}
class EndpointRoute extends _isc.EndpointRef {
  EndpointRoute(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'route';

  /// Places matching [query], for the planner's search box.
  _ida.Future<List<_i972nhj2.PlaceCandidate>> searchPlaces(
    String query, {
    int? limit,
  }) => caller.callServerEndpoint<List<_i972nhj2.PlaceCandidate>>(
    'route',
    'searchPlaces',
    {
      'query': query,
      'limit': limit,
    },
  );

  /// The address at [lat] / [lon], or null when the point has none — what a
  /// tap on the map writes into the planner's stop field (docs/12 §11).
  _ida.Future<_i972nhj2.PlaceCandidate?> reversePlace({
    required double lat,
    required double lon,
  }) => caller.callServerEndpoint<_i972nhj2.PlaceCandidate?>(
    'route',
    'reversePlace',
    {
      'lat': lat,
      'lon': lon,
    },
  );

  /// The route through [origin], the optional [waypoints] and [destination].
  _ida.Future<_ivfcqbu8.RoutePlan> plan({
    required _isj44i7w.RouteStop origin,
    required _isj44i7w.RouteStop destination,
    List<_isj44i7w.RouteStop>? waypoints,
    String? vehicle,
    bool? alternatives,
  }) => caller.callServerEndpoint<_ivfcqbu8.RoutePlan>(
    'route',
    'plan',
    {
      'origin': origin,
      'destination': destination,
      'waypoints': waypoints,
      'vehicle': vehicle,
      'alternatives': alternatives,
    },
  );

  /// The weather along [plan], sampled at the stops and every 25 km in between,
  /// each read at the time the traveller is expected to be there.
  _ida.Future<_iaiilleq.RouteWeatherReport> forecast({
    required _ivfcqbu8.RoutePlan plan,
    required DateTime departureAt,
  }) => caller.callServerEndpoint<_iaiilleq.RouteWeatherReport>(
    'route',
    'forecast',
    {
      'plan': plan,
      'departureAt': departureAt,
    },
  );

  /// [plan] and [forecast] in one call, so the screen needs a single round trip.
  _ida.Future<_idn1z7ab.RoutePlanWithWeather> planWithWeather({
    required _isj44i7w.RouteStop origin,
    required _isj44i7w.RouteStop destination,
    List<_isj44i7w.RouteStop>? waypoints,
    String? vehicle,
    DateTime? departureAt,
    bool? alternatives,
  }) => caller.callServerEndpoint<_idn1z7ab.RoutePlanWithWeather>(
    'route',
    'planWithWeather',
    {
      'origin': origin,
      'destination': destination,
      'waypoints': waypoints,
      'vehicle': vehicle,
      'departureAt': departureAt,
      'alternatives': alternatives,
    },
  );

  /// Departure times around the picked one, each with its own forecast, for the
  /// "compare departure times" panel.
  _ida.Future<List<_ia1gr6j3.RouteDepartureOption>> compareDepartures({
    required _ivfcqbu8.RoutePlan plan,
    required DateTime departureAt,
    List<int>? offsetsHours,
  }) => caller.callServerEndpoint<List<_ia1gr6j3.RouteDepartureOption>>(
    'route',
    'compareDepartures',
    {
      'plan': plan,
      'departureAt': departureAt,
      'offsetsHours': offsetsHours,
    },
  );
}

/// Idempotent reference-data seeding, replacing `python -m app.seed.seed`.
///
/// It only inserts missing rows, so it is safe to call repeatedly. A production
/// deployment should lock this down (admin scope) or run it once and remove it.
/// {@category Endpoint}
class EndpointSeed extends _isc.EndpointRef {
  EndpointSeed(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'seed';

  _ida.Future<String> run() => caller.callServerEndpoint<String>(
    'seed',
    'run',
    {},
  );
}

/// Month grids and summary, mirroring FastAPI `/stats`.
/// {@category Endpoint}
class EndpointStats extends _isc.EndpointRef {
  EndpointStats(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'stats';

  _ida.Future<List<_idxtic5g.GridCell>> moodGrid({required String month}) =>
      caller.callServerEndpoint<List<_idxtic5g.GridCell>>(
        'stats',
        'moodGrid',
        {'month': month},
      );

  _ida.Future<List<_idxtic5g.GridCell>> weatherGrid({required String month}) =>
      caller.callServerEndpoint<List<_idxtic5g.GridCell>>(
        'stats',
        'weatherGrid',
        {'month': month},
      );

  _ida.Future<_iei6d93o.StatsSummary> summary({required String month}) =>
      caller.callServerEndpoint<_iei6d93o.StatsSummary>(
        'stats',
        'summary',
        {'month': month},
      );
}

/// Forecast from Open-Meteo, mirroring FastAPI `/weather`.
/// {@category Endpoint}
class EndpointWeather extends _isc.EndpointRef {
  EndpointWeather(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'weather';

  _ida.Future<_i4p3ynlu.WeatherForecast> current() =>
      caller.callServerEndpoint<_i4p3ynlu.WeatherForecast>(
        'weather',
        'current',
        {},
      );

  /// One day from stored snapshots. Never touches the network.
  _ida.Future<_ituibxbp.WeatherDay?> daily(DateTime date) =>
      caller.callServerEndpoint<_ituibxbp.WeatherDay?>(
        'weather',
        'daily',
        {'date': date},
      );

  _ida.Future<List<_ituibxbp.WeatherDay>> history({
    DateTime? from,
    DateTime? to,
  }) => caller.callServerEndpoint<List<_ituibxbp.WeatherDay>>(
    'weather',
    'history',
    {
      'from': from,
      'to': to,
    },
  );

  _ida.Future<void> setLocation({
    required double lat,
    required double lon,
    String? name,
  }) => caller.callServerEndpoint<void>(
    'weather',
    'setLocation',
    {
      'lat': lat,
      'lon': lon,
      'name': name,
    },
  );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    admin = EndpointAdmin(this);
    auth = EndpointAuth(this);
    health = EndpointHealth(this);
    entries = EndpointEntries(this);
    images = EndpointImages(this);
    lookups = EndpointLookups(this);
    notes = EndpointNotes(this);
    events = EndpointEvents(this);
    schedules = EndpointSchedules(this);
    todos = EndpointTodos(this);
    dailyQuotes = EndpointDailyQuotes(this);
    quotes = EndpointQuotes(this);
    reflections = EndpointReflections(this);
    selfMessages = EndpointSelfMessages(this);
    journeys = EndpointJourneys(this);
    route = EndpointRoute(this);
    seed = EndpointSeed(this);
    stats = EndpointStats(this);
    weather = EndpointWeather(this);
  }

  late final EndpointAdmin admin;

  late final EndpointAuth auth;

  late final EndpointHealth health;

  late final EndpointEntries entries;

  late final EndpointImages images;

  late final EndpointLookups lookups;

  late final EndpointNotes notes;

  late final EndpointEvents events;

  late final EndpointSchedules schedules;

  late final EndpointTodos todos;

  late final EndpointDailyQuotes dailyQuotes;

  late final EndpointQuotes quotes;

  late final EndpointReflections reflections;

  late final EndpointSelfMessages selfMessages;

  late final EndpointJourneys journeys;

  late final EndpointRoute route;

  late final EndpointSeed seed;

  late final EndpointStats stats;

  late final EndpointWeather weather;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'admin': admin,
    'auth': auth,
    'health': health,
    'entries': entries,
    'images': images,
    'lookups': lookups,
    'notes': notes,
    'events': events,
    'schedules': schedules,
    'todos': todos,
    'dailyQuotes': dailyQuotes,
    'quotes': quotes,
    'reflections': reflections,
    'selfMessages': selfMessages,
    'journeys': journeys,
    'route': route,
    'seed': seed,
    'stats': stats,
    'weather': weather,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
