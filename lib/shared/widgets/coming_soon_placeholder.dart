import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

/// Placeholder tạm thời cho các màn hình chưa dựng UI thật (Buổi 2-4).
class ComingSoonPlaceholder extends StatelessWidget {
  const ComingSoonPlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTextStyles.h1),
          const SizedBox(height: 8),
          Text(
            l10n.comingSoon,
            style: AppTextStyles.body.copyWith(color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }
}
