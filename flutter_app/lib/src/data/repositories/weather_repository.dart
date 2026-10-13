import '../datasources/backend_data_source.dart';
import '../models.dart';

/// Weather forecast, backed by the FastAPI or Serverpod `/weather` API.
///
/// The server owns the Open-Meteo call, the WMO mapping and the two-layer
/// cache, so the client only reads the shaped result.
class WeatherRepository {
  const WeatherRepository(this._source);

  final BackendDataSource _source;

  Future<WeatherForecast> current() async {
    final data = await _source.get('/weather/current');
    return WeatherForecast.fromJson((data as Map).cast<String, dynamic>());
  }

  /// One day from the stored snapshots; never touches the network on the
  /// server, so it still answers when Open-Meteo is down.
  Future<WeatherDay?> daily(String isoDate) async {
    final data = await _source.get('/weather/daily', query: {'date': isoDate});
    if (data == null) return null;
    return WeatherDay.fromJson((data as Map).cast<String, dynamic>());
  }

  Future<List<WeatherDay>> history({
    required String from,
    required String to,
  }) async {
    final data = await _source.get(
      '/weather/history',
      query: {'from': from, 'to': to},
    );
    final days = (data as Map)['days'] as List? ?? const [];
    return days
        .map((e) => WeatherDay.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<void> setLocation({
    required double lat,
    required double lon,
    String? name,
  }) =>
      _source.put('/weather/location', data: {
        'lat': lat,
        'lon': lon,
        'name': name,
      });
}
