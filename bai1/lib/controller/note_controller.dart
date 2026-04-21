import '../data/models/note.dart';
import '../data/repository/note_repository.dart';

class NoteController {
  final NoteRepository _repo = NoteRepository();

  Future<List<Note>> getAllNotes() => _repo.getAll();

  Future<Note> addNote(String title, String content) =>
      _repo.insert(Note(title: title, content: content));

  Future<int> updateNote(Note note) => _repo.update(note);

  Future<int> deleteNote(int id) => _repo.delete(id);
}