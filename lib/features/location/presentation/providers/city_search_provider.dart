import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../weather/data/weather_repository_impl.dart';
import '../../../weather/domain/entities/weather_snapshot.dart';
import '../../data/geocoding_datasource.dart';
import '../../data/sample_cities.dart';
import '../../domain/entities/city.dart';

final citySearchQueryProvider = StateProvider<String>((ref) => '');

/// Debounce ~350ms: khi query đổi trước khi Future này hoàn tất, Riverpod tự
/// bỏ kết quả cũ vì provider (autoDispose) bị rebuild theo `ref.watch` bên dưới.
final citySearchResultsProvider = FutureProvider.autoDispose<List<City>>((
  ref,
) async {
  final query = ref.watch(citySearchQueryProvider).trim();
  if (query.length < 2) return const [];
  await Future.delayed(const Duration(milliseconds: 350));
  return ref.watch(geocodingDataSourceProvider).search(query);
});

/// Nhiệt độ/điều kiện xem trước cho từng thành phố mẫu — tận dụng cache Hive
/// của `weatherRepositoryProvider` nên chỉ gọi mạng thật lần đầu.
final savedCitiesWeatherProvider =
    FutureProvider<List<(City, WeatherSnapshot?)>>((ref) async {
      final repo = ref.watch(weatherRepositoryProvider);
      return Future.wait(
        sampleCities.map((city) async {
          try {
            return (city, await repo.getWeather(city));
          } catch (_) {
            return (city, null);
          }
        }),
      );
    });
