import '../models/category.dart';
import '../services/app_database.dart';

class CategoryRepository {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<Category>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('categories', orderBy: 'name ASC');
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<Category> insert(String name) async {
    final db = await _db.database;
    final id = await db.insert('categories', {'name': name});
    return Category(id: id, name: name);
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}