import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id     INTEGER PRIMARY KEY AUTOINCREMENT,
        title  TEXT NOT NULL,
        isDone INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}