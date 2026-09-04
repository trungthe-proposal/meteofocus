import 'package:flutter/material.dart';

import '../../core/constants/weather_visual.dart';

/// Bảng màu sky-gradient theo `SkyCondition` — xem `ARCHITECTURE.md §8` và
/// `design_meteofocus/README.md §Design Tokens`.
class SkyGradient extends ThemeExtension<SkyGradient> {
  const SkyGradient(this.gradients);

  final Map<SkyCondition, List<Color>> gradients;

  List<Color> colorsFor(SkyCondition condition) => gradients[condition]!;

  static const standard = SkyGradient({
    SkyCondition.clear: [
      Color(0xFF3FA9EE),
      Color(0xFF7FCBF6),
      Color(0xFFC7E8FB),
    ],
    SkyCondition.partlyCloudy: [
      Color(0xFF54B0E6),
      Color(0xFF8FCDEE),
      Color(0xFFCFE7F6),
    ],
    SkyCondition.rain: [
      Color(0xFF4A6F8C),
      Color(0xFF6E93AC),
      Color(0xFFA8C2D3),
    ],
    SkyCondition.shower: [
      Color(0xFF4F81A3),
      Color(0xFF7FA8C2),
      Color(0xFFB9D3E0),
    ],
    SkyCondition.thunderstorm: [
      Color(0xFF3A4A63),
      Color(0xFF5D6F8A),
      Color(0xFF93A5BB),
    ],
    SkyCondition.snow: [
      Color(0xFF7D9AB3),
      Color(0xFFADC4D6),
      Color(0xFFDCE9F2),
    ],
    SkyCondition.fog: [
      Color(0xFF8FA3AD),
      Color(0xFFB6C5CC),
      Color(0xFFDDE5E9),
    ],
    SkyCondition.haze: [
      Color(0xFF8A8377),
      Color(0xFFB6ADA0),
      Color(0xFFDED8CF),
    ],
    SkyCondition.nightClear: [
      Color(0xFF16264A),
      Color(0xFF2C4270),
      Color(0xFF5A7099),
    ],
    SkyCondition.overcastNight: [
      Color(0xFF1C2635),
      Color(0xFF38465C),
      Color(0xFF67788E),
    ],
  });

  @override
  SkyGradient copyWith({Map<SkyCondition, List<Color>>? gradients}) {
    return SkyGradient(gradients ?? this.gradients);
  }

  @override
  SkyGradient lerp(ThemeExtension<SkyGradient>? other, double t) {
    // Sky-gradient chỉ có 1 bộ màu cố định trong app (không đổi theme màu),
    // nên không cần nội suy thực sự — trả nguyên bản là đủ.
    if (other is! SkyGradient) return this;
    return t < 0.5 ? this : other;
  }
}
