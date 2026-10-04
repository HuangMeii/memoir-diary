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