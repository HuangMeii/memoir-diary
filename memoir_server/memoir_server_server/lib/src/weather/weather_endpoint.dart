import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../auth/auth_utils.dart';
import '../generated/protocol.dart';
import '../shared/session_utils.dart';

/// WMO code -> `weathers.code`. Anything unlisted falls back to "other".
const Map<int, String> _wmoGroups = {
  0: 'sunny',
  1: 'sunny',
  2: 'cloudy',
  3: 'cloudy',
  45: 'cloudy',
  48: 'cloudy',
  51: 'rainy',
  53: 'rainy',
  55: 'rainy',
  56: 'rainy',
  57: 'rainy',
  61: 'rainy',
  63: 'rainy',
  65: 'rainy',
  66: 'rainy',
  67: 'rainy',
  80: 'rainy',
  81: 'rainy',
  82: 'rainy',
  95: 'storm',
  96: 'storm',
  99: 'storm',
};

/// Vietnamese wording matching the seeded lookup labels.
const Map<String, (String, String)> _labels = {
  'sunny': ('Trời quang', '☀️'),
  'cloudy': ('Có mây', '☁️'),
  'rainy': ('Mưa', '🌧️'),
  'storm': ('Bão', '⛈️'),
  'other': ('Khác', '❔'),
};

const double _defaultLat = 21.0285;
const double _defaultLon = 105.8542;
const int _forecastDays = 7;
const Duration _cacheTtl = Duration(minutes: 30);

/// In-memory cache keyed by rounded coordinates.
final Map<String, (DateTime, List<WeatherDay>)> _memory = {};

String _groupForCode(int code) => _wmoGroups[code] ?? 'other';

/// Forecast from Open-Meteo, mirroring FastAPI `/weather`.
class WeatherEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<WeatherForecast> current(Session session) async {
    final user = await requireUser(session);
    final lat = user.weatherLat ?? _defaultLat;
    final lon = user.weatherLon ?? _defaultLon;
    final name = user.weatherLocationName ?? 'Vị trí mặc định';

    final cacheKey = '${lat.toStringAsFixed(2)},${lon.toStringAsFixed(2)}';
    var source = 'api';
    var days = _readCache(cacheKey);

    if (days == null) {
      try {
        days = await _fetch(lat, lon);
        _memory[cacheKey] = (DateTime.now(), days);
        await _saveSnapshots(session, user.id!, days);
      } catch (_) {
        // Degrade to what was stored before, never surface a 500.
        days = null;
        source = 'cache';
      }
    } else {
      source = 'cache';
    }

    days ??= await _stored(session, user.id!);
    if (days.isEmpty) {
      throw ApiException(
        message: 'Không lấy được dữ liệu thời tiết',
        code: 'unavailable',
      );
    }

    final today = days.first;
    return WeatherForecast(
      locationName: name,
      currentTime: today.date,
      currentTemperature: today.tempAvg,
      currentWeatherCode: today.weatherCode,
      condition: today.condition,
      icon: today.icon,
      daily: days,
      source: source,
    );
  }

  /// One day from stored snapshots. Never touches the network.
  Future<WeatherDay?> daily(Session session, DateTime date) async {
    final userId = currentUserId(session);
    final day = dateOnly(date);
    final row = await WeatherSnapshot.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.forecastDate.equals(day),
    );
    return row == null ? null : _fromSnapshot(row);
  }

  Future<List<WeatherDay>> history(
    Session session, {
    DateTime? from,
    DateTime? to,
  }) async {
    final userId = currentUserId(session);
    final end = dateOnly(to ?? DateTime.now());
    final start = dateOnly(from ?? end.subtract(const Duration(days: 29)));
    final rows = await WeatherSnapshot.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          (t.forecastDate >= start) &
          (t.forecastDate <= end),
      orderBy: (t) => t.forecastDate,
    );
    return rows.map(_fromSnapshot).toList();
  }

  Future<void> setLocation(
    Session session, {
    required double lat,
    required double lon,
    String? name,
  }) async {
    final user = await requireUser(session);
    user.weatherLat = lat;
    user.weatherLon = lon;
    user.weatherLocationName = name;
    await User.db.updateRow(session, user);
  }

  List<WeatherDay>? _readCache(String key) {
    final hit = _memory[key];
    if (hit == null) return null;
    if (DateTime.now().difference(hit.$1) > _cacheTtl) {
      _memory.remove(key);
      return null;
    }
    return hit.$2;
  }

  Future<List<WeatherDay>> _fetch(double lat, double lon) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$lat',
      'longitude': '$lon',
      'current': 'temperature_2m,weather_code',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,temperature_2m_mean,precipitation_sum',
      'timezone': 'auto',
      'forecast_days': '$_forecastDays',
    });
    final response = await http.get(uri).timeout(const Duration(seconds: 5));
    if (response.statusCode != 200) {
      throw StateError('Open-Meteo responded ${response.statusCode}');
    }
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final dates = (daily['time'] as List).cast<String>();
    final codes = (daily['weather_code'] as List).cast<num>();
    final maxes = (daily['temperature_2m_max'] as List).cast<num>();
    final mins = (daily['temperature_2m_min'] as List).cast<num>();
    final means = (daily['temperature_2m_mean'] as List?)?.cast<num>();
    final precip = (daily['precipitation_sum'] as List?)?.cast<num>();

    return List.generate(dates.length, (i) {
      final code = codes[i].toInt();
      final (label, icon) = _labels[_groupForCode(code)] ?? _labels['other']!;
      return WeatherDay(
        date: DateTime.utc(
          int.parse(dates[i].substring(0, 4)),
          int.parse(dates[i].substring(5, 7)),
          int.parse(dates[i].substring(8, 10)),
        ),
        weatherCode: code,
        condition: label,
        icon: icon,
        tempMin: mins[i].toDouble(),
        tempMax: maxes[i].toDouble(),
        tempAvg: means != null ? means[i].toDouble() : null,
        precipitationMm: precip != null ? precip[i].toDouble() : null,
      );
    });
  }

  Future<void> _saveSnapshots(
    Session session,
    UuidValue userId,
    List<WeatherDay> days,
  ) async {
    final weatherIds = {
      for (final w in await Weather.db.find(session)) w.code: w.id!,
    };
    for (final day in days) {
      final weatherId = weatherIds[_groupForCode(day.weatherCode)];
      final existing = await WeatherSnapshot.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId) & t.forecastDate.equals(day.date),
      );
      if (existing == null) {
        await WeatherSnapshot.db.insertRow(
          session,
          WeatherSnapshot(
            userId: userId,
            forecastDate: day.date,
            weatherCode: day.weatherCode,
            weatherId: weatherId,
            tempMin: day.tempMin,
            tempMax: day.tempMax,
            tempAvg: day.tempAvg,
            precipitationMm: day.precipitationMm,
          ),
        );
      } else {
        existing.weatherCode = day.weatherCode;
        existing.weatherId = weatherId;
        existing.tempMin = day.tempMin;
        existing.tempMax = day.tempMax;
        existing.tempAvg = day.tempAvg;
        existing.precipitationMm = day.precipitationMm;
        existing.fetchedAt = DateTime.now().toUtc();
        await WeatherSnapshot.db.updateRow(session, existing);
      }
    }
  }

  Future<List<WeatherDay>> _stored(Session session, UuidValue userId) async {
    final today = dateOnly(DateTime.now());
    final rows = await WeatherSnapshot.db.find(
      session,
      where: (t) => t.userId.equals(userId) & (t.forecastDate <= today),
      orderBy: (t) => t.forecastDate.desc(),
      limit: _forecastDays,
    );
    // Newest-first from the query, reversed for a forward forecast.
    return rows.reversed.map(_fromSnapshot).toList();
  }

  WeatherDay _fromSnapshot(WeatherSnapshot row) {
    final (label, icon) =
        _labels[_groupForCode(row.weatherCode)] ?? _labels['other']!;
    return WeatherDay(
      date: row.forecastDate,
      weatherCode: row.weatherCode,
      weatherId: row.weatherId,
      condition: label,
      icon: icon,
      tempMin: row.tempMin,
      tempMax: row.tempMax,
      tempAvg: row.tempAvg,
      precipitationMm: row.precipitationMm,
    );
  }
}
