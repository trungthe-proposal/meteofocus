// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MeteoFocus';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navLocation => 'Location';

  @override
  String get navSettings => 'Settings';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get forecastLabel => 'Forecast';

  @override
  String get weatherDetailTitle => 'Full Weather Detail';

  @override
  String get locationSearchTitle => 'Location Search';

  @override
  String get settingsTitle => 'Account / Settings';

  @override
  String get comingSoon => 'Coming soon';
}
