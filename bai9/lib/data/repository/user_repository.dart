import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';

class UserRepository {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'auth.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE users(
            id       INTEGER PRIMARY KEY AUTOINCREMENT,
            email    TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
        // Seed 2 tài khoản mẫu để test
        await db.insert('users', {'email': 'admin@test.com',  'password': '123456'});
        await db.insert('users', {'email': 'duc@test.com',    'password': 'abc123'});
      },
    );
  }

  Future<User?> findByEmailAndPassword(String email, String password) async {
    final db = await database;
    final rows = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }
}