import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Box Hive mở sẵn trong `main.dart` trước `runApp`, override giá trị thật vào
/// đây — cùng pattern với `weatherBoxProvider`.
final todoBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError(
    'todoBoxProvider phải được override bằng Box đã mở trong main.dart',
  );
});
