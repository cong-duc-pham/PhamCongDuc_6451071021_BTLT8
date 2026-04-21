import '../data/models/category.dart';
import '../data/repository/category_repository.dart';

class CategoryController {
  final CategoryRepository _repo = CategoryRepository();

  Future<List<Category>> getAll() => _repo.getAll();
  Future<Category> add(String name) => _repo.insert(name);
  Future<int> delete(int id) => _repo.delete(id);
}