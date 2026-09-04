import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/weather_visual.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/weather_icon.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/weather_snapshot.dart';

/// Bấm vào mở Weather Detail — xem `design_meteofocus/README.md §Dashboard`.
class WeatherHeroCard extends ConsumerWidget {
  const WeatherHeroCard({super.key, required this.snapshot, this.onTap});

  final WeatherSnapshot snapshot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final current = snapshot.current;
    final visual = resolveWeatherVisual(
      current.weatherCode,
      isDay: resolveEffectiveIsDay(settings.skyThemeMode, current.isDay),
      windSpeedKmh: current.windSpeedKmh,
    );
    final description = weatherConditionDescription(l10n, visual.iconAsset);

    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(AppRadius.cardLarge),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.cardLarge),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WeatherIcon(asset: visual.iconAsset, size: 92),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatTemperature(current.temperature, settings.unit),
                          style: AppTextStyles.heroTemperature,
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          snapshot.city.name,
                          style: AppTextStyles.h1,
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          description,
                          style: AppTextStyles.body,
                          textAlign: TextAlign.right,
                        ),
                        if (snapshot.isStale) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.staleDataBadge,
                            style: AppTextStyles.label,
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatColumn(
                      label: l10n.humidityLabel,
                      value: '${current.humidity}%',
                    ),
                  ),
                  const _StatDivider(),
                  Expanded(
                    child: _StatColumn(
                      label: l10n.pressureLabel,
                      value: '${current.pressure.round()} hPa',
                    ),
                  ),
                  const _StatDivider(),
                  Expanded(
                    child: _StatColumn(
                      label: l10n.uviLabel,
                      value: current.uvIndex.toStringAsFixed(1),
                    ),
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

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.label),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppColors.dividerStrong);
  }
}
