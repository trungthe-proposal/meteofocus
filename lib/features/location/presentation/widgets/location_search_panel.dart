import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/weather_visual.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/weather_icon.dart';
import '../../../settings/domain/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../weather/domain/entities/weather_snapshot.dart';
import '../../../weather/presentation/providers/weather_provider.dart';
import '../../domain/entities/city.dart';
import '../providers/city_search_provider.dart';
import 'country_avatar.dart';

/// Nội dung tìm/chọn thành phố — tách khỏi `LocationSearchScreen` để dùng lại
/// được ở cột trái của layout Expanded (`ARCHITECTURE.md §6`), không chỉ ở
/// tab Địa Điểm.
class LocationSearchPanel extends ConsumerStatefulWidget {
  const LocationSearchPanel({
    super.key,
    this.showTitle = true,
    this.onCitySelected,
  });

  /// Tắt tiêu đề khi nhúng làm 1 cột trong layout Expanded (đã có ngữ cảnh
  /// rõ ràng từ vị trí, không cần lặp lại tiêu đề).
  final bool showTitle;

  /// Gọi sau khi chọn xong thành phố — dùng để `context.go('/')` khi đây là
  /// tab riêng (Compact/Medium); để `null` khi nhúng cạnh Weather column ở
  /// Expanded, vì chọn xong vẫn ở nguyên màn hình, chỉ cột Weather cập nhật.
  final VoidCallback? onCitySelected;

  @override
  ConsumerState<LocationSearchPanel> createState() =>
      _LocationSearchPanelState();
}

class _LocationSearchPanelState extends ConsumerState<LocationSearchPanel> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectCity(City city) async {
    await ref.read(weatherProvider.notifier).selectCity(city);
    widget.onCitySelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final query = ref.watch(citySearchQueryProvider);
    final isSearching = query.trim().length >= 2;
    final selectedCityId = ref.watch(weatherProvider).valueOrNull?.city.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle) ...[
          Text(l10n.locationSearchTitle, style: AppTextStyles.h1),
          const SizedBox(height: 16),
        ],
        _SearchField(
          controller: _controller,
          hintText: l10n.searchPlaceholder,
          onChanged: (value) =>
              ref.read(citySearchQueryProvider.notifier).state = value,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: isSearching
              ? _SearchResultsList(
                  selectedCityId: selectedCityId,
                  onSelect: _selectCity,
                )
              : _SavedCitiesList(
                  selectedCityId: selectedCityId,
                  onSelect: _selectCity,
                ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textFaint),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textFaint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _SavedCitiesList extends ConsumerWidget {
  const _SavedCitiesList({required this.selectedCityId, required this.onSelect});

  final String? selectedCityId;
  final ValueChanged<City> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final citiesAsync = ref.watch(savedCitiesWeatherProvider);

    return citiesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(
        child: Text(l10n.errorUnknown, style: AppTextStyles.body),
      ),
      data: (entries) {
        return ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.savedCityLabel, style: AppTextStyles.label),
                ),
                Text(l10n.resultsCount(entries.length), style: AppTextStyles.label),
              ],
            ),
            const SizedBox(height: 8),
            for (final (city, snapshot) in entries)
              _CityRow(
                city: city,
                snapshot: snapshot,
                isSelected: city.id == selectedCityId,
                onTap: () => onSelect(city),
              ),
          ],
        );
      },
    );
  }
}

class _SearchResultsList extends ConsumerWidget {
  const _SearchResultsList({required this.selectedCityId, required this.onSelect});

  final String? selectedCityId;
  final ValueChanged<City> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final resultsAsync = ref.watch(citySearchResultsProvider);

    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(
        child: Text(l10n.errorUnknown, style: AppTextStyles.body),
      ),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text(
              l10n.noResultsFound,
              style: AppTextStyles.body.copyWith(color: AppColors.textFaint),
            ),
          );
        }
        return ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l10n.searchResultsLabel, style: AppTextStyles.label),
                ),
                Text(l10n.resultsCount(results.length), style: AppTextStyles.label),
              ],
            ),
            const SizedBox(height: 8),
            for (final city in results)
              _CityRow(
                city: city,
                snapshot: null,
                isSelected: city.id == selectedCityId,
                onTap: () => onSelect(city),
              ),
          ],
        );
      },
    );
  }
}

class _CityRow extends ConsumerWidget {
  const _CityRow({
    required this.city,
    required this.snapshot,
    required this.isSelected,
    required this.onTap,
  });

  final City city;
  final WeatherSnapshot? snapshot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unit = ref.watch(settingsProvider).unit;
    final current = snapshot?.current;
    final visual = current != null
        ? resolveWeatherVisual(
            current.weatherCode,
            isDay: current.isDay,
            windSpeedKmh: current.windSpeedKmh,
          )
        : null;
    final subtitle = current != null && visual != null
        ? '${formatTemperature(current.temperature, unit)} · '
              '${weatherConditionDescription(l10n, visual.iconAsset)}'
        : city.countryCode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppColors.accent : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                CountryAvatar(countryCode: city.countryCode),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(subtitle, style: AppTextStyles.label),
                    ],
                  ),
                ),
                if (visual != null)
                  WeatherIcon(asset: visual.iconAsset, size: 32, animate: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
