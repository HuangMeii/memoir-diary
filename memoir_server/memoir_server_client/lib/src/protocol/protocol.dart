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
import 'package:memoir_server_client/src/protocol/auth/user.dart' as _i0oax80e;
import 'package:memoir_server_client/src/protocol/health/health_log.dart'
    as _ikfsn92p;
import 'package:memoir_server_client/src/protocol/journal/diary_entry.dart'
    as _i7ztga34;
import 'package:memoir_server_client/src/protocol/journal/entry_image_view.dart'
    as _itedwayj;
import 'package:memoir_server_client/src/protocol/lookups/mood.dart'
    as _i7s3fkt2;
import 'package:memoir_server_client/src/protocol/lookups/weather.dart'
    as _icswdq95;
import 'package:memoir_server_client/src/protocol/notes/note.dart' as _i8gjk5qx;
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
import 'package:memoir_server_client/src/protocol/stats/grid_cell.dart'
    as _idxtic5g;
import 'package:memoir_server_client/src/protocol/weather/weather_day.dart'
    as _ituibxbp;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'auth/auth_result.dart' as _i2iwynut;
import 'auth/auth_token.dart' as _i3olc4tp;
import 'auth/user.dart' as _ihzw26wp;
import 'health/health_log.dart' as _ipi876o6;
import 'journal/diary_entry.dart' as _isn947xq;
import 'journal/entry_image.dart' as _i22rqx9f;
import 'journal/entry_image_view.dart' as _iop7kemj;
import 'lookups/mood.dart' as _ie2xden6;
import 'lookups/weather.dart' as _i262ionk;
import 'notes/note.dart' as _iylmodbg;
import 'planner/event.dart' as _itmremj5;
import 'planner/schedule_item.dart' as _ixsuwyrb;
import 'planner/todo.dart' as _ila1vkid;
import 'quotes/daily_quote.dart' as _ivolu13p;
import 'quotes/daily_quote_pair.dart' as _ip1ndbg5;
import 'quotes/quote.dart' as _ijvippl1;
import 'quotes/reflection.dart' as _ie2y0yiy;
import 'quotes/self_message.dart' as _iyriup1i;
import 'shared/api_exception.dart' as _iatey69s;
import 'stats/grid_cell.dart' as _idkvug70;
import 'stats/stats_summary.dart' as _iaxcfmie;
import 'weather/weather_day.dart' as _i5dryx1t;
import 'weather/weather_forecast.dart' as _ivf1lbpe;
import 'weather/weather_snapshot.dart' as _i7z01835;
export 'auth/auth_result.dart';
export 'auth/auth_token.dart';
export 'auth/user.dart';
export 'health/health_log.dart';
export 'journal/diary_entry.dart';
export 'journal/entry_image.dart';
export 'journal/entry_image_view.dart';
export 'lookups/mood.dart';
export 'lookups/weather.dart';
export 'notes/note.dart';
export 'planner/event.dart';
export 'planner/schedule_item.dart';
export 'planner/todo.dart';
export 'quotes/daily_quote.dart';
export 'quotes/daily_quote_pair.dart';
export 'quotes/quote.dart';
export 'quotes/reflection.dart';
export 'quotes/self_message.dart';
export 'shared/api_exception.dart';
export 'stats/grid_cell.dart';
export 'stats/stats_summary.dart';
export 'weather/weather_day.dart';
export 'weather/weather_forecast.dart';
export 'weather/weather_snapshot.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _ipi876o6.HealthLog) {
      return _ipi876o6.HealthLog.fromJson(data) as T;
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
    if (t == _ie2xden6.Mood) {
      return _ie2xden6.Mood.fromJson(data) as T;
    }
    if (t == _i262ionk.Weather) {
      return _i262ionk.Weather.fromJson(data) as T;
    }
    if (t == _iylmodbg.Note) {
      return _iylmodbg.Note.fromJson(data) as T;
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
    if (t == _isc.getType<_i2iwynut.AuthResult?>()) {
      return (data != null ? _i2iwynut.AuthResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3olc4tp.AuthToken?>()) {
      return (data != null ? _i3olc4tp.AuthToken.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihzw26wp.User?>()) {
      return (data != null ? _ihzw26wp.User.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipi876o6.HealthLog?>()) {
      return (data != null ? _ipi876o6.HealthLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isn947xq.DiaryEntry?>()) {
      return (data != null ? _isn947xq.DiaryEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i22rqx9f.EntryImage?>()) {
      return (data != null ? _i22rqx9f.EntryImage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iop7kemj.EntryImageView?>()) {
      return (data != null ? _iop7kemj.EntryImageView.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ie2xden6.Mood?>()) {
      return (data != null ? _ie2xden6.Mood.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i262ionk.Weather?>()) {
      return (data != null ? _i262ionk.Weather.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iylmodbg.Note?>()) {
      return (data != null ? _iylmodbg.Note.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itmremj5.Event?>()) {
      return (data != null ? _itmremj5.Event.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixsuwyrb.ScheduleItem?>()) {
      return (data != null ? _ixsuwyrb.ScheduleItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ila1vkid.Todo?>()) {
      return (data != null ? _ila1vkid.Todo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivolu13p.DailyQuote?>()) {
      return (data != null ? _ivolu13p.DailyQuote.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip1ndbg5.DailyQuotePair?>()) {
      return (data != null ? _ip1ndbg5.DailyQuotePair.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijvippl1.Quote?>()) {
      return (data != null ? _ijvippl1.Quote.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ie2y0yiy.Reflection?>()) {
      return (data != null ? _ie2y0yiy.Reflection.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyriup1i.SelfMessage?>()) {
      return (data != null ? _iyriup1i.SelfMessage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iatey69s.ApiException?>()) {
      return (data != null ? _iatey69s.ApiException.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idkvug70.GridCell?>()) {
      return (data != null ? _idkvug70.GridCell.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iaxcfmie.StatsSummary?>()) {
      return (data != null ? _iaxcfmie.StatsSummary.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5dryx1t.WeatherDay?>()) {
      return (data != null ? _i5dryx1t.WeatherDay.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivf1lbpe.WeatherForecast?>()) {
      return (data != null ? _ivf1lbpe.WeatherForecast.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7z01835.WeatherSnapshot?>()) {
      return (data != null ? _i7z01835.WeatherSnapshot.fromJson(data) : null)
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
    if (t == List<_i0oax80e.User>) {
      return (data as List).map((e) => deserialize<_i0oax80e.User>(e)).toList()
          as T;
    }
    if (t == List<_igszo10w.Quote>) {
      return (data as List).map((e) => deserialize<_igszo10w.Quote>(e)).toList()
          as T;
    }
    if (t == List<_ikfsn92p.HealthLog>) {
      return (data as List)
              .map((e) => deserialize<_ikfsn92p.HealthLog>(e))
              .toList()
          as T;
    }
    if (t == List<_i7ztga34.DiaryEntry>) {
      return (data as List)
              .map((e) => deserialize<_i7ztga34.DiaryEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_itedwayj.EntryImageView>) {
      return (data as List)
              .map((e) => deserialize<_itedwayj.EntryImageView>(e))
              .toList()
          as T;
    }
    if (t == List<_i7s3fkt2.Mood>) {
      return (data as List).map((e) => deserialize<_i7s3fkt2.Mood>(e)).toList()
          as T;
    }
    if (t == List<_icswdq95.Weather>) {
      return (data as List)
              .map((e) => deserialize<_icswdq95.Weather>(e))
              .toList()
          as T;
    }
    if (t == List<_i8gjk5qx.Note>) {
      return (data as List).map((e) => deserialize<_i8gjk5qx.Note>(e)).toList()
          as T;
    }
    if (t == List<_ijprwagz.Event>) {
      return (data as List).map((e) => deserialize<_ijprwagz.Event>(e)).toList()
          as T;
    }
    if (t == List<_ijhdkgyn.ScheduleItem>) {
      return (data as List)
              .map((e) => deserialize<_ijhdkgyn.ScheduleItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isxzecl5.Todo>) {
      return (data as List).map((e) => deserialize<_isxzecl5.Todo>(e)).toList()
          as T;
    }
    if (t == List<_i9w1lcsl.DailyQuotePair>) {
      return (data as List)
              .map((e) => deserialize<_i9w1lcsl.DailyQuotePair>(e))
              .toList()
          as T;
    }
    if (t == List<_ivmwvttz.Reflection>) {
      return (data as List)
              .map((e) => deserialize<_ivmwvttz.Reflection>(e))
              .toList()
          as T;
    }
    if (t == List<_i4smoveg.SelfMessage>) {
      return (data as List)
              .map((e) => deserialize<_i4smoveg.SelfMessage>(e))
              .toList()
          as T;
    }
    if (t == List<_idxtic5g.GridCell>) {
      return (data as List)
              .map((e) => deserialize<_idxtic5g.GridCell>(e))
              .toList()
          as T;
    }
    if (t == List<_ituibxbp.WeatherDay>) {
      return (data as List)
              .map((e) => deserialize<_ituibxbp.WeatherDay>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2iwynut.AuthResult => 'AuthResult',
      _i3olc4tp.AuthToken => 'AuthToken',
      _ihzw26wp.User => 'User',
      _ipi876o6.HealthLog => 'HealthLog',
      _isn947xq.DiaryEntry => 'DiaryEntry',
      _i22rqx9f.EntryImage => 'EntryImage',
      _iop7kemj.EntryImageView => 'EntryImageView',
      _ie2xden6.Mood => 'Mood',
      _i262ionk.Weather => 'Weather',
      _iylmodbg.Note => 'Note',
      _itmremj5.Event => 'Event',
      _ixsuwyrb.ScheduleItem => 'ScheduleItem',
      _ila1vkid.Todo => 'Todo',
      _ivolu13p.DailyQuote => 'DailyQuote',
      _ip1ndbg5.DailyQuotePair => 'DailyQuotePair',
      _ijvippl1.Quote => 'Quote',
      _ie2y0yiy.Reflection => 'Reflection',
      _iyriup1i.SelfMessage => 'SelfMessage',
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
      case _ipi876o6.HealthLog():
        return 'HealthLog';
      case _isn947xq.DiaryEntry():
        return 'DiaryEntry';
      case _i22rqx9f.EntryImage():
        return 'EntryImage';
      case _iop7kemj.EntryImageView():
        return 'EntryImageView';
      case _ie2xden6.Mood():
        return 'Mood';
      case _i262ionk.Weather():
        return 'Weather';
      case _iylmodbg.Note():
        return 'Note';
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
    if (dataClassName == 'HealthLog') {
      return deserialize<_ipi876o6.HealthLog>(data['data']);
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
    if (dataClassName == 'Mood') {
      return deserialize<_ie2xden6.Mood>(data['data']);
    }
    if (dataClassName == 'Weather') {
      return deserialize<_i262ionk.Weather>(data['data']);
    }
    if (dataClassName == 'Note') {
      return deserialize<_iylmodbg.Note>(data['data']);
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
    return super.deserializeByClassName(data);
  }

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
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
