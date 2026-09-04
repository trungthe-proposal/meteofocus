import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Box Hive mở sẵn trong `main.dart` trước `runApp`, override giá trị thật vào
/// đây — pattern chuẩn Riverpod cho dependency cần khởi tạo async lúc bootstrap.
final weatherBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError(
    'weatherBoxProvider phải được override bằng Box đã mở trong main.dart',
  );
});
