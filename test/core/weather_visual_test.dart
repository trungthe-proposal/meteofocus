import 'package:flutter_test/flutter_test.dart';
import 'package:meteofocus/core/constants/weather_visual.dart';

void main() {
  group('resolveWeatherVisual', () {
    test('clear sky day/night dùng icon khác nhau', () {
      final day = resolveWeatherVisual(0, isDay: true);
      final night = resolveWeatherVisual(0, isDay: false);
      expect(day.iconAsset, 'wicon-ClearSun');
      expect(day.skyCondition, SkyCondition.clear);
      expect(night.iconAsset, 'wicon-NightClearMoon');
      expect(night.skyCondition, SkyCondition.nightClear);
    });

    test('thunderstorm (95/96/99) luôn ra icon Thunderstorm', () {
      for (final code in [95, 96, 99]) {
        final visual = resolveWeatherVisual(code, isDay: true);
        expect(visual.iconAsset, 'wicon-Thunderstorm');
        expect(visual.skyCondition, SkyCondition.thunderstorm);
      }
    });

    test('mưa nhẹ (61) khác mưa to (65) — bucket icon khác nhau', () {
      final light = resolveWeatherVisual(61, isDay: true);
      final heavy = resolveWeatherVisual(65, isDay: true);
      expect(light.iconAsset, 'wicon-scatteredShower');
      expect(heavy.iconAsset, 'wicon-HeavyRain');
    });

    test('gió mạnh (>=39 km/h) ghi đè icon clear/cloudy thành strongWindy', () {
      final visual = resolveWeatherVisual(1, isDay: true, windSpeedKmh: 45);
      expect(visual.iconAsset, 'wicon-strongWindy');
    });

    test('gió mạnh không ghi đè khi đang mưa/tuyết/dông (weatherCode > 3)', () {
      final visual = resolveWeatherVisual(65, isDay: true, windSpeedKmh: 45);
      expect(visual.iconAsset, 'wicon-HeavyRain');
    });

    test('weatherCode lạ (không có trong bảng WMO) fallback về partly cloudy', () {
      final visual = resolveWeatherVisual(12345, isDay: true);
      expect(visual.iconAsset, 'wicon-PartlyCloudy');
    });
  });
}
