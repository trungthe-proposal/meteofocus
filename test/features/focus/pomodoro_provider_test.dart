import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meteofocus/core/prefs/shared_prefs_provider.dart';
import 'package:meteofocus/features/focus/domain/pomodoro_state.dart';
import 'package:meteofocus/features/focus/presentation/providers/pomodoro_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
  });

  test('mặc định idle, 25 phút (1500 giây)', () {
    final state = container.read(pomodoroProvider);
    expect(state.status, PomodoroStatus.idle);
    expect(state.secondsLeft, 1500);
    expect(state.display, '25:00');
  });

  test('start() chuyển sang running ngay lập tức', () {
    container.read(pomodoroProvider.notifier).start();
    expect(container.read(pomodoroProvider).status, PomodoroStatus.running);
  });

  test('pause() chỉ có tác dụng khi đang running', () {
    final notifier = container.read(pomodoroProvider.notifier);
    notifier.pause(); // idle -> pause: không đổi gì
    expect(container.read(pomodoroProvider).status, PomodoroStatus.idle);

    notifier.start();
    notifier.pause();
    expect(container.read(pomodoroProvider).status, PomodoroStatus.paused);
  });

  test('reset() đưa về idle và giữ nguyên thời lượng đã chọn', () {
    final notifier = container.read(pomodoroProvider.notifier);
    notifier.setDuration(45);
    notifier.start();
    notifier.reset();
    final state = container.read(pomodoroProvider);
    expect(state.status, PomodoroStatus.idle);
    expect(state.secondsLeft, 45 * 60);
  });

  test('setDuration() bị bỏ qua khi không phải idle', () {
    final notifier = container.read(pomodoroProvider.notifier);
    notifier.start();
    notifier.setDuration(45);
    expect(container.read(pomodoroProvider).durationMinutes, 25);
  });

  test('setDuration() áp dụng khi idle', () {
    final notifier = container.read(pomodoroProvider.notifier);
    notifier.setDuration(15);
    final state = container.read(pomodoroProvider);
    expect(state.durationMinutes, 15);
    expect(state.secondsLeft, 15 * 60);
  });
}
