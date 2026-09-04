import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/weather/presentation/widgets/mini_weather_widget.dart';
import '../../l10n/app_localizations.dart';
import '../constants/breakpoints.dart';

/// Bottom nav Dashboard/Địa Điểm/Cài Đặt — xem `ARCHITECTURE.md §5`. Dưới
/// `AppBreakpoints.coverScreenMax` chuyển hẳn sang `MiniWeatherWidget` (Cover
/// Screen) thay vì 3 tab, vì không đủ chỗ hiển thị bottom nav.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.coverScreenMax) {
          return const MiniWeatherWidget();
        }
        return _NormalShell(navigationShell: navigationShell);
      },
    );
  }
}

class _NormalShell extends StatelessWidget {
  const _NormalShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_on_outlined),
            selectedIcon: const Icon(Icons.location_on),
            label: l10n.navLocation,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
