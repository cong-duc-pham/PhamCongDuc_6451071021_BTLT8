import '../models/note.dart';
import '../services/note_database.dart';

class NoteRepository {
  final NoteDatabase _db = NoteDatabase.instance;

  Future<List<Note>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('notes', orderBy: 'id DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<Note> insert(Note note) async {
    final db = await _db.database;
    final id = await db.insert(
      'notes',
      {'title': note.title, 'content': note.content},
    );
    return note.copyWith(id: id);
  }

  Future<int> update(Note note) async {
    final db = await _db.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _db.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}