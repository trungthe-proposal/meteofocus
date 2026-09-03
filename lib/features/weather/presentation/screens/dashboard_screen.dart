import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 11) return l10n.greetingMorning;
    if (hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_greeting(l10n), style: AppTextStyles.h1),
            const SizedBox(height: 2),
            Text(
              l10n.forecastLabel,
              style: AppTextStyles.body.copyWith(color: AppColors.textFaint),
            ),
            const Spacer(),
            Center(
              child: FilledButton(
                onPressed: () => context.push('/detail'),
                child: Text(l10n.weatherDetailTitle),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
