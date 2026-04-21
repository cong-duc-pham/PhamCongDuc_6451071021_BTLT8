class Note {
  final int? id;
  final String title;
  final String content;

  Note({this.id, required this.title, required this.content});

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'] ?? '',
    content: map['content'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
  };

  Note copyWith({int? id, String? title, String? content}) => Note(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
  );
}