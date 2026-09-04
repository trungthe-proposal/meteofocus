import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/api_endpoints.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entities/city.dart';

/// Open-Meteo Geocoding API — không cần key, xem `ARCHITECTURE.md §4`.
class GeocodingDataSource {
  GeocodingDataSource(this._dio);

  final Dio _dio;

  Future<List<City>> search(String query) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.owmGeocodingBaseUrl,
        queryParameters: {
          'name': query,
          'count': 8,
          'language': 'vi',
          'format': 'json',
        },
      );
      final results = response.data?['results'] as List?;
      if (results == null) return const [];
      return results.map((raw) {
        final json = raw as Map<String, dynamic>;
        return City(
          id: (json['id'] as num).toString(),
          name: json['name'] as String,
          countryCode: (json['country_code'] as String?) ?? '',
          latitude: (json['latitude'] as num).toDouble(),
          longitude: (json['longitude'] as num).toDouble(),
        );
      }).toList();
    } on DioException {
      throw const NetworkFailure();
    }
  }
}

final geocodingDataSourceProvider = Provider<GeocodingDataSource>((ref) {
  return GeocodingDataSource(ref.watch(dioProvider));
});
