class TodoItem {
  const TodoItem({required this.id, required this.text, required this.done});

  final String id;
  final String text;
  final bool done;

  TodoItem copyWith({bool? done}) =>
      TodoItem(id: id, text: text, done: done ?? this.done);

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'done': done};

  factory TodoItem.fromJson(Map<dynamic, dynamic> json) => TodoItem(
    id: json['id'] as String,
    text: json['text'] as String,
    done: json['done'] as bool,
  );
}
