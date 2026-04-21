import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class FileService {
  /// Trả về đường dẫn thư mục lưu file
  Future<String> get _dirPath async {
    final dir = await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    return dir.path;
  }

  /// Xuất danh sách task ra file JSON
  /// Trả về đường dẫn file đã lưu
  Future<String> exportTasks(List<Task> tasks) async {
    final dirPath = await _dirPath;
    final file = File('$dirPath/tasks_backup.json');
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList), flush: true);
    return file.path;
  }

  /// Đọc file JSON và trả về danh sách Task
  Future<List<Task>> importTasks(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File không tồn tại: $filePath');
    }
    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);
    return jsonList.map((j) => Task.fromJson(j)).toList();
  }

  /// Kiểm tra file backup có tồn tại không
  Future<bool> backupExists() async {
    final dirPath = await _dirPath;
    return File('$dirPath/tasks_backup.json').exists();
  }

  /// Trả về đường dẫn file backup mặc định
  Future<String> get backupPath async {
    final dirPath = await _dirPath;
    return '$dirPath/tasks_backup.json';
  }
}