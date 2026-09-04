import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// Tên ứng dụng, hiển thị trên title bar/tab web
  ///
  /// In vi, this message translates to:
  /// **'MeteoFocus'**
  String get appTitle;

  /// Nhãn tab bottom nav - Dashboard
  ///
  /// In vi, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// Nhãn tab bottom nav - Location Search
  ///
  /// In vi, this message translates to:
  /// **'Địa Điểm'**
  String get navLocation;

  /// Nhãn tab bottom nav - Settings
  ///
  /// In vi, this message translates to:
  /// **'Cài Đặt'**
  String get navSettings;

  /// Lời chào header Dashboard buổi sáng (05:00-11:00)
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng'**
  String get greetingMorning;

  /// Lời chào header Dashboard buổi chiều (11:00-18:00)
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều'**
  String get greetingAfternoon;

  /// Lời chào header Dashboard buổi tối (18:00-05:00)
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối'**
  String get greetingEvening;

  /// Nhãn phụ cạnh lời chào trong header Dashboard
  ///
  /// In vi, this message translates to:
  /// **'Dự Báo'**
  String get forecastLabel;

  /// Tiêu đề màn hình Weather Detail
  ///
  /// In vi, this message translates to:
  /// **'Chi Tiết Thời Tiết'**
  String get weatherDetailTitle;

  /// Tiêu đề màn hình Location Search
  ///
  /// In vi, this message translates to:
  /// **'Tìm Địa Điểm'**
  String get locationSearchTitle;

  /// Tiêu đề màn hình Settings
  ///
  /// In vi, this message translates to:
  /// **'Tài Khoản / Cài Đặt'**
  String get settingsTitle;

  /// Placeholder tạm thời cho nội dung màn hình chưa dựng xong
  ///
  /// In vi, this message translates to:
  /// **'Sắp ra mắt'**
  String get comingSoon;

  /// Nhãn chỉ số độ ẩm trong Weather Hero Card
  ///
  /// In vi, this message translates to:
  /// **'Độ ẩm'**
  String get humidityLabel;

  /// Nhãn chỉ số áp suất trong Weather Hero Card
  ///
  /// In vi, this message translates to:
  /// **'Áp suất'**
  String get pressureLabel;

  /// Nhãn chỉ số UV trong Weather Hero Card
  ///
  /// In vi, this message translates to:
  /// **'Chỉ số UV'**
  String get uviLabel;

  /// Nhãn nhiệt độ cảm nhận ở Weather Detail
  ///
  /// In vi, this message translates to:
  /// **'Cảm giác như'**
  String get feelsLikeLabel;

  /// Nhãn tốc độ gió ở Weather Detail
  ///
  /// In vi, this message translates to:
  /// **'Gió'**
  String get windLabel;

  /// Badge hiện khi dùng cache hết hạn do mất mạng
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu cũ, đang chờ mạng'**
  String get staleDataBadge;

  /// Nút thử lại khi load lỗi
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// Thông báo lỗi khi gọi API thất bại do mạng
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng'**
  String get errorNetwork;

  /// Thông báo lỗi khi không lấy được GPS
  ///
  /// In vi, this message translates to:
  /// **'Quyền vị trí bị từ chối'**
  String get errorLocationPermission;

  /// Thông báo lỗi khi tìm thành phố không có kết quả
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành phố'**
  String get errorCityNotFound;

  /// Thông báo lỗi mặc định không xác định nguyên nhân
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get errorUnknown;

  /// Tiêu đề danh sách forecast 10 ngày ở Weather Detail
  ///
  /// In vi, this message translates to:
  /// **'Dự báo 10 ngày'**
  String get tenDayForecastTitle;

  /// Header cột ngày trong bảng forecast 10 ngày
  ///
  /// In vi, this message translates to:
  /// **'Ngày'**
  String get forecastColumnDate;

  /// Header cột nhiệt độ cao nhất trong bảng forecast 10 ngày
  ///
  /// In vi, this message translates to:
  /// **'Cao nhất'**
  String get forecastColumnMax;

  /// Header cột nhiệt độ thấp nhất trong bảng forecast 10 ngày
  ///
  /// In vi, this message translates to:
  /// **'Thấp nhất'**
  String get forecastColumnMin;

  /// Mô tả điều kiện thời tiết - wicon-ClearSun
  ///
  /// In vi, this message translates to:
  /// **'Trời nắng'**
  String get condClearSun;

  /// Mô tả điều kiện thời tiết - wicon-NightClearMoon
  ///
  /// In vi, this message translates to:
  /// **'Trời quang, đêm trong'**
  String get condNightClearMoon;

  /// Mô tả điều kiện thời tiết - wicon-PartlyCloudy
  ///
  /// In vi, this message translates to:
  /// **'Ít mây'**
  String get condPartlyCloudy;

  /// Mô tả điều kiện thời tiết - wicon-OvercastNight
  ///
  /// In vi, this message translates to:
  /// **'Nhiều mây'**
  String get condOvercastNight;

  /// Mô tả điều kiện thời tiết - wicon-WindyCloud
  ///
  /// In vi, this message translates to:
  /// **'Nhiều mây, có gió'**
  String get condWindyCloud;

  /// Mô tả điều kiện thời tiết - wicon-Fog
  ///
  /// In vi, this message translates to:
  /// **'Sương mù'**
  String get condFog;

  /// Mô tả điều kiện thời tiết - wicon-haze
  ///
  /// In vi, this message translates to:
  /// **'Sương mù dày'**
  String get condHaze;

  /// Mô tả điều kiện thời tiết - wicon-scatteredShower
  ///
  /// In vi, this message translates to:
  /// **'Mưa rào rải rác'**
  String get condScatteredShower;

  /// Mô tả điều kiện thời tiết - wicon-HeavyRain
  ///
  /// In vi, this message translates to:
  /// **'Mưa vừa đến to'**
  String get condHeavyRain;

  /// Mô tả điều kiện thời tiết - wicon-Snowing
  ///
  /// In vi, this message translates to:
  /// **'Có tuyết'**
  String get condSnowing;

  /// Mô tả điều kiện thời tiết - wicon-Thunderstorm
  ///
  /// In vi, this message translates to:
  /// **'Dông'**
  String get condThunderstorm;

  /// Mô tả điều kiện thời tiết - wicon-strongWindy
  ///
  /// In vi, this message translates to:
  /// **'Gió mạnh'**
  String get condStrongWindy;

  /// Nhãn dưới đồng hồ đếm ngược trong Focus Timer card
  ///
  /// In vi, this message translates to:
  /// **'Pomodoro'**
  String get pomodoroTitle;

  /// Badge trạng thái khi Pomodoro chưa bắt đầu (idle)
  ///
  /// In vi, this message translates to:
  /// **'Phiên {minutes} phút'**
  String pomodoroSessionLabel(int minutes);

  /// Badge trạng thái khi Pomodoro đang chạy
  ///
  /// In vi, this message translates to:
  /// **'Đang tập trung'**
  String get pomodoroRunningLabel;

  /// Badge trạng thái khi Pomodoro bị tạm dừng
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get pomodoroPausedLabel;

  /// Nút bắt đầu đếm ngược Pomodoro (trạng thái idle)
  ///
  /// In vi, this message translates to:
  /// **'Bắt Đầu'**
  String get startLabel;

  /// Nút tạm dừng khi Pomodoro đang chạy
  ///
  /// In vi, this message translates to:
  /// **'Tạm Dừng'**
  String get pauseLabel;

  /// Nút tiếp tục khi Pomodoro đang tạm dừng
  ///
  /// In vi, this message translates to:
  /// **'Tiếp Tục'**
  String get resumeLabel;

  /// Nút đặt lại Pomodoro về đầu phiên
  ///
  /// In vi, this message translates to:
  /// **'Đặt Lại'**
  String get resetLabel;

  /// Nhãn chip chọn thời lượng Pomodoro
  ///
  /// In vi, this message translates to:
  /// **'{minutes} phút'**
  String durationMinutesLabel(int minutes);

  /// Tiêu đề To-Do card
  ///
  /// In vi, this message translates to:
  /// **'Hôm Nay'**
  String get todoTitle;

  /// Counter số task đã hoàn thành trên tổng số
  ///
  /// In vi, this message translates to:
  /// **'{done}/{total} xong'**
  String todoCounter(int done, int total);

  /// Placeholder ô nhập task mới
  ///
  /// In vi, this message translates to:
  /// **'Thêm task mới…'**
  String get todoInputPlaceholder;

  /// Nút thêm task mới
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get addLabel;

  /// Trạng thái rỗng khi chưa có task nào
  ///
  /// In vi, this message translates to:
  /// **'Chưa có task nào — thêm việc đầu tiên nhé'**
  String get todoEmpty;

  /// Label danh sách thành phố mẫu trong Location Search
  ///
  /// In vi, this message translates to:
  /// **'Thành Phố Đã Lưu'**
  String get savedCityLabel;

  /// Label danh sách kết quả khi đang gõ tìm kiếm
  ///
  /// In vi, this message translates to:
  /// **'Kết Quả Tìm Kiếm'**
  String get searchResultsLabel;

  /// Placeholder ô tìm kiếm thành phố
  ///
  /// In vi, this message translates to:
  /// **'Tìm thành phố…'**
  String get searchPlaceholder;

  /// Số lượng kết quả cạnh label danh sách thành phố
  ///
  /// In vi, this message translates to:
  /// **'{count} kết quả'**
  String resultsCount(int count);

  /// Trạng thái rỗng khi tìm kiếm không ra kết quả
  ///
  /// In vi, this message translates to:
  /// **'Không tìm thấy thành phố nào'**
  String get noResultsFound;

  /// Dòng phụ dưới tên app trong profile card ở Settings
  ///
  /// In vi, this message translates to:
  /// **'Weather & Focus Dashboard'**
  String get profileSubtitle;

  /// Nút Edit trong profile card
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get editLabel;

  /// Thông báo khi bấm Edit (chưa làm, app không có hệ thống tài khoản thật)
  ///
  /// In vi, this message translates to:
  /// **'Tính năng chỉnh sửa hồ sơ chưa khả dụng'**
  String get editNotAvailableMessage;

  /// Tiêu đề section Preferences trong Settings
  ///
  /// In vi, this message translates to:
  /// **'Tuỳ Chọn'**
  String get preferencesSectionLabel;

  /// Nhãn hàng chọn đơn vị °C/°F
  ///
  /// In vi, this message translates to:
  /// **'Đơn Vị Nhiệt Độ'**
  String get unitsLabel;

  /// Nhãn switch bật/tắt thông báo
  ///
  /// In vi, this message translates to:
  /// **'Thông Báo'**
  String get notificationsLabel;

  /// Nhãn switch bật/tắt cảnh báo thời tiết nguy hiểm
  ///
  /// In vi, this message translates to:
  /// **'Cảnh Báo Thời Tiết Nguy Hiểm'**
  String get severeAlertsLabel;

  /// Tiêu đề section chọn theme sky-gradient
  ///
  /// In vi, this message translates to:
  /// **'Giao Diện'**
  String get themeSectionLabel;

  /// Chế độ theme Auto - theo thời tiết thực tế
  ///
  /// In vi, this message translates to:
  /// **'Tự Động'**
  String get themeAutoLabel;

  /// Chế độ theme ép ban ngày
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get themeDayLabel;

  /// Chế độ theme ép ban đêm
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get themeNightLabel;

  /// Tiêu đề section thông tin nguồn dữ liệu
  ///
  /// In vi, this message translates to:
  /// **'Nguồn Dữ Liệu'**
  String get dataSourceSectionLabel;

  /// Tên nhà cung cấp dữ liệu thời tiết
  ///
  /// In vi, this message translates to:
  /// **'Open-Meteo'**
  String get dataSourceProviderLabel;

  /// Attribution bắt buộc theo license CC BY 4.0 của Open-Meteo
  ///
  /// In vi, this message translates to:
  /// **'Weather data by Open-Meteo.com'**
  String get dataSourceAttribution;

  /// Nhãn thông tin cache trong Data source section
  ///
  /// In vi, this message translates to:
  /// **'Bộ Nhớ Đệm'**
  String get cacheInfoLabel;

  /// Giá trị mô tả cơ chế cache
  ///
  /// In vi, this message translates to:
  /// **'Hive · 15 phút'**
  String get cacheInfoValue;

  /// Nhãn số phiên bản build trong Data source section
  ///
  /// In vi, this message translates to:
  /// **'Phiên Bản'**
  String get buildVersionLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
