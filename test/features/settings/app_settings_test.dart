import 'package:flutter_test/flutter_test.dart';
import 'package:meteofocus/features/settings/domain/app_settings.dart';

void main() {
  group('formatTemperature', () {
    test('Celsius giữ nguyên, làm tròn', () {
      expect(formatTemperature(28.4, TempUnit.celsius), '28°');
      expect(formatTemperature(28.6, TempUnit.celsius), '29°');
    });

    test('Fahrenheit đổi đúng công thức t = c*9/5+32', () {
      expect(formatTemperature(0, TempUnit.fahrenheit), '32°');
      expect(formatTemperature(100, TempUnit.fahrenheit), '212°');
      expect(formatTemperature(28, TempUnit.fahrenheit), '82°'); // 28*9/5+32=82.4 -> 82
    });
  });

  group('resolveEffectiveIsDay', () {
    test('auto giữ nguyên is_day thật', () {
      expect(resolveEffectiveIsDay(SkyThemeMode.auto, true), true);
      expect(resolveEffectiveIsDay(SkyThemeMode.auto, false), false);
    });

    test('day luôn ép true, night luôn ép false', () {
      expect(resolveEffectiveIsDay(SkyThemeMode.day, false), true);
      expect(resolveEffectiveIsDay(SkyThemeMode.night, true), false);
    });
  });
}
