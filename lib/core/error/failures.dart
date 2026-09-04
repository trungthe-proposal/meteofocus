/// Failure tối thiểu theo `ARCHITECTURE.md §11`.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Không có kết nối mạng']);
}

final class LocationPermissionDeniedFailure extends AppFailure {
  const LocationPermissionDeniedFailure([
    super.message = 'Quyền truy cập vị trí bị từ chối',
  ]);
}

final class CityNotFoundFailure extends AppFailure {
  const CityNotFoundFailure([super.message = 'Không tìm thấy thành phố']);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Đã có lỗi xảy ra']);
}
