import 'package:flutter/material.dart';
import '../controller/category_controller.dart';
import '../data/models/category.dart';

class CategoryManagerView extends StatefulWidget {
  const CategoryManagerView({super.key});

  @override
  State<CategoryManagerView> createState() => _CategoryManagerViewState();
}

class _CategoryManagerViewState extends State<CategoryManagerView> {
  final CategoryController _controller = CategoryController();
  final TextEditingController _nameCtrl = TextEditingController();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final cats = await _controller.getAll();
    setState(() => _categories = cats);
  }

  Future<void> _add() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    await _controller.add(name);
    _nameCtrl.clear();
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đã thêm danh mục'),
            backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _delete(int id) async {
    await _controller.delete(id);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đã xóa danh mục'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý danh mục')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Tên danh mục mới',
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Thêm')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _categories.isEmpty
                ? const Center(child: Text('Chưa có danh mục nào'))
                : ListView.separated(
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final cat = _categories[index];
                return ListTile(
                  title: Text(cat.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red),
                    onPressed: () => _delete(cat.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}