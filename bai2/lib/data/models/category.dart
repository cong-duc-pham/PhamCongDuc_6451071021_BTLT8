class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  factory Category.fromMap(Map<String, dynamic> map) =>
      Category(id: map['id'], name: map['name'] ?? '');

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  Category copyWith({int? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);
}