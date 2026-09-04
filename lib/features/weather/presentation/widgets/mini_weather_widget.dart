import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/weather_visual.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/sky_background.dart';
import '../../../../shared/widgets/weather_icon.dart';
import '../../../focus/domain/pomodoro_state.dart';
import '../../../focus/presentation/providers/pomodoro_provider.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/weather_provider.dart';

/// Cover Screen (Z Flip đóng) — nhiệt độ + icon + tên thành phố góc trên,
/// dot pulse + mm:ss + nút Start/Pause của Pomodoro — xem
/// `design_meteofocus/README.md §Cover Screen`. Route riêng hiển thị tự động
/// khi màn hình cực nhỏ, xem `AppShell`.
class MiniWeatherWidget extends ConsumerWidget {
  const MiniWeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(weatherProvider);
    final pomodoro = ref.watch(pomodoroProvider);
    final settings = ref.watch(settingsProvider);
    final pomodoroNotifier = ref.read(pomodoroProvider.notifier);

    final current = weatherAsync.valueOrNull?.current;
    final visual = current != null
        ? resolveWeatherVisual(
            current.weatherCode,
            isDay: resolveEffectiveIsDay(settings.skyThemeMode, current.isDay),
            windSpeedKmh: current.windSpeedKmh,
          )
        : null;

    return SkyBackground(
      condition: visual?.skyCondition ?? SkyCondition.clear,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (current != null && visual != null)
                Row(
                  children: [
                    WeatherIcon(asset: visual.iconAsset, size: 28, animate: false),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatTemperature(current.temperature, settings.unit),
                            style: AppTextStyles.h1.copyWith(fontSize: 18),
                          ),
                          Text(
                            weatherAsync.value!.city.name,
                            style: AppTextStyles.label,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              const Spacer(),
              Row(
                children: [
                  _PulseDot(active: pomodoro.status == PomodoroStatus.running),
                  const SizedBox(width: 6),
                  Text(pomodoro.display, style: AppTextStyles.body),
                  const Spacer(),
                  _MiniIconButton(
                    icon: pomodoro.status == PomodoroStatus.running
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    tooltip: pomodoro.status == PomodoroStatus.running
                        ? l10n.pauseLabel
                        : l10n.startLabel,
                    onTap: pomodoro.status == PomodoroStatus.running
                        ? pomodoroNotifier.pause
                        : pomodoroNotifier.start,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent,
      ),
    );
    if (!active) return dot;
    return dot
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: 1, end: 0.25, duration: 700.ms);
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
