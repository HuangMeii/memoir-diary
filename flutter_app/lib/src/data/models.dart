/// Immutable data models mirroring the backend response shapes.
library;

/// A mood or weather option, e.g. (happy, "Vui", "#FFD93D").
class LookupItem {
  const LookupItem({
    required this.id,
    required this.code,
    required this.label,
    required this.colorHex,
    required this.icon,
  });

  final int id;
  final String code;
  final String label;
  final String colorHex;
  final String icon;

  factory LookupItem.fromJson(Map<String, dynamic> json) => LookupItem(
        id: json['id'] as int,
        code: json['code'] as String,
        label: json['label_vi'] as String,
        colorHex: json['color_hex'] as String,
        icon: json['icon'] as String,
      );
}

/// One cell of the monthly mood/weather grid.
class GridCell {
  const GridCell({required this.date, this.code, this.label, this.color});

  final DateTime date;
  final String? code;
  final String? label;
  final String? color;

  bool get hasData => code != null;

  factory GridCell.fromJson(Map<String, dynamic> json) => GridCell(
        date: DateTime.parse(json['date'] as String),
        code: json['code'] as String?,
        label: json['label'] as String?,
        color: json['color'] as String?,
      );
}

/// Monthly statistics returned by `/stats/summary`.
class MonthSummary {
  const MonthSummary({
    required this.month,
    required this.daysLogged,
    required this.moodCounts,
    required this.weatherCounts,
    required this.totalSteps,
    required this.totalWorkoutMinutes,
  });

  final String month;
  final int daysLogged;
  final Map<String, int> moodCounts;
  final Map<String, int> weatherCounts;
  final int totalSteps;
  final int totalWorkoutMinutes;

  factory MonthSummary.fromJson(Map<String, dynamic> json) => MonthSummary(
        month: json['month'] as String,
        daysLogged: json['days_logged'] as int? ?? 0,
        moodCounts: Map<String, int>.from(json['mood_counts'] as Map? ?? {}),
        weatherCounts: Map<String, int>.from(json['weather_counts'] as Map? ?? {}),
        totalSteps: json['total_steps'] as int? ?? 0,
        totalWorkoutMinutes: json['total_workout_minutes'] as int? ?? 0,
      );
}

/// A quote from the library (system or user-owned).
class Quote {
  const Quote({
    required this.id,
    required this.text,
    this.author,
    this.category,
  });

  final String id;
  final String text;
  final String? author;
  final String? category;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        id: json['id'] as String,
        text: json['text'] as String,
        author: json['author'] as String?,
        category: json['category'] as String?,
      );
}

/// The quote pair stored for one day, as returned by `/daily-quotes`.
///
/// Both sides are optional: a brand new account has no self message yet, and a
/// quote deleted from the library leaves a row with `quote == null` rather than
/// dropping the day from the history.
///
/// When the user has fewer than 10 saved self messages the server draws two
/// library quotes instead of pairing one with their own, so `quote2` is set
/// and there is no self message on those days.
class DailyQuotePair {
  const DailyQuotePair({
    required this.id,
    required this.date,
    this.quoteId,
    this.quoteId2,
    this.selfMessageId,
    this.quoteText,
    this.quoteAuthor,
    this.quote2Text,
    this.quote2Author,
    this.selfMessageContent,
  });

  final String id;
  final DateTime date;
  final String? quoteId;
  final String? quoteId2;
  final String? selfMessageId;
  final String? quoteText;
  final String? quoteAuthor;
  final String? quote2Text;
  final String? quote2Author;
  final String? selfMessageContent;

  bool get hasQuote => (quoteText ?? '').isNotEmpty;
  bool get hasQuote2 => (quote2Text ?? '').isNotEmpty;
  bool get hasSelfMessage => (selfMessageContent ?? '').isNotEmpty;

  factory DailyQuotePair.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] as Map<String, dynamic>?;
    final quote2 = json['quote_2'] as Map<String, dynamic>?;
    final mine = json['self_message'] as Map<String, dynamic>?;
    return DailyQuotePair(
      id: json['id'] as String,
      date: DateTime.parse(json['quote_date'] as String),
      quoteId: json['quote_id'] as String?,
      quoteId2: json['quote_id_2'] as String?,
      selfMessageId: json['self_message_id'] as String?,
      quoteText: quote?['text'] as String?,
      quoteAuthor: quote?['author'] as String?,
      quote2Text: quote2?['text'] as String?,
      quote2Author: quote2?['author'] as String?,
      selfMessageContent: mine?['content'] as String?,
    );
  }
}

/// A message the user wrote to their future self.
///
/// These build the library the daily pairing draws from: once the user has
/// saved [MIN_SELF_MESSAGES_TO_PAIR] of them a day shows one library quote next
/// to one of these.
class SelfMessage {
  const SelfMessage({
    required this.id,
    required this.content,
    this.createdAt,
  });

  final String id;
  final String content;
  final DateTime? createdAt;

  factory SelfMessage.fromJson(Map<String, dynamic> json) => SelfMessage(
        id: json['id'] as String,
        content: json['content'] as String? ?? '',
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );
}

/// The user's thoughts about a quote pair.
class Reflection {
  const Reflection({
    required this.id,
    this.thought,
    this.quoteId,
    this.selfMessageId,
    this.entryId,
    this.createdAt,
  });

  final String id;
  final String? thought;
  final String? quoteId;
  final String? selfMessageId;
  final String? entryId;
  final DateTime? createdAt;

  factory Reflection.fromJson(Map<String, dynamic> json) => Reflection(
        id: json['id'] as String,
        thought: json['thought'] as String?,
        quoteId: json['quote_id'] as String?,
        selfMessageId: json['self_message_id'] as String?,
        entryId: json['entry_id'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );
}

/// Number of saved self messages needed before the daily card pairs a quote
/// with one of the user's own instead of showing two library quotes.
///
/// Mirrors `quote_service.MIN_SELF_MESSAGES_TO_PAIR` on the server.
const int minSelfMessagesToPair = 10;
/// An image attached to a diary entry.
///
/// The API returns `url: null` on purpose: the bucket is private, so reads go
/// through a short-lived presigned URL from `/images/{id}/url` instead.
class EntryImage {
  const EntryImage({
    required this.id,
    required this.entryId,
    required this.objectKey,
    required this.contentType,
    this.sizeBytes,
    this.caption,
    this.createdAt,
  });

  final String id;
  final String entryId;
  final String objectKey;
  final String contentType;
  final int? sizeBytes;
  final String? caption;
  final DateTime? createdAt;

  factory EntryImage.fromJson(Map<String, dynamic> json) => EntryImage(
        id: json['id'] as String,
        entryId: json['entry_id'] as String,
        objectKey: json['object_key'] as String,
        contentType: json['content_type'] as String,
        sizeBytes: json['size_bytes'] as int?,
        caption: json['caption'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );
}

/// An image plus a presigned URL that is valid for a short while.
class EntryImageView {
  const EntryImageView({required this.image, required this.url});

  final EntryImage image;
  final String url;

  String get id => image.id;
}

/// A daily health record: steps, workout, water, sleep, weight.
///
/// One row per user per day (`uq_health_user_date`), so the API upserts on
/// `log_date` rather than inserting duplicates.
class HealthLog {
  const HealthLog({
    required this.id,
    required this.logDate,
    this.steps,
    this.workoutMinutes,
    this.waterMl,
    this.sleepHours,
    this.weightKg,
    this.note,
  });

  final String id;
  final DateTime logDate;
  final int? steps;
  final int? workoutMinutes;
  final int? waterMl;
  final double? sleepHours;
  final double? weightKg;
  final String? note;

  factory HealthLog.fromJson(Map<String, dynamic> json) => HealthLog(
        id: json['id'] as String,
        logDate: DateTime.parse(json['log_date'] as String),
        steps: json['steps'] as int?,
        workoutMinutes: json['workout_minutes'] as int?,
        waterMl: json['water_ml'] as int?,
        sleepHours: (json['sleep_hours'] as num?)?.toDouble(),
        weightKg: (json['weight_kg'] as num?)?.toDouble(),
        note: json['note'] as String?,
      );

  /// Only send fields the user actually filled in, so a blank field in the
  /// form does not overwrite a stored value with null.
  Map<String, dynamic> toPayload() => {
        if (steps != null) 'steps': steps,
        if (workoutMinutes != null) 'workout_minutes': workoutMinutes,
        if (waterMl != null) 'water_ml': waterMl,
        if (sleepHours != null) 'sleep_hours': sleepHours,
        if (weightKg != null) 'weight_kg': weightKg,
        if (note != null && note!.isNotEmpty) 'note': note,
      };
}

/// A diary entry for one day.
class DiaryEntry {
  const DiaryEntry({
    required this.id,
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
  });

  final String id;
  final DateTime entryDate;
  final int? moodId;
  final int? weatherId;
  final String? diaryText;
  final String? otherPerspective;
  final String? futureMessage;
  final String? selfCare;
  final String? tomorrowHope;
  final String? gratitude;
  final String? dream;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'] as String,
        entryDate: DateTime.parse(json['entry_date'] as String),
        moodId: json['mood_id'] as int?,
        weatherId: json['weather_id'] as int?,
        diaryText: json['diary_text'] as String?,
        otherPerspective: json['other_perspective'] as String?,
        futureMessage: json['future_message'] as String?,
        selfCare: json['self_care'] as String?,
        tomorrowHope: json['tomorrow_hope'] as String?,
        gratitude: json['gratitude'] as String?,
        dream: json['dream'] as String?,
      );

  /// Every content slot of a day, in the order the editor asks for them.
  static const int contentFieldCount = 9;

  /// How many of the [contentFieldCount] slots this day actually fills.
  ///
  /// The home heatmap colours a day by completeness: a day where only the
  /// weather and the mood were tapped scores 2, a fully written page scores 9.
  int get filledFields {
    var filled = 0;
    if (moodId != null) filled++;
    if (weatherId != null) filled++;
    if (_filled(diaryText)) filled++;
    if (_filled(otherPerspective)) filled++;
    if (_filled(futureMessage)) filled++;
    if (_filled(selfCare)) filled++;
    if (_filled(tomorrowHope)) filled++;
    if (_filled(gratitude)) filled++;
    if (_filled(dream)) filled++;
    return filled;
  }

  static bool _filled(String? value) => value != null && value.trim().isNotEmpty;
}

/// The "now" reading from `/weather/current`.
class WeatherCurrent {
  const WeatherCurrent({
    required this.weatherCode,
    required this.condition,
    required this.icon,
    this.time,
    this.temperature,
    this.updatedAt,
  });

  final String? time;
  final double? temperature;
  final int weatherCode;
  final String condition;
  final String icon;

  /// When the server fetched this reading, so a cached answer can be labelled
  /// with the time it was actually taken.
  final String? updatedAt;

  factory WeatherCurrent.fromJson(Map<String, dynamic> json) => WeatherCurrent(
        time: json['time'] as String?,
        temperature: (json['temperature'] as num?)?.toDouble(),
        weatherCode: json['weather_code'] as int? ?? 0,
        condition: json['condition'] as String? ?? '',
        icon: json['icon'] as String? ?? '',
        updatedAt: json['updated_at'] as String?,
      );
}

/// One forecast day.
class WeatherDay {
  const WeatherDay({
    required this.date,
    required this.weatherCode,
    required this.condition,
    required this.icon,
    this.weatherId,
    this.tempMin,
    this.tempMax,
  });

  final DateTime date;
  final int weatherCode;
  final String condition;
  final String icon;
  final int? weatherId;
  final double? tempMin;
  final double? tempMax;

  factory WeatherDay.fromJson(Map<String, dynamic> json) => WeatherDay(
        date: DateTime.parse(json['date'] as String),
        weatherCode: json['weather_code'] as int? ?? 0,
        condition: json['condition'] as String? ?? '',
        icon: json['icon'] as String? ?? '',
        weatherId: json['weather_id'] as int?,
        tempMin: (json['temp_min'] as num?)?.toDouble(),
        tempMax: (json['temp_max'] as num?)?.toDouble(),
      );
}

/// Current weather plus the multi-day forecast.
///
/// [source] is `open-meteo` for a live reading and `cache` when the upstream
/// was unreachable and the server answered from its stored snapshots.
class WeatherForecast {
  const WeatherForecast({
    required this.locationName,
    required this.current,
    required this.daily,
    required this.source,
  });

  final String locationName;
  final WeatherCurrent current;
  final List<WeatherDay> daily;
  final String source;

  bool get isStale => source == 'cache';

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      WeatherForecast(
        locationName: json['location_name'] as String? ?? '',
        current: WeatherCurrent.fromJson(
          (json['current'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
        daily: ((json['daily'] as List?) ?? const [])
            .map((e) => WeatherDay.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        source: json['source'] as String? ?? 'open-meteo',
      );
}

/// Severity of the weather at one point of a route. Mirrors
/// `memoir_server_server/lib/src/route/route_rules.dart`.
abstract final class RouteSeverity {
  static const String info = 'info';
  static const String caution = 'caution';
  static const String warning = 'warning';

  static const List<String> ordered = [info, caution, warning];

  static int rank(String severity) {
    final index = ordered.indexOf(severity);
    return index < 0 ? 0 : index;
  }

  /// The worst of [values], or [info] when empty.
  static String highest(Iterable<String> values) {
    var worst = info;
    for (final value in values) {
      if (rank(value) > rank(worst)) worst = value;
    }
    return worst;
  }

  /// The chip text the route screens show.
  static String label(String severity) => switch (severity) {
        warning => 'Cảnh báo',
        caution => 'Cần chú ý',
        _ => 'Thuận lợi',
      };
}

/// One stop of a planned route: the origin, a waypoint or the destination.
class RouteStop {
  const RouteStop({
    required this.name,
    required this.lat,
    required this.lon,
    this.dwellMinutes = 0,
    this.kind = 'waypoint',
  });

  final String name;
  final double lat;
  final double lon;

  /// Minutes spent here; counts at waypoints only.
  final int dwellMinutes;

  /// origin | waypoint | destination
  final String kind;

  bool get isOrigin => kind == 'origin';
  bool get isDestination => kind == 'destination';
  bool get isWaypoint => kind == 'waypoint';

  RouteStop copyWith({
    String? name,
    double? lat,
    double? lon,
    int? dwellMinutes,
    String? kind,
  }) =>
      RouteStop(
        name: name ?? this.name,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        dwellMinutes: dwellMinutes ?? this.dwellMinutes,
        kind: kind ?? this.kind,
      );

  factory RouteStop.fromJson(Map<String, dynamic> json) => RouteStop(
        name: json['name'] as String? ?? '',
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0,
        dwellMinutes: json['dwell_minutes'] as int? ?? 0,
        kind: json['kind'] as String? ?? 'waypoint',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'lat': lat,
        'lon': lon,
        'dwell_minutes': dwellMinutes,
        'kind': kind,
      };

  @override
  bool operator ==(Object other) =>
      other is RouteStop &&
      other.name == name &&
      other.lat == lat &&
      other.lon == lon &&
      other.dwellMinutes == dwellMinutes &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(name, lat, lon, dwellMinutes, kind);
}

/// Rebuilds a plan from a saved journey so the screen can ask the server for a
/// newer forecast while showing the trip exactly as it was stored.
///
/// The legs are left empty on purpose: the server then spreads the stored
/// duration across the legs in proportion to their length, which is what the
/// saved trip knows about.
RoutePlan planFromJourney(JourneyDetail detail) => RoutePlan(
      stops: [
        for (final stop in detail.stops)
          RouteStop(
            name: stop.name,
            lat: stop.lat,
            lon: stop.lon,
            dwellMinutes: stop.dwellMinutes,
            kind: stop.kind,
          ),
      ],
      distanceMeters: detail.journey.distanceMeters,
      durationSeconds: detail.journey.durationSeconds,
      geometry: detail.journey.geometry,
      legs: const [],
      alternatives: const [],
      source: 'osrm',
      vehicle: detail.journey.vehicle,
    );

/// A place the geocoder knows about.
class PlaceCandidate {
  const PlaceCandidate({
    required this.name,
    required this.lat,
    required this.lon,
    this.admin,
    this.country,
  });

  final String name;
  final double lat;
  final double lon;
  final String? admin;
  final String? country;

  /// "Lâm Đồng · Việt Nam" — the subtitle the suggestion list shows.
  String get subtitle => [admin, country]
      .whereType<String>()
      .where((part) => part.isNotEmpty)
      .join(' · ');

  RouteStop toStop(String kind) =>
      RouteStop(name: name, lat: lat, lon: lon, kind: kind);

  factory PlaceCandidate.fromJson(Map<String, dynamic> json) => PlaceCandidate(
        name: json['name'] as String? ?? '',
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0,
        admin: json['admin'] as String?,
        country: json['country'] as String?,
      );
}

/// One leg of a route: from the previous stop to stop number [toIndex].
class RouteLeg {
  const RouteLeg({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.toIndex,
  });

  final int distanceMeters;
  final int durationSeconds;
  final int toIndex;

  factory RouteLeg.fromJson(Map<String, dynamic> json) => RouteLeg(
        distanceMeters: json['distance_meters'] as int? ?? 0,
        durationSeconds: json['duration_seconds'] as int? ?? 0,
        toIndex: json['to_index'] as int? ?? 0,
      );
}

/// An alternative route the engine offered, without a leg breakdown.
class RouteAlternative {
  const RouteAlternative({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
  });

  final int distanceMeters;
  final int durationSeconds;
  final String geometry;

  factory RouteAlternative.fromJson(Map<String, dynamic> json) =>
      RouteAlternative(
        distanceMeters: json['distance_meters'] as int? ?? 0,
        durationSeconds: json['duration_seconds'] as int? ?? 0,
        geometry: json['geometry'] as String? ?? '',
      );
}

/// A route plus the stops it connects.
class RoutePlan {
  const RoutePlan({
    required this.stops,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    required this.legs,
    required this.alternatives,
    required this.source,
    required this.vehicle,
  });

  final List<RouteStop> stops;
  final int distanceMeters;
  final int durationSeconds;

  /// GeoJSON LineString.
  final String geometry;
  final List<RouteLeg> legs;
  final List<RouteAlternative> alternatives;
  final String source;
  final String vehicle;

  bool get hasAlternatives => alternatives.isNotEmpty;

  factory RoutePlan.fromJson(Map<String, dynamic> json) => RoutePlan(
        stops: ((json['stops'] as List?) ?? const [])
            .map((e) => RouteStop.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        distanceMeters: json['distance_meters'] as int? ?? 0,
        durationSeconds: json['duration_seconds'] as int? ?? 0,
        geometry: json['geometry'] as String? ?? '',
        legs: ((json['legs'] as List?) ?? const [])
            .map((e) => RouteLeg.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        alternatives: ((json['alternatives'] as List?) ?? const [])
            .map((e) =>
                RouteAlternative.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        source: json['source'] as String? ?? 'osrm',
        vehicle: json['vehicle'] as String? ?? 'car',
      );
}

/// Weather at one point of the route, read at the time the traveller is
/// expected to be there.
class RouteWeatherSample {
  const RouteWeatherSample({
    required this.seq,
    required this.label,
    required this.kind,
    required this.lat,
    required this.lon,
    required this.distanceFromStartMeters,
    required this.arrivalAt,
    required this.severity,
    required this.reasons,
    required this.status,
    this.weatherCode,
    this.weatherGroup,
    this.condition,
    this.icon,
    this.tempC,
    this.precipitationMm,
    this.precipitationProbability,
    this.windSpeedKmh,
  });

  final int seq;
  final String label;

  /// origin | waypoint | destination | sample
  final String kind;
  final double lat;
  final double lon;
  final int distanceFromStartMeters;
  final DateTime arrivalAt;
  final int? weatherCode;

  /// `weathers.code` group of [weatherCode], so the app can pick its own icon.
  final String? weatherGroup;
  final String? condition;
  final String? icon;
  final double? tempC;
  final double? precipitationMm;
  final int? precipitationProbability;
  final double? windSpeedKmh;

  /// info | caution | warning
  final String severity;
  final List<String> reasons;

  /// forecast | stale | unavailable
  final String status;

  bool get isStop => kind != 'sample';
  bool get hasWeather => weatherCode != null;
  bool get isStale => status == 'stale';

  factory RouteWeatherSample.fromJson(Map<String, dynamic> json) =>
      RouteWeatherSample(
        seq: json['seq'] as int? ?? 0,
        label: json['label'] as String? ?? '',
        kind: json['kind'] as String? ?? 'sample',
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0,
        distanceFromStartMeters:
            json['distance_from_start_meters'] as int? ?? 0,
        arrivalAt: DateTime.parse(json['arrival_at'] as String).toUtc(),
        weatherCode: json['weather_code'] as int?,
        weatherGroup: json['weather_group'] as String?,
        condition: json['condition'] as String?,
        icon: json['icon'] as String?,
        tempC: (json['temp_c'] as num?)?.toDouble(),
        precipitationMm: (json['precipitation_mm'] as num?)?.toDouble(),
        precipitationProbability: json['precipitation_probability'] as int?,
        windSpeedKmh: (json['wind_speed_kmh'] as num?)?.toDouble(),
        severity: json['severity'] as String? ?? RouteSeverity.info,
        reasons: ((json['reasons'] as List?) ?? const [])
            .map((e) => '$e')
            .toList(),
        status: json['status'] as String? ?? 'unavailable',
      );
}

/// A stretch of the route with unfavourable weather.
class RouteAlert {
  const RouteAlert({
    required this.severity,
    required this.title,
    required this.summary,
    required this.startAt,
    required this.endAt,
    required this.fromSeq,
    required this.toSeq,
  });

  final String severity;
  final String title;
  final String summary;
  final DateTime startAt;
  final DateTime endAt;
  final int fromSeq;
  final int toSeq;

  factory RouteAlert.fromJson(Map<String, dynamic> json) => RouteAlert(
        severity: json['severity'] as String? ?? RouteSeverity.info,
        title: json['title'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        startAt: DateTime.parse(json['start_at'] as String).toUtc(),
        endAt: DateTime.parse(json['end_at'] as String).toUtc(),
        fromSeq: json['from_seq'] as int? ?? 0,
        toSeq: json['to_seq'] as int? ?? 0,
      );
}

/// Weather along a route: one sample per stop and per point between stops.
class RouteWeatherReport {
  const RouteWeatherReport({
    required this.generatedAt,
    required this.coverage,
    required this.source,
    required this.beyondRange,
    required this.samples,
    required this.alerts,
    required this.notes,
  });

  final DateTime generatedAt;

  /// full | partial | none
  final String coverage;

  /// api | cache | unavailable
  final String source;
  final bool beyondRange;
  final List<RouteWeatherSample> samples;
  final List<RouteAlert> alerts;
  final List<String> notes;

  /// The forecast was served from the server's cache.
  bool get isStale => source == 'cache';

  /// Nothing at all came back from the provider.
  bool get isUnavailable => source == 'unavailable' || coverage == 'none';

  bool get isPartial => coverage == 'partial';

  /// The worst severity along the route.
  String get worstSeverity =>
      RouteSeverity.highest(samples.map((sample) => sample.severity));

  /// Only the points that are stops: the origin, the waypoints, the destination.
  List<RouteWeatherSample> get stopSamples =>
      samples.where((sample) => sample.isStop).toList();

  factory RouteWeatherReport.fromJson(Map<String, dynamic> json) =>
      RouteWeatherReport(
        generatedAt: DateTime.parse(json['generated_at'] as String).toUtc(),
        coverage: json['coverage'] as String? ?? 'none',
        source: json['source'] as String? ?? 'unavailable',
        beyondRange: json['beyond_range'] as bool? ?? false,
        samples: ((json['samples'] as List?) ?? const [])
            .map((e) =>
                RouteWeatherSample.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        alerts: ((json['alerts'] as List?) ?? const [])
            .map((e) => RouteAlert.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        notes: ((json['notes'] as List?) ?? const []).map((e) => '$e').toList(),
      );
}

/// A planned route together with the weather along it.
class RoutePlanWithWeather {
  const RoutePlanWithWeather({required this.plan, required this.weather});

  final RoutePlan plan;
  final RouteWeatherReport weather;

  factory RoutePlanWithWeather.fromJson(Map<String, dynamic> json) =>
      RoutePlanWithWeather(
        plan: RoutePlan.fromJson(
          (json['plan'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
        weather: RouteWeatherReport.fromJson(
          (json['weather'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
      );
}

/// One departure time offered by the comparison panel.
class RouteDepartureOption {
  const RouteDepartureOption({
    required this.offsetHours,
    required this.departureAt,
    required this.arrivalAt,
    required this.severity,
    required this.headline,
    required this.weather,
  });

  final int offsetHours;
  final DateTime departureAt;
  final DateTime arrivalAt;
  final String severity;
  final String headline;
  final RouteWeatherReport weather;

  /// The option that matches the departure time the user picked.
  bool get isCurrent => offsetHours == 0;

  factory RouteDepartureOption.fromJson(Map<String, dynamic> json) =>
      RouteDepartureOption(
        offsetHours: json['offset_hours'] as int? ?? 0,
        departureAt: DateTime.parse(json['departure_at'] as String).toUtc(),
        arrivalAt: DateTime.parse(json['arrival_at'] as String).toUtc(),
        severity: json['severity'] as String? ?? RouteSeverity.info,
        headline: json['headline'] as String? ?? '',
        weather: RouteWeatherReport.fromJson(
          (json['weather'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
      );
}

/// A saved trip: the route, its weather snapshot and the diary link.
class Journey {
  const Journey({
    required this.id,
    required this.title,
    required this.vehicle,
    required this.departureAt,
    required this.originName,
    required this.originLat,
    required this.originLon,
    required this.destinationName,
    required this.destinationLat,
    required this.destinationLon,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.geometry,
    this.notes,
    this.entryId,
    this.weatherSavedAt,
  });

  final String id;
  final String title;

  /// car | bike | foot
  final String vehicle;
  final DateTime departureAt;
  final String originName;
  final double originLat;
  final double originLon;
  final String destinationName;
  final double destinationLat;
  final double destinationLon;
  final int distanceMeters;
  final int durationSeconds;

  /// GeoJSON LineString.
  final String geometry;
  final String? notes;

  /// Soft link to the diary entry this trip was written into.
  final String? entryId;

  /// When the weather snapshot was taken; null when none was saved.
  final DateTime? weatherSavedAt;

  bool get hasSavedWeather => weatherSavedAt != null;
  bool get isLinkedToEntry => entryId != null;

  factory Journey.fromJson(Map<String, dynamic> json) => Journey(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        vehicle: json['vehicle'] as String? ?? 'car',
        departureAt: DateTime.parse(json['departure_at'] as String).toUtc(),
        originName: json['origin_name'] as String? ?? '',
        originLat: (json['origin_lat'] as num?)?.toDouble() ?? 0,
        originLon: (json['origin_lon'] as num?)?.toDouble() ?? 0,
        destinationName: json['destination_name'] as String? ?? '',
        destinationLat: (json['destination_lat'] as num?)?.toDouble() ?? 0,
        destinationLon: (json['destination_lon'] as num?)?.toDouble() ?? 0,
        distanceMeters: json['distance_meters'] as int? ?? 0,
        durationSeconds: json['duration_seconds'] as int? ?? 0,
        geometry: json['geometry'] as String? ?? '',
        notes: json['notes'] as String?,
        entryId: json['entry_id'] as String?,
        weatherSavedAt: json['weather_saved_at'] == null
            ? null
            : DateTime.parse(json['weather_saved_at'] as String).toUtc(),
      );
}

/// One stop of a saved journey.
class JourneyStop {
  const JourneyStop({
    required this.seq,
    required this.kind,
    required this.name,
    required this.lat,
    required this.lon,
    required this.dwellMinutes,
    this.arrivalAt,
    this.distanceFromStartMeters,
  });

  final int seq;
  final String kind;
  final String name;
  final double lat;
  final double lon;
  final int dwellMinutes;
  final DateTime? arrivalAt;
  final int? distanceFromStartMeters;

  factory JourneyStop.fromJson(Map<String, dynamic> json) => JourneyStop(
        seq: json['seq'] as int? ?? 0,
        kind: json['kind'] as String? ?? 'waypoint',
        name: json['name'] as String? ?? '',
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0,
        dwellMinutes: json['dwell_minutes'] as int? ?? 0,
        arrivalAt: json['arrival_at'] == null
            ? null
            : DateTime.parse(json['arrival_at'] as String).toUtc(),
        distanceFromStartMeters: json['distance_from_start_meters'] as int?,
      );
}

/// A weather reading saved with a journey.
class JourneyWeatherPoint {
  const JourneyWeatherPoint({
    required this.seq,
    required this.sampleAt,
    required this.lat,
    required this.lon,
    this.label,
    this.weatherCode,
    this.weatherGroup,
    this.tempC,
    this.precipitationMm,
    this.precipitationProbability,
    this.windSpeedKmh,
    this.severity,
  });

  final int seq;
  final DateTime sampleAt;
  final double lat;
  final double lon;
  final String? label;
  final int? weatherCode;
  final String? weatherGroup;
  final double? tempC;
  final double? precipitationMm;
  final int? precipitationProbability;
  final double? windSpeedKmh;
  final String? severity;

  factory JourneyWeatherPoint.fromJson(Map<String, dynamic> json) =>
      JourneyWeatherPoint(
        seq: json['seq'] as int? ?? 0,
        sampleAt: DateTime.parse(json['sample_at'] as String).toUtc(),
        lat: (json['lat'] as num?)?.toDouble() ?? 0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0,
        label: json['label'] as String?,
        weatherCode: json['weather_code'] as int?,
        weatherGroup: json['weather_group'] as String?,
        tempC: (json['temp_c'] as num?)?.toDouble(),
        precipitationMm: (json['precipitation_mm'] as num?)?.toDouble(),
        precipitationProbability: json['precipitation_probability'] as int?,
        windSpeedKmh: (json['wind_speed_kmh'] as num?)?.toDouble(),
        severity: json['severity'] as String?,
      );
}

/// A saved journey with its stops and its weather snapshot.
class JourneyDetail {
  const JourneyDetail({
    required this.journey,
    required this.stops,
    required this.weatherPoints,
  });

  final Journey journey;
  final List<JourneyStop> stops;
  final List<JourneyWeatherPoint> weatherPoints;

  factory JourneyDetail.fromJson(Map<String, dynamic> json) => JourneyDetail(
        journey: Journey.fromJson(
          (json['journey'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
        stops: ((json['stops'] as List?) ?? const [])
            .map((e) => JourneyStop.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
        weatherPoints: ((json['weather_points'] as List?) ?? const [])
            .map((e) =>
                JourneyWeatherPoint.fromJson((e as Map).cast<String, dynamic>()))
            .toList(),
      );
}



