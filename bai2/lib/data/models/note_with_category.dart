class NoteWithCategory {
  final int? id;
  final String title;
  final String content;
  final int categoryId;
  final String categoryName;

  NoteWithCategory({
    this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.categoryName,
  });

  factory NoteWithCategory.fromMap(Map<String, dynamic> map) =>
      NoteWithCategory(
        id: map['id'],
        title: map['title'] ?? '',
        content: map['content'] ?? '',
        categoryId: map['categoryId'],
        categoryName: map['categoryName'] ?? '',
      );
}