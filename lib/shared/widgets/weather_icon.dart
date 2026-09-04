import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Icon thời tiết PNG (`assets/icons/`) với animation "bob" nhẹ lên-xuống —
/// xem `design_meteofocus/README.md §Tương tác`. `animate: false` tắt bob cho
/// chỗ dùng nhỏ (hourly strip) tránh quá nhiều animation cùng lúc trên 1 màn.
class WeatherIcon extends StatelessWidget {
  const WeatherIcon({
    super.key,
    required this.asset,
    required this.size,
    this.animate = true,
  });

  final String asset;
  final double size;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/icons/$asset.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
    if (!animate) return image;
    return image
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: 0,
          end: -6,
          duration: 2500.ms,
          curve: Curves.easeInOut,
        );
  }
}
