import 'package:flutter/material.dart';

import '../../app/theme/sky_gradient.dart';
import '../../core/constants/weather_visual.dart';

/// Nền gradient toàn màn hình đổi theo thời tiết, chuyển mượt ~0.6s —
/// xem `ARCHITECTURE.md §8`.
class SkyBackground extends StatelessWidget {
  const SkyBackground({super.key, required this.condition, required this.child});

  final SkyCondition condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context)
        .extension<SkyGradient>()!
        .colorsFor(condition);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
