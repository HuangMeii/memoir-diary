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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Diary entry (central entity). One row per user per day.
abstract class DiaryEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DiaryEntry._({
    this.id,
    required this.userId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory DiaryEntry({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DiaryEntryImpl;

  factory DiaryEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return DiaryEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      entryDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['entryDate'],
      ),
      moodId: jsonSerialization['moodId'] as int?,
      weatherId: jsonSerialization['weatherId'] as int?,
      diaryText: jsonSerialization['diaryText'] as String?,
      otherPerspective: jsonSerialization['otherPerspective'] as String?,
      futureMessage: jsonSerialization['futureMessage'] as String?,
      selfCare: jsonSerialization['selfCare'] as String?,
      tomorrowHope: jsonSerialization['tomorrowHope'] as String?,
      gratitude: jsonSerialization['gratitude'] as String?,
      dream: jsonSerialization['dream'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue userId;

  /// Date-only value; time component is ignored.
  DateTime entryDate;

  int? moodId;

  int? weatherId;

  String? diaryText;

  String? otherPerspective;

  String? futureMessage;

  String? selfCare;

  String? tomorrowHope;

  String? gratitude;

  String? dream;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DiaryEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DiaryEntry copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? userId,
    DateTime? entryDate,
    int? moodId,
    int? weatherId,
    String? diaryText,
    String? otherPerspective,
    String? futureMessage,
    String? selfCare,
    String? tomorrowHope,
    String? gratitude,
    String? dream,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DiaryEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'entryDate': entryDate.toJson(),
      if (moodId != null) 'moodId': moodId,
      if (weatherId != null) 'weatherId': weatherId,
      if (diaryText != null) 'diaryText': diaryText,
      if (otherPerspective != null) 'otherPerspective': otherPerspective,
      if (futureMessage != null) 'futureMessage': futureMessage,
      if (selfCare != null) 'selfCare': selfCare,
      if (tomorrowHope != null) 'tomorrowHope': tomorrowHope,
      if (gratitude != null) 'gratitude': gratitude,
      if (dream != null) 'dream': dream,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DiaryEntry',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'entryDate': entryDate.toJson(),
      if (moodId != null) 'moodId': moodId,
      if (weatherId != null) 'weatherId': weatherId,
      if (diaryText != null) 'diaryText': diaryText,
      if (otherPerspective != null) 'otherPerspective': otherPerspective,
      if (futureMessage != null) 'futureMessage': futureMessage,
      if (selfCare != null) 'selfCare': selfCare,
      if (tomorrowHope != null) 'tomorrowHope': tomorrowHope,
      if (gratitude != null) 'gratitude': gratitude,
      if (dream != null) 'dream': dream,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DiaryEntryImpl extends DiaryEntry {
  _DiaryEntryImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue userId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         entryDate: entryDate,
         moodId: moodId,
         weatherId: weatherId,
         diaryText: diaryText,
         otherPerspective: otherPerspective,
         futureMessage: futureMessage,
         selfCare: selfCare,
         tomorrowHope: tomorrowHope,
         gratitude: gratitude,
         dream: dream,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DiaryEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DiaryEntry copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? entryDate,
    Object? moodId = _Undefined,
    Object? weatherId = _Undefined,
    Object? diaryText = _Undefined,
    Object? otherPerspective = _Undefined,
    Object? futureMessage = _Undefined,
    Object? selfCare = _Undefined,
    Object? tomorrowHope = _Undefined,
    Object? gratitude = _Undefined,
    Object? dream = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      id: id is _isc.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      entryDate: entryDate ?? this.entryDate,
      moodId: moodId is int? ? moodId : this.moodId,
      weatherId: weatherId is int? ? weatherId : this.weatherId,
      diaryText: diaryText is String? ? diaryText : this.diaryText,
      otherPerspective: otherPerspective is String?
          ? otherPerspective
          : this.otherPerspective,
      futureMessage: futureMessage is String?
          ? futureMessage
          : this.futureMessage,
      selfCare: selfCare is String? ? selfCare : this.selfCare,
      tomorrowHope: tomorrowHope is String? ? tomorrowHope : this.tomorrowHope,
      gratitude: gratitude is String? ? gratitude : this.gratitude,
      dream: dream is String? ? dream : this.dream,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
