/// Xem `design_meteofocus/README.md §Location Search` cho danh sách thành phố mẫu.
class City {
  const City({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String countryCode;
  final double latitude;
  final double longitude;

  /// Thành phố mặc định khi chưa có GPS/thành phố đã lưu — xem `ARCHITECTURE.md §11`.
  static const defaultCity = City(
    id: 'default-hanoi',
    name: 'Hà Nội',
    countryCode: 'VN',
    latitude: 21.0285,
    longitude: 105.8542,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'countryCode': countryCode,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json['id'] as String,
    name: json['name'] as String,
    countryCode: json['countryCode'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}
