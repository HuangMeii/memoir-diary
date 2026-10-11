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
        final cells = await _client.stats.moodGrid(month: query!['month'] as String);
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
        return (await _client.selfMessages.list()).map(_selfMessageMap).toList();
      case '/reflections':
        return (await _client.reflections.list()).map(_reflectionMap).toList();
      case '/notes':
        return (await _client.notes.list()).map(_noteMap).toList();
      case '/todos':
        return (await _client.todos.list()).map(_todoMap).toList();
      case '/events':
        return (await _client.events.list()).map(_eventMap).toList();
      case '/schedule-items':
        return (await _client.schedules.list()).map(_scheduleMap).toList();
      case '/health-logs':
        final logs = await _client.health.list(
          from: _parseDate(query!['from'])!,
          to: _parseDate(query['to'])!,
        );
        return logs.map(_healthMap).toList();
    }

    if (path.startsWith('/entries/by-date/')) {
      final iso = path.substring('/entries/by-date/'.length);
      final entry = await _client.entries.byDate(iso);
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
        return _entryMap(await _client.entries.create(
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
        ));
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
        return _noteMap(await _client.notes.create(
          content: body['content'] as String? ?? '',
          title: body['title'] as String?,
          color: body['color'] as String?,
          isPinned: body['is_pinned'] as bool?,
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
    throw ApiException('ServerpodDataSource: unsupported POST $path');
  }

  @override
  Future<dynamic> put(String path, {Object? data}) async {
    final body = (data as Map?)?.cast<String, dynamic>() ?? const {};
    final id = _idOf(path);
    if (path.startsWith('/entries/')) {
      return _entryMap(await _client.entries.update(
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
      ));
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
    throw ApiException('ServerpodDataSource: unsupported PUT $path');
  }

  @override
  Future<dynamic> delete(String path) async {
    final id = _uuid(_idOf(path));
    if (path.startsWith('/entries/')) return _client.entries.delete(id);
    if (path.startsWith('/images/')) return _client.images.delete(id);
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
  return DateTime.parse(value as String);
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
    };

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
      'content': n.content,
      'color': n.color,
      'is_pinned': n.isPinned,
      'created_at': n.createdAt.toIso8601String(),
      'updated_at': n.updatedAt.toIso8601String(),
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
