import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meteofocus/app/app.dart';
import 'package:meteofocus/core/cache/todo_box_provider.dart';
import 'package:meteofocus/core/prefs/shared_prefs_provider.dart';
import 'package:meteofocus/features/location/data/geolocator_service.dart';
import 'package:meteofocus/features/location/domain/entities/city.dart';
import 'package:meteofocus/features/weather/data/weather_repository_impl.dart';
import 'package:meteofocus/features/weather/domain/entities/current_weather.dart';
import 'package:meteofocus/features/weather/domain/entities/weather_snapshot.dart';
import 'package:meteofocus/features/weather/domain/weather_repository.dart';

/// Repository giả trả dữ liệu ngay lập tức — tránh test phụ thuộc mạng thật
/// (Dio gọi Open-Meteo).
class _FakeWeatherRepository implements WeatherRepository {
  @override
  Future<WeatherSnapshot> getWeather(City city) async {
    return WeatherSnapshot(
      city: city,
      current: CurrentWeather(
        time: DateTime(2026, 9, 3, 9),
        temperature: 28,
        apparentTemperature: 31,
        humidity: 64,
        pressure: 1008,
        uvIndex: 4.5,
        weatherCode: 0,
        isDay: true,
        windSpeedKmh: 6.5,
      ),
      hourly: const [],
      daily: const [],
      fetchedAt: DateTime(2026, 9, 3, 9),
    );
  }
}

/// `Geolocator` gọi qua platform channel thật không reject trong môi trường
/// test (Future treo vô thời hạn thay vì throw MissingPluginException như kỳ
/// vọng) — phải fake hẳn service này, không chỉ fake repository.
class _FakeGeolocatorService extends GeolocatorService {
  const _FakeGeolocatorService();

  @override
  Future<City> getCurrentCity() async => City.defaultCity;
}

void main() {
  late Directory tempDir;
  late Box todoBox;
  late SharedPreferences prefs;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('meteofocus_test_hive');
    Hive.init(tempDir.path);
    todoBox = await Hive.openBox('test_todo_items');
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  testWidgets('App boots to Dashboard with bottom nav', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(_FakeWeatherRepository()),
          geolocatorServiceProvider.overrideWithValue(const _FakeGeolocatorService()),
          todoBoxProvider.overrideWithValue(todoBox),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MeteoFocusApp(),
      ),
    );
    // Không dùng pumpAndSettle(): Weather Hero Card có animation "bob" lặp vô
    // hạn (flutter_animate .repeat(reverse: true)) nên không bao giờ "settle".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Địa Điểm'), findsOneWidget);
    expect(find.text('Cài Đặt'), findsOneWidget);
    expect(find.text('Hà Nội'), findsOneWidget);
    expect(find.text('Pomodoro'), findsOneWidget);
    expect(find.text('Hôm Nay'), findsOneWidget);
  });
}
