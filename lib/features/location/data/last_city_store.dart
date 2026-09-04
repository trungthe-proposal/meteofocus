import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/prefs/shared_prefs_provider.dart';
import '../domain/entities/city.dart';

/// Nhớ thành phố người dùng chọn lần gần nhất (thủ công hoặc GPS lần đầu) qua
/// `SharedPreferences` — trả lời câu hỏi "chọn Hồ Chí Minh/Bangkok thì có
/// thành mặc định cho lần sau không": có.
class LastCityStore {
  LastCityStore(this._prefs);

  static const _key = 'last_city';

  final SharedPreferences _prefs;

  City? read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return City.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(City city) =>
      _prefs.setString(_key, jsonEncode(city.toJson()));
}

final lastCityStoreProvider = Provider<LastCityStore>((ref) {
  return LastCityStore(ref.watch(sharedPreferencesProvider));
});
