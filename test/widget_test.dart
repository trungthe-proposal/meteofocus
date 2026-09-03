import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meteofocus/app/app.dart';

void main() {
  testWidgets('App boots to Dashboard with bottom nav', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MeteoFocusApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Địa Điểm'), findsOneWidget);
    expect(find.text('Cài Đặt'), findsOneWidget);
  });
}
