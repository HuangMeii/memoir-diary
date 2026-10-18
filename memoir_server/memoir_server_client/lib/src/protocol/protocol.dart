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
import 'package:memoir_server_client/src/protocol/notes/note_checklist_item.dart'
    as _izn2v3c7;
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
import 'package:memoir_server_client/src/protocol/route/place_candidate.dart'
    as _i972nhj2;
import 'package:memoir_server_client/src/protocol/route/route_departure_option.dart'
    as _ia1gr6j3;
import 'package:memoir_server_client/src/protocol/route/route_stop.dart'
    as _isj44i7w;
import 'package:memoir_server_client/src/protocol/route/route_weather_sample.dart'
    as _iw3tlfli;
import 'package:memoir_server_client/src/protocol/stats/grid_cell.dart'
    as _idxtic5g;
import 'package:memoir_server_client/src/protocol/weather/weather_day.dart'
    as _ituibxbp;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'auth/auth_result.dart' as _i2iwynut;
import 'auth/auth_token.dart' as _i3olc4tp;
import 'auth/user.dart' as _ihzw26wp;
import 'health/health_activity.dart' as _ig3owv0r;
import 'health/health_log.dart' as _ipi876o6;
import 'health/health_profile.dart' as _ik3vhv8i;
import 'health/health_water_entry.dart' as _imk6mzsq;
import 'journal/diary_entry.dart' as _isn947xq;
import 'journal/entry_image.dart' as _i22rqx9f;
import 'journal/entry_image_view.dart' as _iop7kemj;
import 'journal/image_upload_ticket.dart' as _ir6xzchz;
import 'lookups/mood.dart' as _ie2xden6;
import 'lookups/weather.dart' as _i262ionk;
import 'notes/note.dart' as _iylmodbg;
import 'notes/note_checklist_item.dart' as _iv4f5jvm;
import 'notes/note_detail.dart' as _i7hg4pp3;
import 'notes/note_entry_link.dart' as _ifh3czcz;
import 'planner/event.dart' as _itmremj5;
import 'planner/schedule_item.dart' as _ixsuwyrb;
import 'planner/todo.dart' as _ila1vkid;
import 'quotes/daily_quote.dart' as _ivolu13p;
import 'quotes/daily_quote_pair.dart' as _ip1ndbg5;
import 'quotes/quote.dart' as _ijvippl1;
import 'quotes/reflection.dart' as _ie2y0yiy;
import 'quotes/self_message.dart' as _iyriup1i;
import 'route/journey.dart' as _is36joid;
import 'route/journey_detail.dart' as _iknanxwr;
import 'route/journey_stop.dart' as _igofjck1;
import 'route/journey_weather_point.dart' as _ibs4q8yo;
import 'route/place_candidate.dart' as _ino3yrjt;
import 'route/route_alert.dart' as _izwu4g79;
import 'route/route_alternative.dart' as _iidrek38;
import 'route/route_departure_option.dart' as _ixslv2d7;
import 'route/route_leg.dart' as _inhn4us6;
import 'route/route_plan.dart' as _ize64pbg;
import 'route/route_plan_with_weather.dart' as _i1mr55ne;
import 'route/route_stop.dart' as _ia9lknw1;
import 'route/route_weather_report.dart' as _ipvx79ch;
import 'route/route_weather_sample.dart' as _iodoclik;
import 'shared/api_exception.dart' as _iatey69s;
import 'stats/grid_cell.dart' as _idkvug70;
import 'stats/stats_summary.dart' as _iaxcfmie;
import 'weather/weather_day.dart' as _i5dryx1t;
import 'weather/weather_forecast.dart' as _ivf1lbpe;
import 'weather/weather_snapshot.dart' as _i7z01835;
export 'auth/auth_result.dart';
export 'auth/auth_token.dart';
export 'auth/user.dart';
export 'health/health_activity.dart';
export 'health/health_log.dart';
export 'health/health_profile.dart';
export 'health/health_water_entry.dart';
export 'journal/diary_entry.dart';
export 'journal/entry_image.dart';
export 'journal/entry_image_view.dart';
export 'journal/image_upload_ticket.dart';
export 'lookups/mood.dart';
export 'lookups/weather.dart';
export 'notes/note.dart';
export 'notes/note_checklist_item.dart';
export 'notes/note_detail.dart';
export 'notes/note_entry_link.dart';
export 'planner/event.dart';
export 'planner/schedule_item.dart';
export 'planner/todo.dart';
export 'quotes/daily_quote.dart';
export 'quotes/daily_quote_pair.dart';
export 'quotes/quote.dart';
export 'quotes/reflection.dart';
export 'quotes/self_message.dart';
export 'route/journey.dart';
export 'route/journey_detail.dart';
export 'route/journey_stop.dart';
export 'route/journey_weather_point.dart';
export 'route/place_candidate.dart';
export 'route/route_alert.dart';
export 'route/route_alternative.dart';
export 'route/route_departure_option.dart';
export 'route/route_leg.dart';
export 'route/route_plan.dart';
export 'route/route_plan_with_weather.dart';
export 'route/route_stop.dart';
export 'route/route_weather_report.dart';
export 'route/route_weather_sample.dart';
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
    if (t == _ig3owv0r.HealthActivity) {
      return _ig3owv0r.HealthActivity.fromJson(data) as T;
    }
    if (t == _ipi876o6.HealthLog) {
      return _ipi876o6.HealthLog.fromJson(data) as T;
    }
    if (t == _ik3vhv8i.HealthProfile) {
      return _ik3vhv8i.HealthProfile.fromJson(data) as T;
    }
    if (t == _imk6mzsq.HealthWaterEntry) {
      return _imk6mzsq.HealthWaterEntry.fromJson(data) as T;
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
    if (t == _ir6xzchz.ImageUploadTicket) {
      return _ir6xzchz.ImageUploadTicket.fromJson(data) as T;
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
    if (t == _iv4f5jvm.NoteChecklistItem) {
      return _iv4f5jvm.NoteChecklistItem.fromJson(data) as T;
    }
    if (t == _i7hg4pp3.NoteDetail) {
      return _i7hg4pp3.NoteDetail.fromJson(data) as T;
    }
    if (t == _ifh3czcz.NoteEntryLink) {
      return _ifh3czcz.NoteEntryLink.fromJson(data) as T;
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
    if (t == _is36joid.Journey) {
      return _is36joid.Journey.fromJson(data) as T;
    }
    if (t == _iknanxwr.JourneyDetail) {
      return _iknanxwr.JourneyDetail.fromJson(data) as T;
    }
    if (t == _igofjck1.JourneyStop) {
      return _igofjck1.JourneyStop.fromJson(data) as T;
    }
    if (t == _ibs4q8yo.JourneyWeatherPoint) {
      return _ibs4q8yo.JourneyWeatherPoint.fromJson(data) as T;
    }
    if (t == _ino3yrjt.PlaceCandidate) {
      return _ino3yrjt.PlaceCandidate.fromJson(data) as T;
    }
    if (t == _izwu4g79.RouteAlert) {
      return _izwu4g79.RouteAlert.fromJson(data) as T;
    }
    if (t == _iidrek38.RouteAlternative) {
      return _iidrek38.RouteAlternative.fromJson(data) as T;
    }
    if (t == _ixslv2d7.RouteDepartureOption) {
      return _ixslv2d7.RouteDepartureOption.fromJson(data) as T;
    }
    if (t == _inhn4us6.RouteLeg) {
      return _inhn4us6.RouteLeg.fromJson(data) as T;
    }
    if (t == _ize64pbg.RoutePlan) {
      return _ize64pbg.RoutePlan.fromJson(data) as T;
    }
    if (t == _i1mr55ne.RoutePlanWithWeather) {
      return _i1mr55ne.RoutePlanWithWeather.fromJson(data) as T;
    }
    if (t == _ia9lknw1.RouteStop) {
      return _ia9lknw1.RouteStop.fromJson(data) as T;
    }
    if (t == _ipvx79ch.RouteWeatherReport) {
      return _ipvx79ch.RouteWeatherReport.fromJson(data) as T;
    }
    if (t == _iodoclik.RouteWeatherSample) {
      return _iodoclik.RouteWeatherSample.fromJson(data) as T;
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
    if (t == _isc.getType<_ig3owv0r.HealthActivity?>()) {
      return (data != null ? _ig3owv0r.HealthActivity.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ipi876o6.HealthLog?>()) {
      return (data != null ? _ipi876o6.HealthLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ik3vhv8i.HealthProfile?>()) {
      return (data != null ? _ik3vhv8i.HealthProfile.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imk6mzsq.HealthWaterEntry?>()) {
      return (data != null ? _imk6mzsq.HealthWaterEntry.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_ir6xzchz.ImageUploadTicket?>()) {
      return (data != null ? _ir6xzchz.ImageUploadTicket.fromJson(data) : null)
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
    if (t == _isc.getType<_iv4f5jvm.NoteChecklistItem?>()) {
      return (data != null ? _iv4f5jvm.NoteChecklistItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i7hg4pp3.NoteDetail?>()) {
      return (data != null ? _i7hg4pp3.NoteDetail.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifh3czcz.NoteEntryLink?>()) {
      return (data != null ? _ifh3czcz.NoteEntryLink.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_is36joid.Journey?>()) {
      return (data != null ? _is36joid.Journey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iknanxwr.JourneyDetail?>()) {
      return (data != null ? _iknanxwr.JourneyDetail.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igofjck1.JourneyStop?>()) {
      return (data != null ? _igofjck1.JourneyStop.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibs4q8yo.JourneyWeatherPoint?>()) {
      return (data != null
              ? _ibs4q8yo.JourneyWeatherPoint.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ino3yrjt.PlaceCandidate?>()) {
      return (data != null ? _ino3yrjt.PlaceCandidate.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izwu4g79.RouteAlert?>()) {
      return (data != null ? _izwu4g79.RouteAlert.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iidrek38.RouteAlternative?>()) {
      return (data != null ? _iidrek38.RouteAlternative.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixslv2d7.RouteDepartureOption?>()) {
      return (data != null
              ? _ixslv2d7.RouteDepartureOption.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_inhn4us6.RouteLeg?>()) {
      return (data != null ? _inhn4us6.RouteLeg.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ize64pbg.RoutePlan?>()) {
      return (data != null ? _ize64pbg.RoutePlan.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1mr55ne.RoutePlanWithWeather?>()) {
      return (data != null
              ? _i1mr55ne.RoutePlanWithWeather.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ia9lknw1.RouteStop?>()) {
      return (data != null ? _ia9lknw1.RouteStop.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipvx79ch.RouteWeatherReport?>()) {
      return (data != null ? _ipvx79ch.RouteWeatherReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iodoclik.RouteWeatherSample?>()) {
      return (data != null ? _iodoclik.RouteWeatherSample.fromJson(data) : null)
          as T;
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iv4f5jvm.NoteChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_iv4f5jvm.NoteChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isn947xq.DiaryEntry>) {
      return (data as List)
              .map((e) => deserialize<_isn947xq.DiaryEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_igofjck1.JourneyStop>) {
      return (data as List)
              .map((e) => deserialize<_igofjck1.JourneyStop>(e))
              .toList()
          as T;
    }
    if (t == List<_ibs4q8yo.JourneyWeatherPoint>) {
      return (data as List)
              .map((e) => deserialize<_ibs4q8yo.JourneyWeatherPoint>(e))
              .toList()
          as T;
    }
    if (t == List<_ia9lknw1.RouteStop>) {
      return (data as List)
              .map((e) => deserialize<_ia9lknw1.RouteStop>(e))
              .toList()
          as T;
    }
    if (t == List<_inhn4us6.RouteLeg>) {
      return (data as List)
              .map((e) => deserialize<_inhn4us6.RouteLeg>(e))
              .toList()
          as T;
    }
    if (t == List<_iidrek38.RouteAlternative>) {
      return (data as List)
              .map((e) => deserialize<_iidrek38.RouteAlternative>(e))
              .toList()
          as T;
    }
    if (t == List<_iodoclik.RouteWeatherSample>) {
      return (data as List)
              .map((e) => deserialize<_iodoclik.RouteWeatherSample>(e))
              .toList()
          as T;
    }
    if (t == List<_izwu4g79.RouteAlert>) {
      return (data as List)
              .map((e) => deserialize<_izwu4g79.RouteAlert>(e))
              .toList()
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_izn2v3c7.NoteChecklistItem>) {
      return (data as List)
              .map((e) => deserialize<_izn2v3c7.NoteChecklistItem>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_izn2v3c7.NoteChecklistItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_izn2v3c7.NoteChecklistItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_isc.UuidValue>) {
      return (data as List).map((e) => deserialize<_isc.UuidValue>(e)).toList()
          as T;
    }
    if (t == _isc.getType<List<_isc.UuidValue>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_isc.UuidValue>(e))
                    .toList()
              : null)
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
    if (t == List<_i8cgeaon.Journey>) {
      return (data as List)
              .map((e) => deserialize<_i8cgeaon.Journey>(e))
              .toList()
          as T;
    }
    if (t == List<_isj44i7w.RouteStop>) {
      return (data as List)
              .map((e) => deserialize<_isj44i7w.RouteStop>(e))
              .toList()
          as T;
    }
    if (t == List<_iw3tlfli.RouteWeatherSample>) {
      return (data as List)
              .map((e) => deserialize<_iw3tlfli.RouteWeatherSample>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_iw3tlfli.RouteWeatherSample>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iw3tlfli.RouteWeatherSample>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i972nhj2.PlaceCandidate>) {
      return (data as List)
              .map((e) => deserialize<_i972nhj2.PlaceCandidate>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_isj44i7w.RouteStop>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_isj44i7w.RouteStop>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ia1gr6j3.RouteDepartureOption>) {
      return (data as List)
              .map((e) => deserialize<_ia1gr6j3.RouteDepartureOption>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
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
      _ig3owv0r.HealthActivity => 'HealthActivity',
      _ipi876o6.HealthLog => 'HealthLog',
      _ik3vhv8i.HealthProfile => 'HealthProfile',
      _imk6mzsq.HealthWaterEntry => 'HealthWaterEntry',
      _isn947xq.DiaryEntry => 'DiaryEntry',
      _i22rqx9f.EntryImage => 'EntryImage',
      _iop7kemj.EntryImageView => 'EntryImageView',
      _ir6xzchz.ImageUploadTicket => 'ImageUploadTicket',
      _ie2xden6.Mood => 'Mood',
      _i262ionk.Weather => 'Weather',
      _iylmodbg.Note => 'Note',
      _iv4f5jvm.NoteChecklistItem => 'NoteChecklistItem',
      _i7hg4pp3.NoteDetail => 'NoteDetail',
      _ifh3czcz.NoteEntryLink => 'NoteEntryLink',
      _itmremj5.Event => 'Event',
      _ixsuwyrb.ScheduleItem => 'ScheduleItem',
      _ila1vkid.Todo => 'Todo',
      _ivolu13p.DailyQuote => 'DailyQuote',
      _ip1ndbg5.DailyQuotePair => 'DailyQuotePair',
      _ijvippl1.Quote => 'Quote',
      _ie2y0yiy.Reflection => 'Reflection',
      _iyriup1i.SelfMessage => 'SelfMessage',
      _is36joid.Journey => 'Journey',
      _iknanxwr.JourneyDetail => 'JourneyDetail',
      _igofjck1.JourneyStop => 'JourneyStop',
      _ibs4q8yo.JourneyWeatherPoint => 'JourneyWeatherPoint',
      _ino3yrjt.PlaceCandidate => 'PlaceCandidate',
      _izwu4g79.RouteAlert => 'RouteAlert',
      _iidrek38.RouteAlternative => 'RouteAlternative',
      _ixslv2d7.RouteDepartureOption => 'RouteDepartureOption',
      _inhn4us6.RouteLeg => 'RouteLeg',
      _ize64pbg.RoutePlan => 'RoutePlan',
      _i1mr55ne.RoutePlanWithWeather => 'RoutePlanWithWeather',
      _ia9lknw1.RouteStop => 'RouteStop',
      _ipvx79ch.RouteWeatherReport => 'RouteWeatherReport',
      _iodoclik.RouteWeatherSample => 'RouteWeatherSample',
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
      case _ig3owv0r.HealthActivity():
        return 'HealthActivity';
      case _ipi876o6.HealthLog():
        return 'HealthLog';
      case _ik3vhv8i.HealthProfile():
        return 'HealthProfile';
      case _imk6mzsq.HealthWaterEntry():
        return 'HealthWaterEntry';
      case _isn947xq.DiaryEntry():
        return 'DiaryEntry';
      case _i22rqx9f.EntryImage():
        return 'EntryImage';
      case _iop7kemj.EntryImageView():
        return 'EntryImageView';
      case _ir6xzchz.ImageUploadTicket():
        return 'ImageUploadTicket';
      case _ie2xden6.Mood():
        return 'Mood';
      case _i262ionk.Weather():
        return 'Weather';
      case _iylmodbg.Note():
        return 'Note';
      case _iv4f5jvm.NoteChecklistItem():
        return 'NoteChecklistItem';
      case _i7hg4pp3.NoteDetail():
        return 'NoteDetail';
      case _ifh3czcz.NoteEntryLink():
        return 'NoteEntryLink';
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
      case _is36joid.Journey():
        return 'Journey';
      case _iknanxwr.JourneyDetail():
        return 'JourneyDetail';
      case _igofjck1.JourneyStop():
        return 'JourneyStop';
      case _ibs4q8yo.JourneyWeatherPoint():
        return 'JourneyWeatherPoint';
      case _ino3yrjt.PlaceCandidate():
        return 'PlaceCandidate';
      case _izwu4g79.RouteAlert():
        return 'RouteAlert';
      case _iidrek38.RouteAlternative():
        return 'RouteAlternative';
      case _ixslv2d7.RouteDepartureOption():
        return 'RouteDepartureOption';
      case _inhn4us6.RouteLeg():
        return 'RouteLeg';
      case _ize64pbg.RoutePlan():
        return 'RoutePlan';
      case _i1mr55ne.RoutePlanWithWeather():
        return 'RoutePlanWithWeather';
      case _ia9lknw1.RouteStop():
        return 'RouteStop';
      case _ipvx79ch.RouteWeatherReport():
        return 'RouteWeatherReport';
      case _iodoclik.RouteWeatherSample():
        return 'RouteWeatherSample';
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
    if (dataClassName == 'HealthActivity') {
      return deserialize<_ig3owv0r.HealthActivity>(data['data']);
    }
    if (dataClassName == 'HealthLog') {
      return deserialize<_ipi876o6.HealthLog>(data['data']);
    }
    if (dataClassName == 'HealthProfile') {
      return deserialize<_ik3vhv8i.HealthProfile>(data['data']);
    }
    if (dataClassName == 'HealthWaterEntry') {
      return deserialize<_imk6mzsq.HealthWaterEntry>(data['data']);
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
    if (dataClassName == 'ImageUploadTicket') {
      return deserialize<_ir6xzchz.ImageUploadTicket>(data['data']);
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
    if (dataClassName == 'NoteChecklistItem') {
      return deserialize<_iv4f5jvm.NoteChecklistItem>(data['data']);
    }
    if (dataClassName == 'NoteDetail') {
      return deserialize<_i7hg4pp3.NoteDetail>(data['data']);
    }
    if (dataClassName == 'NoteEntryLink') {
      return deserialize<_ifh3czcz.NoteEntryLink>(data['data']);
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
    if (dataClassName == 'Journey') {
      return deserialize<_is36joid.Journey>(data['data']);
    }
    if (dataClassName == 'JourneyDetail') {
      return deserialize<_iknanxwr.JourneyDetail>(data['data']);
    }
    if (dataClassName == 'JourneyStop') {
      return deserialize<_igofjck1.JourneyStop>(data['data']);
    }
    if (dataClassName == 'JourneyWeatherPoint') {
      return deserialize<_ibs4q8yo.JourneyWeatherPoint>(data['data']);
    }
    if (dataClassName == 'PlaceCandidate') {
      return deserialize<_ino3yrjt.PlaceCandidate>(data['data']);
    }
    if (dataClassName == 'RouteAlert') {
      return deserialize<_izwu4g79.RouteAlert>(data['data']);
    }
    if (dataClassName == 'RouteAlternative') {
      return deserialize<_iidrek38.RouteAlternative>(data['data']);
    }
    if (dataClassName == 'RouteDepartureOption') {
      return deserialize<_ixslv2d7.RouteDepartureOption>(data['data']);
    }
    if (dataClassName == 'RouteLeg') {
      return deserialize<_inhn4us6.RouteLeg>(data['data']);
    }
    if (dataClassName == 'RoutePlan') {
      return deserialize<_ize64pbg.RoutePlan>(data['data']);
    }
    if (dataClassName == 'RoutePlanWithWeather') {
      return deserialize<_i1mr55ne.RoutePlanWithWeather>(data['data']);
    }
    if (dataClassName == 'RouteStop') {
      return deserialize<_ia9lknw1.RouteStop>(data['data']);
    }
    if (dataClassName == 'RouteWeatherReport') {
      return deserialize<_ipvx79ch.RouteWeatherReport>(data['data']);
    }
    if (dataClassName == 'RouteWeatherSample') {
      return deserialize<_iodoclik.RouteWeatherSample>(data['data']);
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
