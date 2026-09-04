enum PomodoroStatus { idle, running, paused }

/// Mặc định 25 phút (chuẩn kỹ thuật Pomodoro gốc) nhưng chỉnh được — bổ sung
/// ngoài design gốc theo yêu cầu, xem `ARCHITECTURE.md §12 Buổi 3 (bổ sung)`.
class PomodoroState {
  const PomodoroState({
    required this.secondsLeft,
    required this.status,
    required this.totalSeconds,
  });

  static const defaultDurationMinutes = 25;
  static const availableDurationsMinutes = [15, 25, 45];

  static PomodoroState initial({
    int totalSeconds = defaultDurationMinutes * 60,
  }) => PomodoroState(
    secondsLeft: totalSeconds,
    status: PomodoroStatus.idle,
    totalSeconds: totalSeconds,
  );

  final int secondsLeft;
  final PomodoroStatus status;
  final int totalSeconds;

  int get durationMinutes => totalSeconds ~/ 60;

  double get progress => totalSeconds == 0 ? 0 : 1 - secondsLeft / totalSeconds;

  String get display {
    final m = (secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  PomodoroState copyWith({int? secondsLeft, PomodoroStatus? status}) {
    return PomodoroState(
      secondsLeft: secondsLeft ?? this.secondsLeft,
      status: status ?? this.status,
      totalSeconds: totalSeconds,
    );
  }
}
