import '../data/models/note.dart';
import '../data/models/note_with_category.dart';
import '../data/repository/note_repository.dart';

class NoteController {
  final NoteRepository _repo = NoteRepository();

  Future<List<NoteWithCategory>> getAll({int? categoryId}) =>
      _repo.getAll(categoryId: categoryId);

  Future<NoteWithCategory> add({
    required String title,
    required String content,
    required int categoryId,
  }) =>
      _repo.insert(Note(title: title, content: content, categoryId: categoryId));

  Future<int> update({
    required int id,
    required String title,
    required String content,
    required int categoryId,
  }) =>
      _repo.update(Note(id: id, title: title, content: content, categoryId: categoryId));

  Future<int> delete(int id) => _repo.delete(id);
}