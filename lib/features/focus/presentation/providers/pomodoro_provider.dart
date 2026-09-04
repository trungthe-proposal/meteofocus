import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/prefs/shared_prefs_provider.dart';
import '../../domain/pomodoro_state.dart';

/// `Timer.periodic` 1s — xem `ARCHITECTURE.md §12 Buổi 3`. Thời lượng phiên
/// chỉnh được (bổ sung ngoài design gốc), nhớ lại qua `SharedPreferences`.
class PomodoroController extends Notifier<PomodoroState> {
  Timer? _timer;

  static const _durationPrefsKey = 'pomodoro_duration_minutes';

  @override
  PomodoroState build() {
    ref.onDispose(() => _timer?.cancel());
    final savedMinutes =
        ref.read(sharedPreferencesProvider).getInt(_durationPrefsKey) ??
        PomodoroState.defaultDurationMinutes;
    return PomodoroState.initial(totalSeconds: savedMinutes * 60);
  }

  void start() {
    if (state.status == PomodoroStatus.running) return;
    if (state.secondsLeft <= 0) {
      state = PomodoroState.initial(totalSeconds: state.totalSeconds);
    }
    state = state.copyWith(status: PomodoroStatus.running);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsLeft <= 1) {
        _timer?.cancel();
        state = state.copyWith(secondsLeft: 0, status: PomodoroStatus.idle);
        return;
      }
      state = state.copyWith(secondsLeft: state.secondsLeft - 1);
    });
  }

  void pause() {
    _timer?.cancel();
    if (state.status != PomodoroStatus.running) return;
    state = state.copyWith(status: PomodoroStatus.paused);
  }

  void reset() {
    _timer?.cancel();
    state = PomodoroState.initial(totalSeconds: state.totalSeconds);
  }

  /// Chỉ đổi được khi chưa chạy (idle) — đổi thời lượng giữa lúc đang đếm dở
  /// dễ gây khó hiểu (secondsLeft cũ không còn khớp % tiến trình mới).
  void setDuration(int minutes) {
    if (state.status != PomodoroStatus.idle) return;
    _timer?.cancel();
    state = PomodoroState.initial(totalSeconds: minutes * 60);
    ref.read(sharedPreferencesProvider).setInt(_durationPrefsKey, minutes);
  }
}

final pomodoroProvider = NotifierProvider<PomodoroController, PomodoroState>(
  PomodoroController.new,
);
