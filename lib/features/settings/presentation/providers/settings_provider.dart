import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/prefs/shared_prefs_provider.dart';
import '../../domain/app_settings.dart';

class SettingsController extends Notifier<AppSettings> {
  static const _unitKey = 'settings_unit';
  static const _notifKey = 'settings_notifications_enabled';
  static const _alertsKey = 'settings_severe_alerts_enabled';
  static const _skyModeKey = 'settings_sky_theme_mode';

  @override
  AppSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return AppSettings(
      unit: prefs.getString(_unitKey) == 'f'
          ? TempUnit.fahrenheit
          : TempUnit.celsius,
      notificationsEnabled: prefs.getBool(_notifKey) ?? true,
      severeAlertsEnabled: prefs.getBool(_alertsKey) ?? true,
      skyThemeMode: SkyThemeMode.values.firstWhere(
        (m) => m.name == prefs.getString(_skyModeKey),
        orElse: () => SkyThemeMode.auto,
      ),
    );
  }

  void setUnit(TempUnit unit) {
    state = state.copyWith(unit: unit);
    ref
        .read(sharedPreferencesProvider)
        .setString(_unitKey, unit == TempUnit.fahrenheit ? 'f' : 'c');
  }

  void setNotificationsEnabled(bool value) {
    state = state.copyWith(notificationsEnabled: value);
    ref.read(sharedPreferencesProvider).setBool(_notifKey, value);
  }

  void setSevereAlertsEnabled(bool value) {
    state = state.copyWith(severeAlertsEnabled: value);
    ref.read(sharedPreferencesProvider).setBool(_alertsKey, value);
  }

  void setSkyThemeMode(SkyThemeMode mode) {
    state = state.copyWith(skyThemeMode: mode);
    ref.read(sharedPreferencesProvider).setString(_skyModeKey, mode.name);
  }
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
