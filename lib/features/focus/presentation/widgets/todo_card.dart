import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/todo_item.dart';
import '../providers/todo_provider.dart';

/// Checkbox tuỳ chỉnh, tap cả hàng để toggle — xem
/// `design_meteofocus/README.md §Tương tác`.
class TodoCard extends ConsumerStatefulWidget {
  const TodoCard({super.key});

  @override
  ConsumerState<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends ConsumerState<TodoCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    ref.read(todoProvider.notifier).add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = ref.watch(todoProvider);
    final doneCount = items.where((t) => t.done).length;

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
          Row(
            children: [
              Expanded(child: Text(l10n.todoTitle, style: AppTextStyles.h1)),
              Text(
                l10n.todoCounter(doneCount, items.length),
                style: AppTextStyles.label,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.todoEmpty,
                style: AppTextStyles.body.copyWith(color: AppColors.textFaint),
              ),
            )
          else
            for (final item in items) _TodoRow(item: item),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.todoInputPlaceholder,
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.divider,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.buttonRound),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _submit, child: Text(l10n.addLabel)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodoRow extends ConsumerWidget {
  const _TodoRow({required this.item});

  final TodoItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(todoProvider.notifier).toggle(item.id),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            _TodoCheckbox(checked: item.done),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.text,
                style: AppTextStyles.body.copyWith(
                  color: item.done ? AppColors.textFaintest : AppColors.textPrimary,
                  decoration: item.done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoCheckbox extends StatelessWidget {
  const _TodoCheckbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? AppColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? AppColors.accent : const Color(0xFFC8DBEA),
          width: 1.5,
        ),
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
          : null,
    );
  }
}
