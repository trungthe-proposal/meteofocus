import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failures.dart';
import '../../../location/data/geolocator_service.dart';
import '../../../location/data/last_city_store.dart';
import '../../../location/domain/entities/city.dart';
import '../../data/weather_repository_impl.dart';
import '../../domain/entities/weather_snapshot.dart';

/// Thứ tự ưu tiên khi khởi động — xem `ARCHITECTURE.md §11`:
/// 1. Thành phố đã nhớ từ lần chọn trước (`LastCityStore`) — nếu có, dùng
///    luôn, bỏ qua GPS vì người dùng đã có lựa chọn rõ ràng.
/// 2. Chưa có gì nhớ: hiện ngay `City.defaultCity` (Hà Nội) — không chờ GPS
///    trên critical path vì định vị qua WiFi/IP trên web có thể chậm vài
///    giây — rồi âm thầm thử GPS ở nền, thành công thì cập nhật + nhớ lại
///    luôn cho lần sau.
class WeatherController extends AsyncNotifier<WeatherSnapshot> {
  bool _userPickedCity = false;

  @override
  Future<WeatherSnapshot> build() async {
    final remembered = ref.read(lastCityStoreProvider).read();
    if (remembered != null) {
      _userPickedCity = true;
      return ref.read(weatherRepositoryProvider).getWeather(remembered);
    }

    final snapshot = await ref
        .read(weatherRepositoryProvider)
        .getWeather(City.defaultCity);
    unawaited(_upgradeToGpsCityInBackground());
    return snapshot;
  }

  Future<void> _upgradeToGpsCityInBackground() async {
    try {
      final city = await ref.read(geolocatorServiceProvider).getCurrentCity();
      if (_userPickedCity) return;
      if (city.latitude == City.defaultCity.latitude &&
          city.longitude == City.defaultCity.longitude) {
        return;
      }
      final snapshot = await ref
          .read(weatherRepositoryProvider)
          .getWeather(city);
      if (_userPickedCity) return;
      state = AsyncData(snapshot);
      await ref.read(lastCityStoreProvider).write(city);
    } on AppFailure {
      // GPS bị từ chối/timeout/mất mạng — giữ nguyên thành phố mặc định đang
      // hiện, không có gì để báo lỗi cho người dùng ở đây.
    }
  }

  Future<void> selectCity(City city) async {
    _userPickedCity = true;
    state = const AsyncLoading<WeatherSnapshot>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(weatherRepositoryProvider).getWeather(city),
    );
    if (state.hasValue) {
      await ref.read(lastCityStoreProvider).write(city);
    }
  }

  Future<void> refresh() async {
    final city = state.valueOrNull?.city;
    if (city == null) {
      ref.invalidateSelf();
      return;
    }
    state = const AsyncLoading<WeatherSnapshot>().copyWithPrevious(state);
    state = await AsyncValue.guard(
      () => ref.read(weatherRepositoryProvider).getWeather(city),
    );
  }
}

final weatherProvider = AsyncNotifierProvider<WeatherController, WeatherSnapshot>(
  WeatherController.new,
);
