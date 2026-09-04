import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../core/cache/weather_box_provider.dart';
import '../../../core/error/failures.dart';
import '../../location/domain/entities/city.dart';
import '../domain/entities/current_weather.dart';
import '../domain/entities/daily_forecast_entry.dart';
import '../domain/entities/hourly_forecast_entry.dart';
import '../domain/entities/weather_snapshot.dart';
import '../domain/weather_repository.dart';
import 'models/weather_response_model.dart';
import 'open_meteo_datasource.dart';

/// Cache-first, TTL 15 phút, offline fallback — xem `ARCHITECTURE.md §10`.
class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(this._dataSource, this._box);

  final OpenMeteoDataSource _dataSource;
  final Box _box;

  static const _cacheTtl = Duration(minutes: 15);
  static const _backgroundRefreshAfter = Duration(minutes: 5);

  String _cacheKey(City city) =>
      '${city.latitude.toStringAsFixed(2)},${city.longitude.toStringAsFixed(2)}';

  @override
  Future<WeatherSnapshot> getWeather(City city) async {
    final key = _cacheKey(city);
    final cached = _readCache(city, key);

    if (cached != null) {
      final age = DateTime.now().difference(cached.fetchedAt);
      if (age < _cacheTtl) {
        if (age > _backgroundRefreshAfter) {
          // Trả cache ngay, refetch nền không chờ — lỗi refetch nền bỏ qua.
          unawaited(_refreshAndCache(city, key).catchError((_) => cached));
        }
        return cached;
      }
    }

    try {
      return await _refreshAndCache(city, key);
    } on NetworkFailure {
      if (cached != null) return cached.copyWith(isStale: true);
      rethrow;
    }
  }

  Future<WeatherSnapshot> _refreshAndCache(City city, String key) async {
    final json = await _dataSource.fetchRaw(
      lat: city.latitude,
      lon: city.longitude,
    );
    final model = WeatherResponseModel.fromJson(json);
    final fetchedAt = DateTime.now();
    await _box.put(key, {
      'json': jsonEncode(json),
      'fetchedAtMillis': fetchedAt.millisecondsSinceEpoch,
    });
    return _toSnapshot(city, model, fetchedAt);
  }

  WeatherSnapshot? _readCache(City city, String key) {
    final raw = _box.get(key);
    if (raw is! Map) return null;
    try {
      final json = jsonDecode(raw['json'] as String) as Map<String, dynamic>;
      final model = WeatherResponseModel.fromJson(json);
      final fetchedAt = DateTime.fromMillisecondsSinceEpoch(
        raw['fetchedAtMillis'] as int,
      );
      return _toSnapshot(city, model, fetchedAt);
    } catch (_) {
      return null;
    }
  }

  WeatherSnapshot _toSnapshot(
    City city,
    WeatherResponseModel model,
    DateTime fetchedAt,
  ) {
    final c = model.current;
    return WeatherSnapshot(
      city: city,
      current: CurrentWeather(
        time: c.time,
        temperature: c.temperature2m,
        apparentTemperature: c.apparentTemperature,
        humidity: c.relativeHumidity2m,
        pressure: c.pressureMsl,
        uvIndex: c.uvIndex,
        weatherCode: c.weatherCode,
        isDay: c.isDay,
        windSpeedKmh: c.windSpeed10m,
      ),
      hourly: [
        for (var i = 0; i < model.hourly.time.length; i++)
          HourlyForecastEntry(
            time: model.hourly.time[i],
            temperature: model.hourly.temperature2m[i],
            weatherCode: model.hourly.weatherCode[i],
            isDay: model.hourly.isDay[i],
          ),
      ],
      daily: [
        for (var i = 0; i < model.daily.time.length; i++)
          DailyForecastEntry(
            date: model.daily.time[i],
            tempMax: model.daily.tempMax[i],
            tempMin: model.daily.tempMin[i],
            weatherCode: model.daily.weatherCode[i],
            uvIndexMax: model.daily.uvIndexMax[i],
          ),
      ],
      fetchedAt: fetchedAt,
    );
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl(
    ref.watch(openMeteoDataSourceProvider),
    ref.watch(weatherBoxProvider),
  );
});
