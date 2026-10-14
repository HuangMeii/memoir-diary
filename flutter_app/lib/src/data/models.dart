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
    this.createdAt,
    this.updatedAt,
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at'] as String),
      );

  /// Every content slot of a day, in the order the editor asks for them.
  ///
  /// `Nhắn nhủ tương lai` used to be one of them; the field left the editor, so
  /// it no longer counts towards how complete a page is (the column is kept, see
  /// `entry_editor.dart`).
  static const int contentFieldCount = 8;

  /// How many of the [contentFieldCount] slots this day actually fills.
  ///
  /// The home heatmap colours a day by completeness: a day where only the
  /// weather and the mood were tapped scores 2, a fully written page scores 8.
  int get filledFields {
    var filled = 0;
    if (moodId != null) filled++;
    if (weatherId != null) filled++;
    if (_filled(diaryText)) filled++;
    if (_filled(otherPerspective)) filled++;
    if (_filled(selfCare)) filled++;
    if (_filled(tomorrowHope)) filled++;
    if (_filled(gratitude)) filled++;
    if (_filled(dream)) filled++;
    return filled;
  }

  static bool _filled(String? value) => value != null && value.trim().isNotEmpty;
}

/// A quick note with title, tags, pin/archive/trash flags.
class Note {
  const Note({
    required this.id,
    this.title,
    required this.content,
    this.color,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.isTrashed = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? title;
  final String content;
  final String? color;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;
  final bool isTrashed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String?,
        content: json['content'] as String? ?? '',
        color: json['color'] as String?,
        tags: ((json['tags'] as List?) ?? const [])
            .map((e) => '$e')
            .toList(growable: false),
        isPinned: json['is_pinned'] as bool? ?? false,
        isArchived: json['is_archived'] as bool? ?? false,
        isTrashed: json['is_trashed'] as bool? ?? false,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (title != null) 'title': title,
        'content': content,
        if (color != null) 'color': color,
        'tags': tags,
        'is_pinned': isPinned,
        'is_archived': isArchived,
        'is_trashed': isTrashed,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  Note copyWith({
    String? title,
    String? content,
    String? color,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isTrashed,
  }) =>
      Note(
        id: id,
        title: title ?? this.title,
        content: content ?? this.content,
        color: color ?? this.color,
        tags: tags ?? this.tags,
        isPinned: isPinned ?? this.isPinned,
        isArchived: isArchived ?? this.isArchived,
        isTrashed: isTrashed ?? this.isTrashed,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Title shown on cards: explicit title, else first line of content.
  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    final first = content.split('\n').first.trim();
    if (first.isEmpty) return '(Ghi chú)';
    return first.length > 60 ? '${first.substring(0, 60)}…' : first;
  }

  /// Body preview without the title line.
  String get preview {
    final lines = content.split('\n');
    if (title?.trim().isNotEmpty == true) {
      return lines.join('\n').trim();
    }
    if (lines.length <= 1) return content.trim();
    return lines.skip(1).join('\n').trim();
  }

  /// Word count of the body, ignoring pure markdown markers.
  int get wordCount {
    final cleaned = content.replaceAll(RegExp(r'[#>*`\-+[\]().!]'), ' ');
    return RegExp(r'\S+').allMatches(cleaned).length;
  }
}

/// One interactive checklist line inside a note.
class NoteChecklistItem {
  const NoteChecklistItem({
    this.id,
    this.noteId,
    required this.text,
    this.isDone = false,
    this.sortOrder = 0,
  });

  final String? id;
  final String? noteId;
  final String text;
  final bool isDone;
  final int sortOrder;

  factory NoteChecklistItem.fromJson(Map<String, dynamic> json) =>
      NoteChecklistItem(
        id: json['id'] as String?,
        noteId: json['note_id'] as String?,
        text: json['text'] as String? ?? '',
        isDone: json['is_done'] as bool? ?? false,
        sortOrder: json['sort_order'] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (noteId != null) 'note_id': noteId,
        'text': text,
        'is_done': isDone,
        'sort_order': sortOrder,
      };

  NoteChecklistItem copyWith({bool? isDone, String? text, int? sortOrder}) =>
      NoteChecklistItem(
        id: id,
        noteId: noteId,
        text: text ?? this.text,
        isDone: isDone ?? this.isDone,
        sortOrder: sortOrder ?? this.sortOrder,
      );
}

/// Link between a note and one diary entry.
class NoteEntryLink {
  const NoteEntryLink({
    this.id,
    this.noteId,
    required this.entryId,
    this.createdAt,
  });

  final String? id;
  final String? noteId;
  final String entryId;
  final DateTime? createdAt;

  factory NoteEntryLink.fromJson(Map<String, dynamic> json) => NoteEntryLink(
        id: json['id'] as String?,
        noteId: json['note_id'] as String?,
        entryId: json['entry_id'] as String? ?? '',
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'] as String),
      );
}

/// A note with its checklist and linked entries for the editor.
class NoteDetail {
  const NoteDetail({
    required this.note,
    this.checklist = const [],
    this.entries = const [],
  });

  final Note note;
  final List<NoteChecklistItem> checklist;
  final List<DiaryEntry> entries;

  factory NoteDetail.fromJson(Map<String, dynamic> json) => NoteDetail(
        note: Note.fromJson(
          (json['note'] as Map).cast<String, dynamic>(),
        ),
        checklist: ((json['checklist'] as List?) ?? const [])
            .map((e) => NoteChecklistItem.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ))
            .toList(),
        entries: ((json['entries'] as List?) ?? const [])
            .map((e) => DiaryEntry.fromJson(
                  (e as Map).cast<String, dynamic>(),
                ))
            .toList(),
      );
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