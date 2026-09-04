import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// `SharedPreferences.getInstance()` mở sẵn trong `main.dart` trước `runApp`,
/// override giá trị thật vào đây — cùng pattern với `weatherBoxProvider`.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider phải được override bằng SharedPreferences đã init trong main.dart',
  );
});
