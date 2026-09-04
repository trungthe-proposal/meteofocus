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

  @override
  String get humidityLabel => 'Humidity';

  @override
  String get pressureLabel => 'Pressure';

  @override
  String get uviLabel => 'UV Index';

  @override
  String get feelsLikeLabel => 'Feels like';

  @override
  String get windLabel => 'Wind';

  @override
  String get staleDataBadge => 'Stale data, waiting for network';

  @override
  String get retry => 'Retry';

  @override
  String get errorNetwork => 'No network connection';

  @override
  String get errorLocationPermission => 'Location permission denied';

  @override
  String get errorCityNotFound => 'City not found';

  @override
  String get errorUnknown => 'Something went wrong';

  @override
  String get tenDayForecastTitle => '10 Days forecast';

  @override
  String get forecastColumnDate => 'Date';

  @override
  String get forecastColumnMax => 'Max';

  @override
  String get forecastColumnMin => 'Min';

  @override
  String get condClearSun => 'Sunny';

  @override
  String get condNightClearMoon => 'Clear night';

  @override
  String get condPartlyCloudy => 'Partly cloudy';

  @override
  String get condOvercastNight => 'Cloudy';

  @override
  String get condWindyCloud => 'Cloudy, windy';

  @override
  String get condFog => 'Foggy';

  @override
  String get condHaze => 'Dense fog';

  @override
  String get condScatteredShower => 'Scattered showers';

  @override
  String get condHeavyRain => 'Moderate to heavy rain';

  @override
  String get condSnowing => 'Snowing';

  @override
  String get condThunderstorm => 'Thunderstorm';

  @override
  String get condStrongWindy => 'Strong wind';

  @override
  String get pomodoroTitle => 'Pomodoro';

  @override
  String pomodoroSessionLabel(int minutes) {
    return '$minutes min session';
  }

  @override
  String get pomodoroRunningLabel => 'Focusing';

  @override
  String get pomodoroPausedLabel => 'Paused';

  @override
  String get startLabel => 'Start';

  @override
  String get pauseLabel => 'Pause';

  @override
  String get resumeLabel => 'Resume';

  @override
  String get resetLabel => 'Reset';

  @override
  String durationMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get todoTitle => 'Today';

  @override
  String todoCounter(int done, int total) {
    return '$done/$total done';
  }

  @override
  String get todoInputPlaceholder => 'Add a new task…';

  @override
  String get addLabel => 'Add';

  @override
  String get todoEmpty => 'No tasks yet — add your first one';

  @override
  String get savedCityLabel => 'Saved City';

  @override
  String get searchResultsLabel => 'Search Results';

  @override
  String get searchPlaceholder => 'Search city…';

  @override
  String resultsCount(int count) {
    return '$count results';
  }

  @override
  String get noResultsFound => 'No city found';

  @override
  String get profileSubtitle => 'Weather & Focus Dashboard';

  @override
  String get editLabel => 'Edit';

  @override
  String get editNotAvailableMessage => 'Profile editing isn\'t available yet';

  @override
  String get preferencesSectionLabel => 'Preferences';

  @override
  String get unitsLabel => 'Temperature Unit';

  @override
  String get notificationsLabel => 'Notifications';

  @override
  String get severeAlertsLabel => 'Severe Weather Alerts';

  @override
  String get themeSectionLabel => 'Theme';

  @override
  String get themeAutoLabel => 'Auto';

  @override
  String get themeDayLabel => 'Day';

  @override
  String get themeNightLabel => 'Night';

  @override
  String get dataSourceSectionLabel => 'Data Source';

  @override
  String get dataSourceProviderLabel => 'Open-Meteo';

  @override
  String get dataSourceAttribution => 'Weather data by Open-Meteo.com';

  @override
  String get cacheInfoLabel => 'Cache';

  @override
  String get cacheInfoValue => 'Hive · 15 min';

  @override
  String get buildVersionLabel => 'Build Version';
}
