import 'package:dio/dio.dart';
import 'package:memoir_server_client/memoir_server_client.dart' as sp;

import '../../core/api_exception.dart';
import 'backend_data_source.dart';
import 'file_bytes.dart';

/// [BackendDataSource] backed by the generated Serverpod client.
///
/// The repositories speak in REST-shaped paths, so this class maps each path
/// onto the matching Serverpod endpoint and rebuilds the response as the same
/// snake_case JSON the repositories already parse. That keeps every
/// repository, provider and screen unchanged.
class ServerpodDataSource implements BackendDataSource {
  ServerpodDataSource(this._client);

  final sp.Client _client;

  /// Download URLs captured by [forEntry] so the follow-up `/images/{id}/url`
  /// call the repository makes can be answered without a second round trip.
  final Map<String, String> _imageUrls = {};

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    switch (path) {
      case '/moods':
        return _lookups(await _client.lookups.moods());
      case '/weathers':
        return _lookups(await _client.lookups.weathers());
      case '/entries':
        final entries = await _client.entries.list(
          month: query?['month'] as String?,
          from: _parseDate(query?['from']),
          to: _parseDate(query?['to']),
        );
        return entries.map(_entryMap).toList();
      case '/stats/mood-grid':
        final cells =
            await _client.stats.moodGrid(month: query!['month'] as String);
        return {'cells': cells.map(_gridCellMap).toList()};
      case '/stats/weather-grid':
        final cells =
            await _client.stats.weatherGrid(month: query!['month'] as String);
        return {'cells': cells.map(_gridCellMap).toList()};
      case '/stats/summary':
        final summary =
            await _client.stats.summary(month: query!['month'] as String);
        return _summaryMap(summary);
      case '/daily-quotes/today':
        return _pairMap(await _client.dailyQuotes.today());
      case '/daily-quotes':
        final rows =
            await _client.dailyQuotes.history(month: query!['month'] as String);
        return rows.map(_pairMap).toList();
      case '/self-messages':
        return (await _client.selfMessages.list())
            .map(_selfMessageMap)
            .toList();
      case '/reflections':
        return (await _client.reflections.list()).map(_reflectionMap).toList();
      case '/notes':
        return (await _client.notes.list(
          includeArchived: query?['archived'] != 'false',
          trashedOnly: query?['trashed'] == 'true',
        ))
            .map(_noteMap)
            .toList();
      case '/todos':
        return (await _client.todos.list()).map(_todoMap).toList();
      case '/events':
        final events = await _client.events.list(
          from: _parseDate(query?['from']),
          to: _parseDate(query?['to']),
        );
        return events.map(_eventMap).toList();
      case '/schedule-items':
        return (await _client.schedules.list()).map(_scheduleMap).toList();
      case '/health-logs':
        final logs = await _client.health.list(
          from: _parseDate(query!['from'])!,
          to: _parseDate(query['to'])!,
        );
        return logs.map(_healthMap).toList();
      case '/weather/current':
        return _weatherForecastMap(await _client.weather.current());
      case '/weather/history':
        final days = await _client.weather.history(
          from: _parseDate(query?['from']),
          to: _parseDate(query?['to']),
        );
        return {'days': days.map(_weatherDayMap).toList()};
      case '/weather/daily':
        final day = await _client.weather.daily(_parseDate(query?['date'])!);
        return day == null ? null : _weatherDayMap(day);
    }

    if (path.startsWith('/entries/by-date/')) {
      final iso = path.substring('/entries/by-date/'.length);
      final entry = await _request(() => _client.entries.byDate(iso));
      if (entry == null) {
        throw ApiException('Entry not found', statusCode: 404);
      }
      return _entryMap(entry);
    }
    if (path.startsWith('/entries/') && path.endsWith('/images')) {
      final entryId = path.substring(
        '/entries/'.length,
        path.length - '/images'.length,
      );
      return _imagesForEntry(entryId);
    }
    if (path.startsWith('/notes/')) {
      final id = path.substring('/notes/'.length);
      if (id.isNotEmpty && !id.contains('/')) {
        return _noteDetailMap(
          await _request(() => _client.notes.get(_uuid(id))),
        );
      }
    }
    if (path.startsWith('/entries/') &&
        !path.endsWith('/images') &&
        !path.contains('/by-date')) {
      final id = path.substring('/entries/'.length);
      if (id.isNotEmpty && !id.contains('/')) {
        final entry = await _request(() => _client.entries.get(_uuid(id)));
        if (entry == null) {
          throw ApiException('Entry not found', statusCode: 404);
        }
        return _entryMap(entry);
      }
    }
    if (path.startsWith('/images/') && path.endsWith('/url')) {
      final imageId = path.substring(
        '/images/'.length,
        path.length - '/url'.length,
      );
      return {'url': _imageUrls[imageId]};
    }
    throw ApiException('ServerpodDataSource: unsupported GET $path');
  }

  Future<List<Map<String, dynamic>>> _imagesForEntry(String entryId) async {
    final views = await _client.images.forEntry(_uuid(entryId));
    final result = <Map<String, dynamic>>[];
    for (final view in views) {
      final image = view.image;
      if (image.id != null) {
        _imageUrls[image.id!.toString()] = view.url;
      }
      result.add(_imageMap(image));
    }
    return result;
  }

  @override
  Future<dynamic> post(String path, {Object? data}) async {
    final body = (data as Map?)?.cast<String, dynamic>() ?? const {};
    switch (path) {
      case '/entries':
        return _entryMap(await _request(() => _client.entries.create(
              entryDate: _parseDate(body['entry_date'])!,
              moodId: body['mood_id'] as int?,
              weatherId: body['weather_id'] as int?,
              diaryText: body['diary_text'] as String?,
              otherPerspective: body['other_perspective'] as String?,
              futureMessage: body['future_message'] as String?,
              selfCare: body['self_care'] as String?,
              tomorrowHope: body['tomorrow_hope'] as String?,
              gratitude: body['gratitude'] as String?,
              dream: body['dream'] as String?,
            )));
      case '/self-messages':
        return _selfMessageMap(await _client.selfMessages.create(
          content: body['content'] as String,
          entryId: _uuidOrNull(body['entry_id']),
        ));
      case '/reflections':
        return _reflectionMap(await _client.reflections.create(
          thought: body['thought'] as String,
          entryId: _uuidOrNull(body['entry_id']),
          quoteId: _uuidOrNull(body['quote_id']),
          selfMessageId: _uuidOrNull(body['self_message_id']),
        ));
      case '/notes':
        return _noteMap(await _request(
          () => _client.notes.create(
            content: body['content'] as String? ?? '',
            title: body['title'] as String?,
            color: body['color'] as String?,
            tags: _stringList(body['tags']),
            isPinned: body['is_pinned'] as bool?,
            checklist: _checklistInput(body['checklist']),
            entryIds: _uuidList(body['entry_ids']),
          ),
        ));
      case '/todos':
        return _todoMap(await _client.todos.create(
          title: body['title'] as String,
          notes: body['notes'] as String?,
          dueDate: _parseDate(body['due_date']),
          weekLabel: body['week_label'] as String?,
          priority: body['priority'] as int?,
        ));
      case '/events':
        return _eventMap(await _client.events.create(
          title: body['title'] as String,
          startAt: _parseDate(body['start_at'])!,
          description: body['description'] as String?,
          endAt: _parseDate(body['end_at']),
          location: body['location'] as String?,
          isAllDay: body['is_all_day'] as bool?,
          reminderMinutes: body['reminder_minutes'] as int?,
        ));
      case '/schedule-items':
        return _scheduleMap(await _client.schedules.create(
          title: body['title'] as String,
          startAt: _parseDate(body['start_at'])!,
          endAt: _parseDate(body['end_at']),
          recurrenceRule: body['recurrence_rule'] as String?,
          reminderMinutes: body['reminder_minutes'] as int?,
        ));
      case '/health-logs':
        return _healthMap(await _client.health.save(
          logDate: _parseDate(body['log_date'])!,
          steps: body['steps'] as int?,
          workoutMinutes: body['workout_minutes'] as int?,
          waterMl: body['water_ml'] as int?,
          sleepHours: (body['sleep_hours'] as num?)?.toDouble(),
          weightKg: (body['weight_kg'] as num?)?.toDouble(),
          note: body['note'] as String?,
        ));
    }
    if (path.startsWith('/notes/') && path.endsWith('/restore')) {
      final noteId = path.substring(
        '/notes/'.length,
        path.length - '/restore'.length,
      );
      await _request(() => _client.notes.restore(_uuid(noteId)));
      return null;
    }
    throw ApiException('ServerpodDataSource: unsupported POST $path');
  }

  /// Replaces the whole row behind [path].
  ///
  /// Every field below is read from [data] and forwarded, so a caller that
  /// omits a key sends `null` for it and the server clears that column. Always
  /// send the complete object (`HomeScreen._pick`, `EntryEditorScreen._save`).
  @override
  Future<dynamic> put(String path, {Object? data}) async {
    final body = (data as Map?)?.cast<String, dynamic>() ?? const {};
    final id = _idOf(path);
    if (path.startsWith('/entries/')) {
      return _entryMap(await _request(() => _client.entries.update(
            id: _uuid(id),
            moodId: body['mood_id'] as int?,
            weatherId: body['weather_id'] as int?,
            diaryText: body['diary_text'] as String?,
            otherPerspective: body['other_perspective'] as String?,
            futureMessage: body['future_message'] as String?,
            selfCare: body['self_care'] as String?,
            tomorrowHope: body['tomorrow_hope'] as String?,
            gratitude: body['gratitude'] as String?,
            dream: body['dream'] as String?,
          )));
    }
    if (path.startsWith('/self-messages/')) {
      return _selfMessageMap(await _client.selfMessages.update(
        id: _uuid(id),
        content: body['content'] as String,
      ));
    }
    if (path.startsWith('/reflections/')) {
      return _reflectionMap(await _client.reflections.update(
        id: _uuid(id),
        thought: body['thought'] as String,
      ));
    }
    if (path.startsWith('/todos/')) {
      return _todoMap(await _client.todos.update(
        id: _uuid(id),
        title: body['title'] as String?,
        notes: body['notes'] as String?,
        dueDate: _parseDate(body['due_date']),
        weekLabel: body['week_label'] as String?,
        priority: body['priority'] as int?,
        isDone: body['is_done'] as bool?,
      ));
    }
    if (path.startsWith('/events/')) {
      return _eventMap(await _client.events.update(
        id: _uuid(id),
        title: body['title'] as String?,
        description: body['description'] as String?,
        startAt: _parseDate(body['start_at']),
        endAt: _parseDate(body['end_at']),
        location: body['location'] as String?,
        isAllDay: body['is_all_day'] as bool?,
        reminderMinutes: body['reminder_minutes'] as int?,
      ));
    }
    if (path.startsWith('/schedule-items/')) {
      return _scheduleMap(await _client.schedules.update(
        id: _uuid(id),
        title: body['title'] as String?,
        startAt: _parseDate(body['start_at']),
        endAt: _parseDate(body['end_at']),
        recurrenceRule: body['recurrence_rule'] as String?,
        reminderMinutes: body['reminder_minutes'] as int?,
      ));
    }
    if (path.startsWith('/notes/') && path.endsWith('/archive')) {
      final noteId = path.substring(
        '/notes/'.length,
        path.length - '/archive'.length,
      );
      return _noteMap(await _request(() => _client.notes.archive(
            _uuid(noteId),
            body['is_archived'] as bool? ?? false,
          )));
    }
    if (path.startsWith('/notes/')) {
      final noteId = _idOf(path);
      return _noteMap(await _request(
        () => _client.notes.update(
          id: _uuid(noteId),
          title: body['title'] as String?,
          content: body['content'] as String?,
          color: body['color'] as String?,
          tags: _stringList(body['tags']),
          isPinned: body['is_pinned'] as bool?,
          isArchived: body['is_archived'] as bool?,
          isTrashed: body['is_trashed'] as bool?,
          checklist: _checklistInput(body['checklist']),
          entryIds: _uuidList(body['entry_ids']),
        ),
      ));
    }
    if (path == '/weather/location') {
      await _client.weather.setLocation(
        lat: (body['lat'] as num).toDouble(),
        lon: (body['lon'] as num).toDouble(),
        name: body['name'] as String?,
      );
      return null;
    }
    throw ApiException('ServerpodDataSource: unsupported PUT $path');
  }

  Future<T> _request<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on sp.ApiException catch (error) {
      throw _apiException(error);
    } on sp.SerializableException catch (error) {
      if (error is sp.ApiException) {
        throw _apiException(error);
      }
      rethrow;
    }
  }

  ApiException _apiException(sp.ApiException error) {
    final statusCode = switch (error.code) {
      'notFound' => 404,
      'conflict' => 409,
      'unauthorized' => 401,
      'forbidden' => 403,
      _ => null,
    };
    return ApiException(error.message, statusCode: statusCode);
  }

  @override
  Future<dynamic> delete(String path) async {
    final id = _uuid(_idOf(path));
    if (path.startsWith('/entries/')) return _client.entries.delete(id);
    if (path.startsWith('/images/')) return _client.images.delete(id);
    if (path.startsWith('/notes/') && path.endsWith('/purge')) {
      final noteId = path.substring(
        '/notes/'.length,
        path.length - '/purge'.length,
      );
      await _request(() => _client.notes.purge(_uuid(noteId)));
      return null;
    }
    if (path.startsWith('/notes/')) return _client.notes.delete(id);
    if (path.startsWith('/daily-quotes/')) {
      return _client.dailyQuotes.reshuffle(id);
    }
    if (path.startsWith('/todos/')) return _client.todos.delete(id);
    if (path.startsWith('/events/')) return _client.events.delete(id);
    if (path.startsWith('/schedule-items/')) {
      return _client.schedules.delete(id);
    }
    if (path.startsWith('/self-messages/')) {
      return _client.selfMessages.delete(id);
    }
    if (path.startsWith('/reflections/')) {
      return _client.reflections.delete(id);
    }
    throw ApiException('ServerpodDataSource: unsupported DELETE $path');
  }

  @override
  Future<dynamic> uploadImage(String path, String filePath) async {
    // path is `/entries/{entryId}/images`.
    final entryId = _uuid(
      path.substring('/entries/'.length, path.length - '/images'.length),
    );
    final filename = filePath.split(RegExp(r'[\\/]')).last;

    final ticket = await _client.images.createUploadDescription(
      entryId: entryId,
      filename: filename,
    );
    final bytes = await readFileBytes(filePath);
    final response = await Dio().put<List<int>>(
      ticket.uploadUrl,
      data: bytes,
      options: Options(headers: {'Content-Type': 'application/octet-stream'}),
    );
    final status = response.statusCode ?? 0;
    if (status >= 300) {
      throw ApiException('Upload failed ($status)');
    }
    return _imageMap(await _client.images.confirmUpload(
      entryId: entryId,
      objectKey: ticket.objectKey,
      sizeBytes: bytes.length,
    ));
  }
}

// --- helpers ---------------------------------------------------------------
// Serverpod returns camelCase Dart objects; these rebuild the snake_case JSON
// the Flutter models already parse, and stringify ids the same way FastAPI did.

sp.UuidValue _uuid(String value) => sp.UuidValue.fromString(value);

sp.UuidValue? _uuidOrNull(dynamic value) =>
    value == null ? null : sp.UuidValue.fromString(value as String);

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  final text = value as String;
  // A bare `YYYY-MM-DD` is a calendar day, not an instant. Serverpod sends
  // every DateTime with `.toUtc()`, and the server normalizes dates with
  // `dateOnly(d) = DateTime.utc(d.year, d.month, d.day)`. Parsing a date-only
  // string as local midnight would, on any UTC+X machine, arrive as the
  // previous day in UTC (and the first of a month would slip into the month
  // before, dropping the entry out of that month's heatmap). Parse it as UTC
  // midnight so the day the caller meant is the day stored. Full ISO
  // timestamps (event start/end) keep their own offset via DateTime.parse.
  final dateOnly = RegExp(r'^\d{4}-\d{2}-\d{2}$');
  if (dateOnly.hasMatch(text)) {
    return DateTime.utc(
      int.parse(text.substring(0, 4)),
      int.parse(text.substring(5, 7)),
      int.parse(text.substring(8, 10)),
    );
  }
  return DateTime.parse(text);
}

String _idOf(String path) => path.split('/').last;

String _dateOnly(DateTime value) {
  final d = value.toUtc();
  final month = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year.toString().padLeft(4, '0')}-$month-$day';
}

List<Map<String, dynamic>> _lookups(dynamic rows) =>
    (rows as List).map<Map<String, dynamic>>((dynamic r) {
      return {
        'id': r.id,
        'code': r.code,
        'label_vi': r.labelVi,
        'color_hex': r.colorHex,
        'icon': r.icon,
        'sort_order': r.sortOrder,
      };
    }).toList();

Map<String, dynamic> _entryMap(sp.DiaryEntry e) => {
      'id': e.id?.toString(),
      'entry_date': _dateOnly(e.entryDate),
      'mood_id': e.moodId,
      'weather_id': e.weatherId,
      'diary_text': e.diaryText,
      'other_perspective': e.otherPerspective,
      'future_message': e.futureMessage,
      'self_care': e.selfCare,
      'tomorrow_hope': e.tomorrowHope,
      'gratitude': e.gratitude,
      'dream': e.dream,
      'created_at': e.createdAt.toIso8601String(),
      'updated_at': e.updatedAt.toIso8601String(),
    };

List<String>? _stringList(dynamic value) {
  if (value == null) return null;
  return (value as List).map((e) => '$e').toList();
}

List<sp.UuidValue>? _uuidList(dynamic value) {
  if (value == null) return null;
  return (value as List)
      .map((e) => sp.UuidValue.fromString(e as String))
      .toList();
}

List<sp.NoteChecklistItem>? _checklistInput(dynamic value) {
  if (value == null) return null;
  return (value as List).map((raw) {
    final map = (raw as Map).cast<String, dynamic>();
    final id = map['id'] as String?;
    return sp.NoteChecklistItem(
      id: id == null ? null : sp.UuidValue.fromString(id),
      // The server ignores this and fills in the parent note id itself.
      noteId: sp.UuidValue.fromString('00000000-0000-0000-0000-000000000000'),
      text: map['text'] as String? ?? '',
      isDone: map['is_done'] as bool? ?? false,
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }).toList();
}

Map<String, dynamic> _gridCellMap(sp.GridCell c) => {
      'date': _dateOnly(c.date),
      'code': c.code,
      'label': c.label,
      'color': c.color,
    };

Map<String, dynamic> _summaryMap(sp.StatsSummary s) => {
      'month': s.month,
      'days_logged': s.daysLogged,
      'mood_counts': s.moodCounts,
      'weather_counts': s.weatherCounts,
      'total_steps': s.totalSteps,
      'total_workout_minutes': s.totalWorkoutMinutes,
    };

Map<String, dynamic> _quoteMap(sp.Quote q) => {
      'id': q.id?.toString(),
      'text': q.text,
      'author': q.author,
      'category': q.category,
    };

Map<String, dynamic> _pairMap(sp.DailyQuotePair p) => {
      'id': p.id.toString(),
      'quote_date': _dateOnly(p.quoteDate),
      'quote_id': p.quote?.id?.toString(),
      'quote_id_2': p.quote2?.id?.toString(),
      'self_message_id': p.selfMessage?.id?.toString(),
      'quote': p.quote == null ? null : _quoteMap(p.quote!),
      'quote_2': p.quote2 == null ? null : _quoteMap(p.quote2!),
      'self_message':
          p.selfMessage == null ? null : {'content': p.selfMessage!.content},
    };

Map<String, dynamic> _selfMessageMap(sp.SelfMessage m) => {
      'id': m.id?.toString(),
      'content': m.content,
      'created_at': m.createdAt.toIso8601String(),
    };

Map<String, dynamic> _reflectionMap(sp.Reflection r) => {
      'id': r.id?.toString(),
      'thought': r.thought,
      'quote_id': r.quoteId?.toString(),
      'self_message_id': r.selfMessageId?.toString(),
      'entry_id': r.entryId?.toString(),
      'created_at': r.createdAt.toIso8601String(),
    };

Map<String, dynamic> _noteMap(sp.Note n) => {
      'id': n.id?.toString(),
      'title': n.title,
      'content': n.content,
      'color': n.color,
      'tags': n.tags ?? const <String>[],
      'is_pinned': n.isPinned,
      'is_archived': n.isArchived,
      'is_trashed': n.isTrashed,
      'created_at': n.createdAt.toIso8601String(),
      'updated_at': n.updatedAt.toIso8601String(),
    };

Map<String, dynamic> _checklistMap(sp.NoteChecklistItem i) => {
      'id': i.id?.toString(),
      'note_id': i.noteId.toString(),
      'text': i.text,
      'is_done': i.isDone,
      'sort_order': i.sortOrder,
    };

Map<String, dynamic> _noteDetailMap(sp.NoteDetail d) => {
      'note': _noteMap(d.note),
      'checklist': d.checklist.map(_checklistMap).toList(),
      'entries': d.entries.map(_entryMap).toList(),
    };

Map<String, dynamic> _todoMap(sp.Todo t) => {
      'id': t.id?.toString(),
      'title': t.title,
      'notes': t.notes,
      'due_date': t.dueDate == null ? null : _dateOnly(t.dueDate!),
      'week_label': t.weekLabel,
      'priority': t.priority,
      'is_done': t.isDone,
      'completed_at': t.completedAt?.toIso8601String(),
      'created_at': t.createdAt.toIso8601String(),
    };

Map<String, dynamic> _eventMap(sp.Event e) => {
      'id': e.id?.toString(),
      'title': e.title,
      'description': e.description,
      'start_at': e.startAt.toIso8601String(),
      'end_at': e.endAt?.toIso8601String(),
      'location': e.location,
      'is_all_day': e.isAllDay,
      'reminder_minutes': e.reminderMinutes,
    };

Map<String, dynamic> _scheduleMap(sp.ScheduleItem s) => {
      'id': s.id?.toString(),
      'title': s.title,
      'start_at': s.startAt.toIso8601String(),
      'end_at': s.endAt?.toIso8601String(),
      'recurrence_rule': s.recurrenceRule,
      'reminder_minutes': s.reminderMinutes,
    };

Map<String, dynamic> _healthMap(sp.HealthLog h) => {
      'id': h.id?.toString(),
      'log_date': _dateOnly(h.logDate),
      'steps': h.steps,
      'workout_minutes': h.workoutMinutes,
      'water_ml': h.waterMl,
      'sleep_hours': h.sleepHours,
      'weight_kg': h.weightKg,
      'note': h.note,
    };

Map<String, dynamic> _imageMap(sp.EntryImage i) => {
      'id': i.id?.toString(),
      'entry_id': i.entryId.toString(),
      'object_key': i.objectKey,
      'content_type': i.contentType,
      'size_bytes': i.sizeBytes,
      'caption': i.caption,
      'created_at': i.createdAt.toIso8601String(),
    };

Map<String, dynamic> _weatherDayMap(sp.WeatherDay d) => {
      'date': _dateOnly(d.date),
      'weather_code': d.weatherCode,
      'condition': d.condition,
      'icon': d.icon,
      'weather_id': d.weatherId,
      'temp_min': d.tempMin,
      'temp_max': d.tempMax,
    };

Map<String, dynamic> _weatherForecastMap(sp.WeatherForecast f) => {
      'location_name': f.locationName,
      'current': {
        'time': f.currentTime?.toIso8601String(),
        'temperature': f.currentTemperature,
        'weather_code': f.currentWeatherCode,
        'condition': f.condition,
        'icon': f.icon,
      },
      'daily': f.daily.map(_weatherDayMap).toList(),
      // The client treats anything but "cache" as a live Open-Meteo reading.
      'source': f.source == 'cache' ? 'cache' : 'open-meteo',
    };
