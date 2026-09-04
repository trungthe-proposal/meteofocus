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
  String get weatherDetailTitle => 'Chi Tiết Thời Tiết';

  @override
  String get locationSearchTitle => 'Tìm Địa Điểm';

  @override
  String get settingsTitle => 'Tài Khoản / Cài Đặt';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get humidityLabel => 'Độ ẩm';

  @override
  String get pressureLabel => 'Áp suất';

  @override
  String get uviLabel => 'Chỉ số UV';

  @override
  String get feelsLikeLabel => 'Cảm giác như';

  @override
  String get windLabel => 'Gió';

  @override
  String get staleDataBadge => 'Dữ liệu cũ, đang chờ mạng';

  @override
  String get retry => 'Thử lại';

  @override
  String get errorNetwork => 'Không có kết nối mạng';

  @override
  String get errorLocationPermission => 'Quyền vị trí bị từ chối';

  @override
  String get errorCityNotFound => 'Không tìm thấy thành phố';

  @override
  String get errorUnknown => 'Đã có lỗi xảy ra';

  @override
  String get tenDayForecastTitle => 'Dự báo 10 ngày';

  @override
  String get forecastColumnDate => 'Ngày';

  @override
  String get forecastColumnMax => 'Cao nhất';

  @override
  String get forecastColumnMin => 'Thấp nhất';

  @override
  String get condClearSun => 'Trời nắng';

  @override
  String get condNightClearMoon => 'Trời quang, đêm trong';

  @override
  String get condPartlyCloudy => 'Ít mây';

  @override
  String get condOvercastNight => 'Nhiều mây';

  @override
  String get condWindyCloud => 'Nhiều mây, có gió';

  @override
  String get condFog => 'Sương mù';

  @override
  String get condHaze => 'Sương mù dày';

  @override
  String get condScatteredShower => 'Mưa rào rải rác';

  @override
  String get condHeavyRain => 'Mưa vừa đến to';

  @override
  String get condSnowing => 'Có tuyết';

  @override
  String get condThunderstorm => 'Dông';

  @override
  String get condStrongWindy => 'Gió mạnh';

  @override
  String get pomodoroTitle => 'Pomodoro';

  @override
  String pomodoroSessionLabel(int minutes) {
    return 'Phiên $minutes phút';
  }

  @override
  String get pomodoroRunningLabel => 'Đang tập trung';

  @override
  String get pomodoroPausedLabel => 'Tạm dừng';

  @override
  String get startLabel => 'Bắt Đầu';

  @override
  String get pauseLabel => 'Tạm Dừng';

  @override
  String get resumeLabel => 'Tiếp Tục';

  @override
  String get resetLabel => 'Đặt Lại';

  @override
  String durationMinutesLabel(int minutes) {
    return '$minutes phút';
  }

  @override
  String get todoTitle => 'Hôm Nay';

  @override
  String todoCounter(int done, int total) {
    return '$done/$total xong';
  }

  @override
  String get todoInputPlaceholder => 'Thêm task mới…';

  @override
  String get addLabel => 'Thêm';

  @override
  String get todoEmpty => 'Chưa có task nào — thêm việc đầu tiên nhé';

  @override
  String get savedCityLabel => 'Thành Phố Đã Lưu';

  @override
  String get searchResultsLabel => 'Kết Quả Tìm Kiếm';

  @override
  String get searchPlaceholder => 'Tìm thành phố…';

  @override
  String resultsCount(int count) {
    return '$count kết quả';
  }

  @override
  String get noResultsFound => 'Không tìm thấy thành phố nào';

  @override
  String get profileSubtitle => 'Weather & Focus Dashboard';

  @override
  String get editLabel => 'Sửa';

  @override
  String get editNotAvailableMessage =>
      'Tính năng chỉnh sửa hồ sơ chưa khả dụng';

  @override
  String get preferencesSectionLabel => 'Tuỳ Chọn';

  @override
  String get unitsLabel => 'Đơn Vị Nhiệt Độ';

  @override
  String get notificationsLabel => 'Thông Báo';

  @override
  String get severeAlertsLabel => 'Cảnh Báo Thời Tiết Nguy Hiểm';

  @override
  String get themeSectionLabel => 'Giao Diện';

  @override
  String get themeAutoLabel => 'Tự Động';

  @override
  String get themeDayLabel => 'Sáng';

  @override
  String get themeNightLabel => 'Tối';

  @override
  String get dataSourceSectionLabel => 'Nguồn Dữ Liệu';

  @override
  String get dataSourceProviderLabel => 'Open-Meteo';

  @override
  String get dataSourceAttribution => 'Weather data by Open-Meteo.com';

  @override
  String get cacheInfoLabel => 'Bộ Nhớ Đệm';

  @override
  String get cacheInfoValue => 'Hive · 15 phút';

  @override
  String get buildVersionLabel => 'Phiên Bản';
}
