import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/pomodoro_state.dart';
import '../providers/pomodoro_provider.dart';

/// Vòng tròn tiến trình bán kính ~64, stroke 12 — xem
/// `design_meteofocus/README.md §Dashboard`.
class FocusTimerCard extends ConsumerWidget {
  const FocusTimerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(pomodoroProvider);
    final notifier = ref.read(pomodoroProvider.notifier);

    final badgeText = switch (state.status) {
      PomodoroStatus.idle => l10n.pomodoroSessionLabel(state.durationMinutes),
      PomodoroStatus.running => l10n.pomodoroRunningLabel,
      PomodoroStatus.paused => l10n.pomodoroPausedLabel,
    };
    final primaryLabel = switch (state.status) {
      PomodoroStatus.idle => l10n.startLabel,
      PomodoroStatus.running => l10n.pauseLabel,
      PomodoroStatus.paused => l10n.resumeLabel,
    };
    final onPrimaryPressed = state.status == PomodoroStatus.running
        ? notifier.pause
        : notifier.start;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: AppTextStyles.label.copyWith(color: AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 128,
              height: 128,
              child: CustomPaint(
                painter: _RingPainter(progress: state.progress),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.display, style: AppTextStyles.pomodoroDigits),
                      Text(l10n.pomodoroTitle, style: AppTextStyles.label),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Chỉ cho đổi thời lượng khi chưa bắt đầu — đang đếm dở thì ẩn đi để
          // tránh đổi số giữa chừng gây khó hiểu (§setDuration chỉ nhận lúc idle).
          if (state.status == PomodoroStatus.idle) ...[
            const SizedBox(height: 12),
            // Wrap thay vì Row cố định: card có thể hẹp hơn tổng bề rộng 3
            // chip tuỳ layout (Medium/Expanded cột hẹp) — Row sẽ tràn ngang,
            // Wrap tự xuống dòng khi không đủ chỗ.
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final minutes in PomodoroState.availableDurationsMinutes)
                  _DurationChip(
                    minutes: minutes,
                    selected: state.durationMinutes == minutes,
                    onTap: () => notifier.setDuration(minutes),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onPrimaryPressed,
                  child: Text(primaryLabel),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: notifier.reset,
                  child: Text(l10n.resetLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.minutes,
    required this.selected,
    required this.onTap,
  });

  final int minutes;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: selected ? AppColors.accent : AppColors.divider,
      borderRadius: BorderRadius.circular(AppRadius.togglePill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.togglePill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            l10n.durationMinutesLabel(minutes),
            style: AppTextStyles.label.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - 12) / 2;

    final track = Paint()
      ..color = const Color(0xFFE7F1FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;
    final arc = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0, 1),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
