import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/weather_visual.dart';
import '../../../../core/error/failure_localizer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_retry_view.dart';
import '../../../../shared/widgets/sky_background.dart';
import '../../../../shared/widgets/weather_icon.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/daily_forecast_entry.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../providers/weather_provider.dart';

class WeatherDetailScreen extends ConsumerWidget {
  const WeatherDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(weatherProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(
          l10n.weatherDetailTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: switch (weatherAsync) {
        AsyncData(:final value) => _DetailContent(snapshot: value),
        AsyncError(:final error) => SkyBackground(
          condition: SkyCondition.clear,
          child: Center(
            child: ErrorRetryView(
              message: localizeFailure(l10n, error),
              onRetry: () => ref.read(weatherProvider.notifier).refresh(),
            ),
          ),
        ),
        _ => const SkyBackground(
          condition: SkyCondition.clear,
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      },
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.snapshot});

  final WeatherSnapshot snapshot;

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

    return SkyBackground(
      condition: visual.skyCondition,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(AppRadius.cardLarge),
                  boxShadow: AppShadows.card,
                ),
                child: Column(
                  children: [
                    WeatherIcon(asset: visual.iconAsset, size: 104),
                    const SizedBox(height: 12),
                    Text(
                      formatTemperature(current.temperature, settings.unit),
                      style: AppTextStyles.heroTemperature.copyWith(fontSize: 52),
                    ),
                    Text(snapshot.city.name, style: AppTextStyles.h1),
                    Text(description, style: AppTextStyles.body),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.feelsLikeLabel} '
                      '${formatTemperature(current.apparentTemperature, settings.unit)} · '
                      '${l10n.windLabel} ${current.windSpeedKmh.round()} km/h',
                      style: AppTextStyles.label,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SmallStatCard(
                      label: l10n.humidityLabel,
                      value: '${current.humidity}%',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmallStatCard(
                      label: l10n.pressureLabel,
                      value: '${current.pressure.round()} hPa',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SmallStatCard(
                      label: l10n.uviLabel,
                      value: current.uvIndex.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.tenDayForecastTitle, style: AppTextStyles.h1),
              const SizedBox(height: 8),
              _ForecastHeaderRow(l10n: l10n),
              const SizedBox(height: 4),
              for (final entry in snapshot.daily)
                _ForecastRow(entry: entry, unit: settings.unit),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallStatCard extends StatelessWidget {
  const _SmallStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
      ),
      child: Column(
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
      ),
    );
  }
}

class _ForecastHeaderRow extends StatelessWidget {
  const _ForecastHeaderRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(l10n.forecastColumnDate, style: AppTextStyles.label)),
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 2,
            child: Text(
              l10n.forecastColumnMax,
              textAlign: TextAlign.right,
              style: AppTextStyles.label,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              l10n.forecastColumnMin,
              textAlign: TextAlign.right,
              style: AppTextStyles.label,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.entry, required this.unit});

  final DailyForecastEntry entry;
  final TempUnit unit;

  @override
  Widget build(BuildContext context) {
    // Daily summary luôn dùng icon ban ngày cho dễ nhận diện trong danh sách.
    final visual = resolveWeatherVisual(entry.weatherCode, isDay: true);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              DateFormat('EEE, d MMM', 'vi_VN').format(entry.date),
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: WeatherIcon(asset: visual.iconAsset, size: 32, animate: false),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatTemperature(entry.tempMax, unit),
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatTemperature(entry.tempMin, unit),
              textAlign: TextAlign.right,
              style: AppTextStyles.label,
            ),
          ),
        ],
      ),
    );
  }
}
