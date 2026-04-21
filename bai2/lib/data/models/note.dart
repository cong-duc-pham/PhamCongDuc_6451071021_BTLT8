class Note {
  final int? id;
  final String title;
  final String content;
  final int categoryId;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.categoryId,
  });

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'] ?? '',
    content: map['content'] ?? '',
    categoryId: map['categoryId'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'categoryId': categoryId,
  };

  Note copyWith({int? id, String? title, String? content, int? categoryId}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        categoryId: categoryId ?? this.categoryId,
      );
}