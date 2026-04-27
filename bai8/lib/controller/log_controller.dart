import 'package:flutter/material.dart';
import '../data/models/log_entry.dart';
import '../data/services/log_service.dart';

class LogController extends ChangeNotifier {
  final LogService _service;

  LogController(this._service);

  List<LogEntry> logs = [];
  String fileContent = '';
  // Demo item list
  List<String> items = [];
  int _idCounter = 1;

  Future<void> loadLogs() async {
    logs = await _service.getLogs();
    fileContent = await _service.getFileContent();
    notifyListeners();
  }

  // ─── Demo CRUD ────────────────────────────────────────
  Future<void> addItem(String name) async {
    items.add('[$_idCounter] $name');
    await _service.log('THÊM: $name (id=$_idCounter)');
    _idCounter++;
    await loadLogs();
  }

  Future<void> editItem(int index, String newName) async {
    final old = items[index];
    items[index] = newName;
    await _service.log('SỬA: "$old" → "$newName"');
    await loadLogs();
  }

  Future<void> deleteItem(int index) async {
    final name = items[index];
    items.removeAt(index);
    await _service.log('XÓA: $name');
    await loadLogs();
  }

  Future<void> clearAll() async {
    await _service.clearAll();
    await loadLogs();
  }
}