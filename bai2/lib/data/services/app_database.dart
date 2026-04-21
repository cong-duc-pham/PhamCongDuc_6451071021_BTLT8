import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_notes_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('PRAGMA foreign_keys = ON');

    await db.execute('''
      CREATE TABLE categories (
        id   INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        title      TEXT NOT NULL,
        content    TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id) ON DELETE CASCADE
      )
    ''');

    // Seed danh mục mẫu
    await db.insert('categories', {'name': 'Công việc'});
    await db.insert('categories', {'name': 'Cá nhân'});
    await db.insert('categories', {'name': 'Học tập'});
  }

  Future close() async {
    final db = await database;
    db.close();
    _database = null;
  }
}