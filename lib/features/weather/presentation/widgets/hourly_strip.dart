import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/weather_visual.dart';
import '../../../../shared/widgets/weather_icon.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/hourly_forecast_entry.dart';

/// ListView ngang, item đầu (giờ hiện tại) highlight nhẹ — xem
/// `design_meteofocus/README.md §Dashboard`.
class HourlyStrip extends ConsumerStatefulWidget {
  const HourlyStrip({super.key, required this.entries});

  final List<HourlyForecastEntry> entries;

  @override
  ConsumerState<HourlyStrip> createState() => _HourlyStripState();
}

class _HourlyStripState extends ConsumerState<HourlyStrip> {
  // Scrollbar cần 1 controller gán rõ ràng — không truyền gì dễ bị Flutter
  // nhầm sang PrimaryScrollController (không gắn ScrollPosition nào ở đây)
  // và throw "ScrollController has no ScrollPosition attached".
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(settingsProvider).unit;
    final now = DateTime.now();
    final currentHour = DateTime(now.year, now.month, now.day, now.hour);
    final upcoming = widget.entries
        .where((e) => !e.time.isBefore(currentHour))
        .take(24)
        .toList();

    if (upcoming.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      // 92px không đủ chỗ cho 3 dòng (giờ/icon/nhiệt độ) + padding → tràn ~5px.
      height: 108,
      // Vuốt ngang trên mobile là thao tác tự nhiên (card cuối bị cắt 1 phần
      // đã đủ gợi ý "còn nữa"), nhưng chuột trên web không có cảm ứng — thêm
      // thanh cuộn mảnh để gợi ý cuộn ngang được, chỉ hiện khi tương tác.
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: upcoming.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final entry = upcoming[index];
            final isNow = index == 0;
            final visual = resolveWeatherVisual(
              entry.weatherCode,
              isDay: entry.isDay,
            );
            return Container(
              width: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isNow
                    ? AppColors.accent.withValues(alpha: 0.08)
                    : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.Hm().format(entry.time),
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: 6),
                  WeatherIcon(
                    asset: visual.iconAsset,
                    size: 30,
                    animate: false,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatTemperature(entry.temperature, unit),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
