// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'MeteoFocus';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navLocation => 'Địa Điểm';

  @override
  String get navSettings => 'Cài Đặt';

  @override
  String get greetingMorning => 'Chào buổi sáng';

  @override
  String get greetingAfternoon => 'Chào buổi chiều';

  @override
  String get greetingEvening => 'Chào buổi tối';

  @override
  String get forecastLabel => 'Dự Báo';

  @override
  String get weatherDetailTitle => 'Full Weather Detail';

  @override
  String get locationSearchTitle => 'Location Search';

  @override
  String get settingsTitle => 'Account / Settings';

  @override
  String get comingSoon => 'Sắp ra mắt';
}
