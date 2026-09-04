import '../../l10n/app_localizations.dart';

/// Bucket sky-gradient — khớp bảng màu trong `design_meteofocus/README.md §Design Tokens`.
enum SkyCondition {
  clear,
  partlyCloudy,
  rain,
  shower,
  thunderstorm,
  snow,
  fog,
  haze,
  nightClear,
  overcastNight,
}

class WeatherVisual {
  const WeatherVisual({required this.iconAsset, required this.skyCondition});

  /// Tên file không đuôi, vd `wicon-ClearSun` → `assets/icons/wicon-ClearSun.png`.
  final String iconAsset;
  final SkyCondition skyCondition;
}

/// Map `weathercode` (WMO, Open-Meteo) + `is_day` sang icon/sky-gradient —
/// xem `ARCHITECTURE.md §8`. Ngưỡng gió `windSpeedKmh >= 39` (~Beaufort 6) cho
/// `wicon-strongWindy` là đề xuất thiết kế, cần đối chiếu thẩm mỹ khi ghép UI thật.
WeatherVisual resolveWeatherVisual(
  int weatherCode, {
  required bool isDay,
  double? windSpeedKmh,
}) {
  if (windSpeedKmh != null && windSpeedKmh >= 39 && weatherCode <= 3) {
    return WeatherVisual(
      iconAsset: 'wicon-strongWindy',
      skyCondition: isDay ? SkyCondition.clear : SkyCondition.nightClear,
    );
  }

  switch (weatherCode) {
    case 0:
    case 1:
      return WeatherVisual(
        iconAsset: isDay ? 'wicon-ClearSun' : 'wicon-NightClearMoon',
        skyCondition: isDay ? SkyCondition.clear : SkyCondition.nightClear,
      );
    case 2:
      return WeatherVisual(
        iconAsset: isDay ? 'wicon-PartlyCloudy' : 'wicon-OvercastNight',
        skyCondition: isDay
            ? SkyCondition.partlyCloudy
            : SkyCondition.overcastNight,
      );
    case 3:
      return WeatherVisual(
        iconAsset: isDay ? 'wicon-WindyCloud' : 'wicon-OvercastNight',
        skyCondition: isDay
            ? SkyCondition.partlyCloudy
            : SkyCondition.overcastNight,
      );
    case 45:
      return const WeatherVisual(
        iconAsset: 'wicon-Fog',
        skyCondition: SkyCondition.fog,
      );
    case 48:
      return const WeatherVisual(
        iconAsset: 'wicon-haze',
        skyCondition: SkyCondition.haze,
      );
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
    case 61:
    case 80:
      return const WeatherVisual(
        iconAsset: 'wicon-scatteredShower',
        skyCondition: SkyCondition.shower,
      );
    case 63:
    case 65:
    case 66:
    case 67:
    case 81:
    case 82:
      return const WeatherVisual(
        iconAsset: 'wicon-HeavyRain',
        skyCondition: SkyCondition.rain,
      );
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return const WeatherVisual(
        iconAsset: 'wicon-Snowing',
        skyCondition: SkyCondition.snow,
      );
    case 95:
    case 96:
    case 99:
      return const WeatherVisual(
        iconAsset: 'wicon-Thunderstorm',
        skyCondition: SkyCondition.thunderstorm,
      );
    default:
      return WeatherVisual(
        iconAsset: isDay ? 'wicon-PartlyCloudy' : 'wicon-OvercastNight',
        skyCondition: isDay
            ? SkyCondition.partlyCloudy
            : SkyCondition.overcastNight,
      );
  }
}

/// Mô tả điều kiện thời tiết theo icon, qua `AppLocalizations` — xem `ARCHITECTURE.md §9`:
/// đây vẫn là chuỗi UI (đổi theo ngôn ngữ được), chỉ khác nguồn chọn key là suy ra
/// từ `weathercode` thay vì cố định, nên đi qua ARB như mọi string khác thay vì
/// hardcode 1 ngôn ngữ trong data layer.
String weatherConditionDescription(AppLocalizations l10n, String iconAsset) {
  return switch (iconAsset) {
    'wicon-ClearSun' => l10n.condClearSun,
    'wicon-NightClearMoon' => l10n.condNightClearMoon,
    'wicon-PartlyCloudy' => l10n.condPartlyCloudy,
    'wicon-OvercastNight' => l10n.condOvercastNight,
    'wicon-WindyCloud' => l10n.condWindyCloud,
    'wicon-Fog' => l10n.condFog,
    'wicon-haze' => l10n.condHaze,
    'wicon-scatteredShower' => l10n.condScatteredShower,
    'wicon-HeavyRain' => l10n.condHeavyRain,
    'wicon-Snowing' => l10n.condSnowing,
    'wicon-Thunderstorm' => l10n.condThunderstorm,
    'wicon-strongWindy' => l10n.condStrongWindy,
    _ => '',
  };
}
