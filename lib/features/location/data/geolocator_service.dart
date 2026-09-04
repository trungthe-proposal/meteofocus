import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/error/failures.dart';
import '../domain/entities/city.dart';

/// Bọc `geolocator` — xem `ARCHITECTURE.md §11` (fallback khi quyền bị từ chối).
class GeolocatorService {
  const GeolocatorService();

  /// Open-Meteo Geocoding API chỉ tìm theo tên (không có reverse-geocoding),
  /// nên vị trí từ GPS không có tên thành phố thật — dùng nhãn chung.
  Future<City> getCurrentCity() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationPermissionDeniedFailure('Dịch vụ vị trí đang tắt');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw const LocationPermissionDeniedFailure();
      }

      // Web định vị qua WiFi/IP (không có GPS chip) nên có thể chậm bất
      // thường — giới hạn thời gian chờ, quá hạn thì fallback như bị từ chối
      // quyền thay vì treo vô thời hạn.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 6),
        ),
      );
      return City(
        id: 'gps-${position.latitude},${position.longitude}',
        name: 'Vị trí của bạn',
        countryCode: '',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const LocationPermissionDeniedFailure();
    }
  }
}

final geolocatorServiceProvider = Provider<GeolocatorService>(
  (ref) => const GeolocatorService(),
);
