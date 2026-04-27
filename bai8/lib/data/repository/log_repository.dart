import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/log_entry.dart';

class LogRepository {
  static Database? _db;

  // ─── SQLite ───────────────────────────────────────────
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'activity.db'),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE logs(
            id    INTEGER PRIMARY KEY AUTOINCREMENT,
            action TEXT NOT NULL,
            time   TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertLog(LogEntry entry) async {
    final db = await database;
    await db.insert('logs', entry.toMap());
  }

  Future<List<LogEntry>> getLogs() async {
    final db = await database;
    final rows = await db.query('logs', orderBy: 'id DESC');
    return rows.map(LogEntry.fromMap).toList();
  }

  Future<void> clearLogs() async {
    final db = await database;
    await db.delete('logs');
  }

  // ─── File log ─────────────────────────────────────────
  Future<File> get _logFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File(join(dir.path, 'activity_log.txt'));
  }

  Future<void> writeToFile(String line) async {
    final file = await _logFile;
    await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
  }

  Future<String> readFile() async {
    final file = await _logFile;
    if (!await file.exists()) return '(Chưa có log)';
    return await file.readAsString();
  }

  Future<void> clearFile() async {
    final file = await _logFile;
    if (await file.exists()) await file.writeAsString('');
  }
}