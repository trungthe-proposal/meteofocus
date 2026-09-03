import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class MeteoFocusApp extends StatelessWidget {
  const MeteoFocusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // v1 chỉ ship tiếng Việt — khoá cứng thay vì để hệ thống tự chọn locale.
      // TODO(Buổi 4): đổi sang đọc từ settingsProvider.languageCode khi có UI chọn ngôn ngữ (ARCHITECTURE.md §9).
      locale: const Locale('vi'),
      debugShowCheckedModeBanner: false,
    );
  }
}
