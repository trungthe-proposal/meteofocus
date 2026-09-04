enum TempUnit { celsius, fahrenheit }

/// Đặt tên khác `ThemeMode` của Flutter (light/dark/system) để tránh trùng —
/// đây là chế độ sky-gradient theo thời tiết, không phải light/dark mode UI.
enum SkyThemeMode { auto, day, night }

class AppSettings {
  const AppSettings({
    required this.unit,
    required this.notificationsEnabled,
    required this.severeAlertsEnabled,
    required this.skyThemeMode,
  });

  static const initial = AppSettings(
    unit: TempUnit.celsius,
    notificationsEnabled: true,
    severeAlertsEnabled: true,
    skyThemeMode: SkyThemeMode.auto,
  );

  final TempUnit unit;
  final bool notificationsEnabled;
  final bool severeAlertsEnabled;
  final SkyThemeMode skyThemeMode;

  AppSettings copyWith({
    TempUnit? unit,
    bool? notificationsEnabled,
    bool? severeAlertsEnabled,
    SkyThemeMode? skyThemeMode,
  }) {
    return AppSettings(
      unit: unit ?? this.unit,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      severeAlertsEnabled: severeAlertsEnabled ?? this.severeAlertsEnabled,
      skyThemeMode: skyThemeMode ?? this.skyThemeMode,
    );
  }
}

/// `t = c*9/5+32` — xem `design_meteofocus/README.md §Tương tác`.
double celsiusToFahrenheit(double celsius) => celsius * 9 / 5 + 32;

/// Auto: theo `is_day` thật của API. Sáng/Tối: ép hiển thị bất kể thực tế —
/// chỉ áp dụng cho thời tiết hiện tại (Hero Card/Sky Background), không ép
/// từng mốc giờ/ngày trong hourly/daily forecast (những mục đó có ý nghĩa
/// thời gian thực, ép sai lệch sẽ gây hiểu nhầm).
bool resolveEffectiveIsDay(SkyThemeMode mode, bool actualIsDay) {
  return switch (mode) {
    SkyThemeMode.auto => actualIsDay,
    SkyThemeMode.day => true,
    SkyThemeMode.night => false,
  };
}

String formatTemperature(double celsius, TempUnit unit) {
  final value = unit == TempUnit.fahrenheit
      ? celsiusToFahrenheit(celsius)
      : celsius;
  return '${value.round()}°';
}
