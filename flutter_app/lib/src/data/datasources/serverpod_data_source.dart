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
        return (await _client.notes.list()).map(_noteMap).toList();
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
      case '/journeys':
        return (await _request(() => _client.journeys.list()))
            .map(_journeyMap)
            .toList();
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
    if (path.startsWith('/images/') && path.endsWith('/url')) {
      final imageId = path.substring(
        '/images/'.length,
        path.length - '/url'.length,
      );
      return {'url': _imageUrls[imageId]};
    }
    if (path.startsWith('/journeys/')) {
      final id = path.substring('/journeys/'.length);
      final detail = await _request(() => _client.journeys.detail(_uuid(id)));
      return _journeyDetailMap(detail);
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
      case '/route/search-places':
        final places = await _request(() => _client.route.searchPlaces(
              body['query'] as String? ?? '',
              limit: body['limit'] as int?,
            ));
        return places.map(_placeMap).toList();
      case '/route/plan':
        final plan = await _request(() => _client.route.plan(
              origin: _stopOf(body['origin']),
              destination: _stopOf(body['destination']),
              waypoints: _stopsOf(body['waypoints']),
              vehicle: body['vehicle'] as String?,
              alternatives: body['alternatives'] as bool?,
            ));
        return _routePlanMap(plan);
      case '/route/forecast':
        final report = await _request(() => _client.route.forecast(
              plan: _routePlanOf(body['plan']),
              departureAt: _parseDate(body['departure_at'])!,
            ));
        return _routeReportMap(report);
      case '/route/plan-with-weather':
        final both = await _request(() => _client.route.planWithWeather(
              origin: _stopOf(body['origin']),
              destination: _stopOf(body['destination']),
              waypoints: _stopsOf(body['waypoints']),
              vehicle: body['vehicle'] as String?,
              departureAt: _parseDate(body['departure_at']),
              alternatives: body['alternatives'] as bool?,
            ));
        return {
          'plan': _routePlanMap(both.plan),
          'weather': _routeReportMap(both.weather),
        };
      case '/route/departures':
        final options = await _request(() => _client.route.compareDepartures(
              plan: _routePlanOf(body['plan']),
              departureAt: _parseDate(body['departure_at'])!,
              offsetsHours:
                  (body['offsets_hours'] as List?)?.whereType<int>().toList(),
            ));
        return options.map(_departureOptionMap).toList();
      case '/journeys':
        final detail = await _request(() => _client.journeys.save(
              title: body['title'] as String? ?? '',
              vehicle: body['vehicle'] as String? ?? 'car',
              departureAt: _parseDate(body['departure_at'])!,
              stops: ((body['stops'] as List?) ?? const []).map(_stopOf).toList(),
              distanceMeters: body['distance_meters'] as int? ?? 0,
              durationSeconds: body['duration_seconds'] as int? ?? 0,
              geometry: body['geometry'] as String? ?? '',
              notes: body['notes'] as String?,
              entryId: _uuidOrNull(body['entry_id']),
              weatherSamples: _samplesOf(body['weather_samples']),
              createEntry: body['create_entry'] as bool?,
              entryText: body['entry_text'] as String?,
              weatherId: body['weather_id'] as int?,
            ));
        return _journeyDetailMap(detail);
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
      'noRoute' => 404,
      'rateLimited' => 429,
      'unavailable' => 503,
      _ => null,
    };
    return ApiException(
      error.message,
      statusCode: statusCode,
      code: error.code,
    );
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
    if (path.startsWith('/journeys/')) return _client.journeys.delete(id);
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

// --- Route planner: JSON in, Serverpod models out (and back) ---------------
//
// The repositories speak the same snake_case JSON as the REST era, so these
// converters keep the request/response shapes identical to the generated ones.

sp.RouteStop _stopOf(dynamic value) {
  final json = (value as Map).cast<String, dynamic>();
  return sp.RouteStop(
    name: json['name'] as String? ?? '',
    lat: (json['lat'] as num?)?.toDouble() ?? 0,
    lon: (json['lon'] as num?)?.toDouble() ?? 0,
    dwellMinutes: json['dwell_minutes'] as int?,
    kind: json['kind'] as String? ?? 'waypoint',
  );
}

List<sp.RouteStop>? _stopsOf(dynamic value) {
  if (value is! List) return null;
  return value.map(_stopOf).toList();
}

sp.RouteLeg _legOf(dynamic value) {
  final json = (value as Map).cast<String, dynamic>();
  return sp.RouteLeg(
    distanceMeters: json['distance_meters'] as int? ?? 0,
    durationSeconds: json['duration_seconds'] as int? ?? 0,
    toIndex: json['to_index'] as int? ?? 0,
  );
}

sp.RouteAlternative _alternativeOf(dynamic value) {
  final json = (value as Map).cast<String, dynamic>();
  return sp.RouteAlternative(
    distanceMeters: json['distance_meters'] as int? ?? 0,
    durationSeconds: json['duration_seconds'] as int? ?? 0,
    geometry: json['geometry'] as String? ?? '',
  );
}

/// Rebuilds the plan the client sends back for a re-forecast or a comparison.
sp.RoutePlan _routePlanOf(dynamic value) {
  final json = (value as Map).cast<String, dynamic>();
  return sp.RoutePlan(
    stops: ((json['stops'] as List?) ?? const []).map(_stopOf).toList(),
    distanceMeters: json['distance_meters'] as int? ?? 0,
    durationSeconds: json['duration_seconds'] as int? ?? 0,
    geometry: json['geometry'] as String? ?? '',
    legs: ((json['legs'] as List?) ?? const []).map(_legOf).toList(),
    alternatives: ((json['alternatives'] as List?) ?? const [])
        .map(_alternativeOf)
        .toList(),
    source: json['source'] as String? ?? 'osrm',
    vehicle: json['vehicle'] as String? ?? 'car',
  );
}

sp.RouteWeatherSample _sampleOf(dynamic value) {
  final json = (value as Map).cast<String, dynamic>();
  return sp.RouteWeatherSample(
    seq: json['seq'] as int? ?? 0,
    label: json['label'] as String? ?? '',
    kind: json['kind'] as String? ?? 'sample',
    lat: (json['lat'] as num?)?.toDouble() ?? 0,
    lon: (json['lon'] as num?)?.toDouble() ?? 0,
    distanceFromStartMeters: json['distance_from_start_meters'] as int? ?? 0,
    arrivalAt: _parseDate(json['arrival_at'])!,
    weatherCode: json['weather_code'] as int?,
    weatherGroup: json['weather_group'] as String?,
    condition: json['condition'] as String?,
    icon: json['icon'] as String?,
    tempC: (json['temp_c'] as num?)?.toDouble(),
    precipitationMm: (json['precipitation_mm'] as num?)?.toDouble(),
    precipitationProbability: json['precipitation_probability'] as int?,
    windSpeedKmh: (json['wind_speed_kmh'] as num?)?.toDouble(),
    severity: json['severity'] as String? ?? 'info',
    reasons: ((json['reasons'] as List?) ?? const []).map((e) => '$e').toList(),
    status: json['status'] as String? ?? 'forecast',
  );
}

List<sp.RouteWeatherSample>? _samplesOf(dynamic value) {
  if (value is! List) return null;
  return value.map(_sampleOf).toList();
}

Map<String, dynamic> _stopMap(sp.RouteStop s) => {
      'name': s.name,
      'lat': s.lat,
      'lon': s.lon,
      'dwell_minutes': s.dwellMinutes,
      'kind': s.kind,
    };

Map<String, dynamic> _placeMap(sp.PlaceCandidate p) => {
      'name': p.name,
      'admin': p.admin,
      'country': p.country,
      'lat': p.lat,
      'lon': p.lon,
    };

Map<String, dynamic> _routeLegMap(sp.RouteLeg l) => {
      'distance_meters': l.distanceMeters,
      'duration_seconds': l.durationSeconds,
      'to_index': l.toIndex,
    };

Map<String, dynamic> _routeAlternativeMap(sp.RouteAlternative a) => {
      'distance_meters': a.distanceMeters,
      'duration_seconds': a.durationSeconds,
      'geometry': a.geometry,
    };

Map<String, dynamic> _routePlanMap(sp.RoutePlan p) => {
      'stops': p.stops.map(_stopMap).toList(),
      'distance_meters': p.distanceMeters,
      'duration_seconds': p.durationSeconds,
      'geometry': p.geometry,
      'legs': p.legs.map(_routeLegMap).toList(),
      'alternatives': p.alternatives.map(_routeAlternativeMap).toList(),
      'source': p.source,
      'vehicle': p.vehicle,
    };

Map<String, dynamic> _routeSampleMap(sp.RouteWeatherSample s) => {
      'seq': s.seq,
      'label': s.label,
      'kind': s.kind,
      'lat': s.lat,
      'lon': s.lon,
      'distance_from_start_meters': s.distanceFromStartMeters,
      'arrival_at': s.arrivalAt.toIso8601String(),
      'weather_code': s.weatherCode,
      'weather_group': s.weatherGroup,
      'condition': s.condition,
      'icon': s.icon,
      'temp_c': s.tempC,
      'precipitation_mm': s.precipitationMm,
      'precipitation_probability': s.precipitationProbability,
      'wind_speed_kmh': s.windSpeedKmh,
      'severity': s.severity,
      'reasons': s.reasons,
      'status': s.status,
    };

Map<String, dynamic> _routeAlertMap(sp.RouteAlert a) => {
      'severity': a.severity,
      'title': a.title,
      'summary': a.summary,
      'start_at': a.startAt.toIso8601String(),
      'end_at': a.endAt.toIso8601String(),
      'from_seq': a.fromSeq,
      'to_seq': a.toSeq,
    };

Map<String, dynamic> _routeReportMap(sp.RouteWeatherReport r) => {
      'generated_at': r.generatedAt.toIso8601String(),
      'coverage': r.coverage,
      'source': r.source,
      'beyond_range': r.beyondRange,
      'samples': r.samples.map(_routeSampleMap).toList(),
      'alerts': r.alerts.map(_routeAlertMap).toList(),
      'notes': r.notes,
    };

Map<String, dynamic> _departureOptionMap(sp.RouteDepartureOption o) => {
      'offset_hours': o.offsetHours,
      'departure_at': o.departureAt.toIso8601String(),
      'arrival_at': o.arrivalAt.toIso8601String(),
      'severity': o.severity,
      'headline': o.headline,
      'weather': _routeReportMap(o.weather),
    };

Map<String, dynamic> _journeyMap(sp.Journey j) => {
      'id': j.id?.toString(),
      'title': j.title,
      'vehicle': j.vehicle,
      'departure_at': j.departureAt.toIso8601String(),
      'origin_name': j.originName,
      'origin_lat': j.originLat,
      'origin_lon': j.originLon,
      'destination_name': j.destinationName,
      'destination_lat': j.destinationLat,
      'destination_lon': j.destinationLon,
      'distance_meters': j.distanceMeters,
      'duration_seconds': j.durationSeconds,
      'geometry': j.geometry,
      'notes': j.notes,
      'entry_id': j.entryId?.toString(),
      'weather_saved_at': j.weatherSavedAt?.toIso8601String(),
    };

Map<String, dynamic> _journeyStopMap(sp.JourneyStop s) => {
      'seq': s.seq,
      'kind': s.kind,
      'name': s.name,
      'lat': s.lat,
      'lon': s.lon,
      'dwell_minutes': s.dwellMinutes,
      'arrival_at': s.arrivalAt?.toIso8601String(),
      'distance_from_start_meters': s.distanceFromStartMeters,
    };

Map<String, dynamic> _journeyWeatherMap(sp.JourneyWeatherPoint p) => {
      'seq': p.seq,
      'sample_at': p.sampleAt.toIso8601String(),
      'lat': p.lat,
      'lon': p.lon,
      'label': p.label,
      'weather_code': p.weatherCode,
      'weather_group': p.weatherGroup,
      'temp_c': p.tempC,
      'precipitation_mm': p.precipitationMm,
      'precipitation_probability': p.precipitationProbability,
      'wind_speed_kmh': p.windSpeedKmh,
      'severity': p.severity,
    };

Map<String, dynamic> _journeyDetailMap(sp.JourneyDetail d) => {
      'journey': _journeyMap(d.journey),
      'stops': d.stops.map(_journeyStopMap).toList(),
      'weather_points': d.weatherPoints.map(_journeyWeatherMap).toList(),
    };



