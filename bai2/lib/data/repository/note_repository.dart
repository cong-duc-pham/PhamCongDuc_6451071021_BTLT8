import '../models/note.dart';
import '../models/note_with_category.dart';
import '../services/app_database.dart';

class NoteRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<NoteWithCategory>> getAll({int? categoryId}) async {
    final db = await _db.database;
    final sql = '''
      SELECT n.id, n.title, n.content, n.categoryId,
             c.name AS categoryName
      FROM notes n
      INNER JOIN categories c ON n.categoryId = c.id
      ${categoryId != null ? 'WHERE n.categoryId = ?' : ''}
      ORDER BY n.id DESC
    ''';
    final maps = categoryId != null
        ? await db.rawQuery(sql, [categoryId])
        : await db.rawQuery(sql);
    return maps.map((m) => NoteWithCategory.fromMap(m)).toList();
  }

  Future<NoteWithCategory> insert(Note note) async {
    final db = await _db.database;
    final id = await db.insert('notes', {
      'title': note.title,
      'content': note.content,
      'categoryId': note.categoryId,
    });
    final result = await db.rawQuery('''
      SELECT n.id, n.title, n.content, n.categoryId, c.name AS categoryName
      FROM notes n INNER JOIN categories c ON n.categoryId = c.id
      WHERE n.id = ?
    ''', [id]);
    return NoteWithCategory.fromMap(result.first);
  }

  Future<int> update(Note note) async {
    final db = await _db.database;
    return await db.update(
      'notes',
      {'title': note.title, 'content': note.content, 'categoryId': note.categoryId},
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}