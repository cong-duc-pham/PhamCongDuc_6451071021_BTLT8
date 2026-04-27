import 'package:intl/intl.dart';
import '../models/log_entry.dart';
import '../repository/log_repository.dart';

class LogService {
  final LogRepository _repo;
  LogService(this._repo);

  String _now() =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  Future<void> log(String action) async {
    final entry = LogEntry(action: action, time: _now());
    // Ghi đồng thời DB + file
    await Future.wait([
      _repo.insertLog(entry),
      _repo.writeToFile('[${entry.time}] $action'),
    ]);
  }

  Future<List<LogEntry>> getLogs() => _repo.getLogs();

  Future<String> getFileContent() => _repo.readFile();

  Future<void> clearAll() async {
    await Future.wait([_repo.clearLogs(), _repo.clearFile()]);
  }
}