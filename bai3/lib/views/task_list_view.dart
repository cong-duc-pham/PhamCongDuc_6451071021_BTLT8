import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../controller/task_controller.dart';
import '../data/models/task.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskController _controller = TaskController();
  final TextEditingController _titleCtrl = TextEditingController();

  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final tasks = await _controller.getAll();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _addTask() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;
    await _controller.addTask(title);
    _titleCtrl.clear();
    await _load();
  }

  Future<void> _toggleDone(Task task) async {
    await _controller.toggleDone(task.id!, !task.isDone);
    await _load();
  }

  Future<void> _delete(int id) async {
    await _controller.deleteTask(id);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đã xóa task'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> _export() async {
    try {
      final path = await _controller.exportToJson();
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Xuất thành công'),
            content: Text('File đã lưu tại:\n$path'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('OK')),
            ],
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _import() async {
    try {
      // Dùng file_picker để chọn file JSON
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return;

      final filePath = result.files.single.path!;
      final count = await _controller.importFromJson(filePath);
      await _load();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã import $count task từ file'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = _tasks.where((t) => t.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
        actions: [
          // Nút Export
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Export JSON',
            onPressed: _export,
          ),
          // Nút Import
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            tooltip: 'Import JSON',
            onPressed: _import,
          ),
        ],
      ),
      body: Column(
        children: [
          // Input thêm task
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleCtrl,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTask(),
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên công việc...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Thêm'),
                ),
              ],
            ),
          ),

          // Thống kê
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  'Tổng: ${_tasks.length} • Hoàn thành: $doneCount',
                  style:
                  const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          const Divider(height: 1),

          // Danh sách task
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _tasks.isEmpty
                ? const Center(
              child: Text(
                'Chưa có công việc nào.\nNhập tên và nhấn Thêm.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1),
              itemBuilder: (_, index) {
                final task = _tasks[index];
                return CheckboxListTile(
                  value: task.isDone,
                  onChanged: (_) => _toggleDone(task),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : null,
                      color: task.isDone
                          ? Colors.grey
                          : null,
                    ),
                  ),
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red),
                    onPressed: () => _delete(task.id!),
                  ),
                  controlAffinity:
                  ListTileControlAffinity.leading,
                );
              },
            ),
          ),

          // Export/Import buttons lớn ở cuối
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _export,
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Export JSON'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _import,
                    icon: const Icon(Icons.download_for_offline_outlined,
                        size: 18),
                    label: const Text('Import JSON'),
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              '6451071021 - Phạm Công Đức',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}