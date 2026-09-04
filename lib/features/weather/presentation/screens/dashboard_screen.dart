import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/breakpoints.dart';
import '../../../../app/constants/hinge.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/weather_visual.dart';
import '../../../../core/error/failure_localizer.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/error_retry_view.dart';
import '../../../../shared/widgets/sky_background.dart';
import '../../../focus/presentation/widgets/focus_timer_card.dart';
import '../../../focus/presentation/widgets/todo_card.dart';
import '../../../location/presentation/widgets/location_search_panel.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../providers/weather_provider.dart';
import '../widgets/hourly_strip.dart';
import '../widgets/weather_hero_card.dart';

/// Compact 1 cột / Medium 2 cột (né hinge) / Expanded 3 cột — xem
/// `ARCHITECTURE.md §6` và `§12 Buổi 4`.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 11) return l10n.greetingMorning;
    if (hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final weatherAsync = ref.watch(weatherProvider);
    final skyThemeMode = ref.watch(settingsProvider).skyThemeMode;

    final skyCondition = weatherAsync.valueOrNull != null
        ? resolveWeatherVisual(
            weatherAsync.value!.current.weatherCode,
            isDay: resolveEffectiveIsDay(
              skyThemeMode,
              weatherAsync.value!.current.isDay,
            ),
            windSpeedKmh: weatherAsync.value!.current.windSpeedKmh,
          ).skyCondition
        : SkyCondition.clear;

    return SkyBackground(
      condition: skyCondition,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting(l10n), style: AppTextStyles.h1),
                        Text(
                          l10n.forecastLabel,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textFaint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _HeaderIconButton(
                    icon: Icons.search_rounded,
                    onTap: () => context.go('/search'),
                  ),
                  const SizedBox(width: 8),
                  _HeaderIconButton(
                    icon: Icons.settings_rounded,
                    onTap: () => context.go('/settings'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return switch (layoutSizeOf(constraints.maxWidth)) {
                      LayoutSize.compact => _CompactBody(
                        weatherAsync: weatherAsync,
                      ),
                      LayoutSize.medium => _MediumBody(
                        weatherAsync: weatherAsync,
                        hinge: hingeBoundsOf(context),
                        totalWidth: constraints.maxWidth,
                      ),
                      LayoutSize.expanded => _ExpandedBody(
                        weatherAsync: weatherAsync,
                      ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.24),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

/// Nội dung Weather (Hero card/error/loading + Hourly strip) — không tự cuộn,
/// để 3 layout bên dưới tự quyết định cách bọc `SingleChildScrollView`.
class _WeatherSection extends StatelessWidget {
  const _WeatherSection({required this.weatherAsync});

  final AsyncValue<WeatherSnapshot> weatherAsync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            switch (weatherAsync) {
              AsyncData(:final value) => WeatherHeroCard(
                snapshot: value,
                onTap: () => GoRouter.of(context).push('/detail'),
              ),
              AsyncError(:final error) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: ErrorRetryView(
                  message: localizeFailure(l10n, error),
                  onRetry: () => ref.read(weatherProvider.notifier).refresh(),
                ),
              ),
              _ => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
            if (weatherAsync.valueOrNull case final snapshot?) ...[
              const SizedBox(height: 16),
              HourlyStrip(entries: snapshot.hourly),
            ],
          ],
        );
      },
    );
  }
}

class _FocusSection extends StatelessWidget {
  const _FocusSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [FocusTimerCard(), SizedBox(height: 16), TodoCard()],
    );
  }
}

/// `<600dp`: 1 cột cuộn dọc, Weather rồi tới Focus/To-Do.
class _CompactBody extends StatelessWidget {
  const _CompactBody({required this.weatherAsync});

  final AsyncValue<WeatherSnapshot> weatherAsync;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WeatherSection(weatherAsync: weatherAsync),
          const SizedBox(height: 16),
          const _FocusSection(),
        ],
      ),
    );
  }
}

/// `600–840dp` (Z Fold mở, tablet portrait): 2 cột, né vùng hinge nếu có.
class _MediumBody extends StatelessWidget {
  const _MediumBody({
    required this.weatherAsync,
    required this.hinge,
    required this.totalWidth,
  });

  final AsyncValue<WeatherSnapshot> weatherAsync;
  final Rect? hinge;
  final double totalWidth;

  static const _fallbackGap = 20.0;

  @override
  Widget build(BuildContext context) {
    final double leftWidth;
    final double gap;
    if (hinge != null && hinge!.left > 0 && hinge!.right < totalWidth) {
      leftWidth = hinge!.left;
      gap = hinge!.width.clamp(_fallbackGap, totalWidth * 0.2);
    } else {
      gap = _fallbackGap;
      leftWidth = (totalWidth - gap) / 2;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: leftWidth,
          child: SingleChildScrollView(
            child: _WeatherSection(weatherAsync: weatherAsync),
          ),
        ),
        SizedBox(width: gap),
        const Expanded(
          child: SingleChildScrollView(child: _FocusSection()),
        ),
      ],
    );
  }
}

/// `>840dp` (tablet landscape/desktop/web): 3 cột — Location Search (trái, cố
/// định ~288px) | Weather (giữa) | Focus + To-Do (phải, ~300px).
class _ExpandedBody extends StatelessWidget {
  const _ExpandedBody({required this.weatherAsync});

  final AsyncValue<WeatherSnapshot> weatherAsync;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 288,
          height: double.infinity,
          child: LocationSearchPanel(showTitle: true),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SingleChildScrollView(
            child: _WeatherSection(weatherAsync: weatherAsync),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 300,
          child: SingleChildScrollView(child: const _FocusSection()),
        ),
      ],
    );
  }
}
