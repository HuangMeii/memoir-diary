/// Immutable data models mirroring the FastAPI response shapes.
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
}