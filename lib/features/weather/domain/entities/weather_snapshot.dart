import '../../../location/domain/entities/city.dart';
import 'current_weather.dart';
import 'daily_forecast_entry.dart';
import 'hourly_forecast_entry.dart';

/// Gộp toàn bộ dữ liệu thời tiết 1 thành phố cần cho UI — xem `ARCHITECTURE.md §10`.
class WeatherSnapshot {
  const WeatherSnapshot({
    required this.city,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.fetchedAt,
    this.isStale = false,
  });

  final City city;
  final CurrentWeather current;
  final List<HourlyForecastEntry> hourly;
  final List<DailyForecastEntry> daily;

  /// Thời điểm dữ liệu này được fetch từ API — dùng tính TTL cache.
  final DateTime fetchedAt;

  /// true khi đây là cache đã hết hạn nhưng phải dùng tạm vì mất mạng.
  final bool isStale;

  WeatherSnapshot copyWith({bool? isStale}) => WeatherSnapshot(
    city: city,
    current: current,
    hourly: hourly,
    daily: daily,
    fetchedAt: fetchedAt,
    isStale: isStale ?? this.isStale,
  );
}
