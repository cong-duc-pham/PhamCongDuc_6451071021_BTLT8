import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/log_controller.dart';

class ItemView extends StatefulWidget {
  const ItemView({super.key});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _showEditDialog(BuildContext context, LogController ctrl, int index) {
    final editCtrl = TextEditingController(text: ctrl.items[index]);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sửa'),
        content: TextField(controller: editCtrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              final val = editCtrl.text.trim();
              if (val.isNotEmpty) ctrl.editItem(index, val);
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<LogController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Tên mục',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final val = _nameCtrl.text.trim();
                  if (val.isNotEmpty) {
                    ctrl.addItem(val);
                    _nameCtrl.clear();
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ctrl.items.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu'))
                : ListView.builder(
              itemCount: ctrl.items.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(ctrl.items[i]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showEditDialog(context, ctrl, i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => ctrl.deleteItem(i),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}