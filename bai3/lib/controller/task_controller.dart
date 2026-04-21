import '../data/models/task.dart';
import '../data/repository/task_repository.dart';
import '../data/services/file_service.dart';

class TaskController {
  final TaskRepository _repo = TaskRepository();
  final FileService _fileService = FileService();

  Future<List<Task>> getAll() => _repo.getAll();

  Future<Task> addTask(String title) => _repo.insert(title);

  Future<int> toggleDone(int id, bool isDone) => _repo.updateDone(id, isDone);

  Future<int> deleteTask(int id) => _repo.delete(id);

  /// Export: lấy tất cả task → lưu ra JSON → trả về đường dẫn
  Future<String> exportToJson() async {
    final tasks = await _repo.getAll();
    if (tasks.isEmpty) throw Exception('Không có task nào để xuất');
    return await _fileService.exportTasks(tasks);
  }

  /// Import: đọc file JSON → ghi đè vào DB → trả về số lượng task
  Future<int> importFromJson(String filePath) async {
    final tasks = await _fileService.importTasks(filePath);
    await _repo.replaceAll(tasks);
    return tasks.length;
  }

  Future<String> get backupPath => _fileService.backupPath;

  Future<bool> backupExists() => _fileService.backupExists();
}