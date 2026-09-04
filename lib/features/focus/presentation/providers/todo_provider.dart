import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/cache/todo_box_provider.dart';
import '../../domain/todo_item.dart';

/// `NotifierProvider` + persist Hive — xem `ARCHITECTURE.md §12 Buổi 3`.
class TodoController extends Notifier<List<TodoItem>> {
  static const _storeKey = 'items';

  @override
  List<TodoItem> build() {
    final raw = ref.watch(todoBoxProvider).get(_storeKey);
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map(TodoItem.fromJson)
        .toList(growable: false);
  }

  void _persist() {
    ref.read(todoBoxProvider).put(_storeKey, state.map((t) => t.toJson()).toList());
  }

  void add(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    state = [
      ...state,
      TodoItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: trimmed,
        done: false,
      ),
    ];
    _persist();
  }

  void toggle(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(done: !t.done) else t,
    ];
    _persist();
  }

  void remove(String id) {
    state = state.where((t) => t.id != id).toList();
    _persist();
  }
}

final todoProvider = NotifierProvider<TodoController, List<TodoItem>>(
  TodoController.new,
);
