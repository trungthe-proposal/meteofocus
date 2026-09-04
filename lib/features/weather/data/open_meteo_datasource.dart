import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/api_endpoints.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/dio_client.dart';

/// Gọi Open-Meteo Forecast API — không cần key, xem `ARCHITECTURE.md §4`.
class OpenMeteoDataSource {
  OpenMeteoDataSource(this._dio);

  final Dio _dio;

  static const _currentParams =
      'temperature_2m,relative_humidity_2m,apparent_temperature,'
      'is_day,weather_code,pressure_msl,uv_index,wind_speed_10m';
  static const _hourlyParams = 'temperature_2m,weather_code,is_day';
  static const _dailyParams =
      'weather_code,temperature_2m_max,temperature_2m_min,uv_index_max';

  Future<Map<String, dynamic>> fetchRaw({
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.owmForecastBaseUrl,
        queryParameters: {
          'latitude': lat,
          'longitude': lon,
          'current': _currentParams,
          'hourly': _hourlyParams,
          'daily': _dailyParams,
          'timezone': 'auto',
          'forecast_days': 10,
        },
      );
      return response.data!;
    } on DioException {
      throw const NetworkFailure();
    }
  }
}

final openMeteoDataSourceProvider = Provider<OpenMeteoDataSource>((ref) {
  return OpenMeteoDataSource(ref.watch(dioProvider));
});
