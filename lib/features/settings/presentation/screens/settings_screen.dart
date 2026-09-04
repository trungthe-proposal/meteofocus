import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/app_settings.dart';
import '../providers/settings_provider.dart';

/// App version hiển thị tĩnh, khớp `pubspec.yaml` — không thêm package
/// `package_info_plus` chỉ để đọc lại đúng con số đã có sẵn trong pubspec.
const _appVersion = '1.0.0';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.settingsTitle, style: AppTextStyles.h1),
          const SizedBox(height: 20),
          _ProfileCard(l10n: l10n),
          const SizedBox(height: 24),
          _SectionLabel(l10n.preferencesSectionLabel),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _UnitRow(
                label: l10n.unitsLabel,
                unit: settings.unit,
                onChanged: notifier.setUnit,
              ),
              const _RowDivider(),
              _SwitchRow(
                label: l10n.notificationsLabel,
                value: settings.notificationsEnabled,
                onChanged: notifier.setNotificationsEnabled,
              ),
              const _RowDivider(),
              _SwitchRow(
                label: l10n.severeAlertsLabel,
                value: settings.severeAlertsEnabled,
                onChanged: notifier.setSevereAlertsEnabled,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.themeSectionLabel),
          const SizedBox(height: 8),
          _ThemeModeSelector(
            mode: settings.skyThemeMode,
            onChanged: notifier.setSkyThemeMode,
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.dataSourceSectionLabel),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _InfoRow(
                label: l10n.dataSourceProviderLabel,
                value: l10n.dataSourceAttribution,
              ),
              const _RowDivider(),
              _InfoRow(label: l10n.cacheInfoLabel, value: l10n.cacheInfoValue),
              const _RowDivider(),
              _InfoRow(label: l10n.buildVersionLabel, value: _appVersion),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.accentPressed],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'MF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appTitle, style: AppTextStyles.h1),
                Text(
                  l10n.profileSubtitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.editNotAvailableMessage)),
              );
            },
            child: Text(l10n.editLabel),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.label);
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        boxShadow: AppShadows.card,
      ),
      child: Column(children: children),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColors.divider);
  }
}

class _UnitRow extends StatelessWidget {
  const _UnitRow({
    required this.label,
    required this.unit,
    required this.onChanged,
  });

  final String label;
  final TempUnit unit;
  final ValueChanged<TempUnit> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
          _SegmentPill(
            leftLabel: '°C',
            rightLabel: '°F',
            isRightSelected: unit == TempUnit.fahrenheit,
            onSelectLeft: () => onChanged(TempUnit.celsius),
            onSelectRight: () => onChanged(TempUnit.fahrenheit),
          ),
        ],
      ),
    );
  }
}

class _SegmentPill extends StatelessWidget {
  const _SegmentPill({
    required this.leftLabel,
    required this.rightLabel,
    required this.isRightSelected,
    required this.onSelectLeft,
    required this.onSelectRight,
  });

  final String leftLabel;
  final String rightLabel;
  final bool isRightSelected;
  final VoidCallback onSelectLeft;
  final VoidCallback onSelectRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppRadius.togglePill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SegmentButton(
            label: leftLabel,
            selected: !isRightSelected,
            onTap: onSelectLeft,
          ),
          _SegmentButton(
            label: rightLabel,
            selected: isRightSelected,
            onTap: onSelectRight,
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.accent : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.togglePill - 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.togglePill - 3),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.toggleOff,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.label)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector({required this.mode, required this.onChanged});

  final SkyThemeMode mode;
  final ValueChanged<SkyThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = {
      SkyThemeMode.auto: l10n.themeAutoLabel,
      SkyThemeMode.day: l10n.themeDayLabel,
      SkyThemeMode.night: l10n.themeNightLabel,
    };
    return Row(
      children: [
        for (final entry in options.entries)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _ThemeModeButton(
                label: entry.value,
                selected: mode == entry.key,
                onTap: () => onChanged(entry.key),
              ),
            ),
          ),
      ],
    );
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.accent.withValues(alpha: 0.12)
          : AppColors.cardBackground,
      borderRadius: BorderRadius.circular(AppRadius.buttonRound),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.buttonRound),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.buttonRound),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.dividerStrong,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.accent : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
