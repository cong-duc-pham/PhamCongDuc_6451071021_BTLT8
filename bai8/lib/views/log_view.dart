import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/log_controller.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  bool _showFile = false; // toggle DB list ↔ file content

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LogController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ── Toolbar ──────────────────────────────────────
          Row(
            children: [
              const Text('Nguồn: '),
              ChoiceChip(
                label: const Text('Database'),
                selected: !_showFile,
                onSelected: (_) => setState(() => _showFile = false),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('File .txt'),
                selected: _showFile,
                onSelected: (_) => setState(() => _showFile = true),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.delete_sweep, size: 18),
                label: const Text('Xoá log'),
                onPressed: () async {
                  await ctrl.clearAll();
                },
              ),
            ],
          ),
          const Divider(),

          // ── Content ──────────────────────────────────────
          Expanded(
            child: _showFile ? _buildFileView(ctrl) : _buildDbView(ctrl),
          ),
        ],
      ),
    );
  }

  // Hiển thị log từ SQLite
  Widget _buildDbView(LogController ctrl) {
    if (ctrl.logs.isEmpty) {
      return const Center(child: Text('Chưa có log trong database'));
    }
    return ListView.builder(
      itemCount: ctrl.logs.length,
      itemBuilder: (_, i) {
        final log = ctrl.logs[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${log.id}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '[${log.time}] ${log.action}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hiển thị log từ file .txt dùng SingleChildScrollView
  Widget _buildFileView(LogController ctrl) {
    if (ctrl.fileContent.trim().isEmpty ||
        ctrl.fileContent == '(Chưa có log)') {
      return const Center(child: Text('File log trống'));
    }
    return SingleChildScrollView(
      child: Text(
        ctrl.fileContent,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    );
  }
}