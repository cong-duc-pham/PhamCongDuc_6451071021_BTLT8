import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_manager.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        note TEXT NOT NULL,
        categoryId INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories(id)
      )
    ''');

    // Seed default categories
    final defaultCategories = ['Ăn uống', 'Di chuyển', 'Giải trí', 'Mua sắm', 'Y tế', 'Khác'];
    for (final name in defaultCategories) {
      await db.insert('categories', {'name': name});
    }
  }

  // --- Category CRUD ---

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final maps = await db.query('categories');
    return maps.map((m) => Category.fromMap(m)).toList();
  }

  Future<int> insertCategory(Category category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  // --- Expense CRUD ---

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final maps = await db.query('expenses', orderBy: 'id DESC');
    return maps.map((m) => Expense.fromMap(m)).toList();
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTotalByCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.name AS categoryName, SUM(e.amount) AS total
      FROM expenses e
      JOIN categories c ON e.categoryId = c.id
      GROUP BY e.categoryId
      ORDER BY total DESC
    ''');
  }
}
