import 'package:go_router/go_router.dart';

import '../../features/location/presentation/screens/location_search_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/weather/presentation/screens/dashboard_screen.dart';
import '../../features/weather/presentation/screens/weather_detail_screen.dart';
import 'app_shell.dart';

/// Route map — xem `ARCHITECTURE.md §5`.
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  builder: (context, state) => const WeatherDetailScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const LocationSearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
