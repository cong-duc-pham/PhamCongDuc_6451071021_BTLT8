class Task {
  final int? id;
  final String title;
  final bool isDone;

  Task({this.id, required this.title, this.isDone = false});

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'] ?? '',
    isDone: (map['isDone'] as int) == 1,
  );

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'] ?? '',
    isDone: json['isDone'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'isDone': isDone ? 1 : 0,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isDone': isDone,
  };

  Task copyWith({int? id, String? title, bool? isDone}) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    isDone: isDone ?? this.isDone,
  );
}