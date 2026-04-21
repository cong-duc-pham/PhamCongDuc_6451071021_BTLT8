import '../models/task.dart';
import '../services/task_database.dart';

class TaskRepository {
  final TaskDatabase _db = TaskDatabase.instance;

  Future<List<Task>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('tasks', orderBy: 'id DESC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<Task> insert(String title) async {
    final db = await _db.database;
    final id = await db.insert('tasks', {'title': title, 'isDone': 0});
    return Task(id: id, title: title);
  }

  Future<int> updateDone(int id, bool isDone) async {
    final db = await _db.database;
    return await db.update(
      'tasks',
      {'isDone': isDone ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  /// Xóa tất cả rồi insert lại (dùng khi import)
  Future<void> replaceAll(List<Task> tasks) async {
    final db = await _db.database;
    await db.transaction((txn) async {
      await txn.delete('tasks');
      for (final t in tasks) {
        await txn.insert('tasks', {'title': t.title, 'isDone': t.isDone ? 1 : 0});
      }
    });
  }
}