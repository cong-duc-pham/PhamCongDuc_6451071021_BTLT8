import 'package:flutter/material.dart';
import '../controller/category_controller.dart';
import '../controller/note_controller.dart';
import '../data/models/category.dart';
import '../data/models/note_with_category.dart';
import 'category_manager_view.dart';
import 'note_form_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final NoteController _noteCtrl = NoteController();
  final CategoryController _catCtrl = CategoryController();

  List<NoteWithCategory> _notes = [];
  List<Category> _categories = [];
  Category? _filterCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    final cats = await _catCtrl.getAll();
    final notes = await _noteCtrl.getAll(categoryId: _filterCategory?.id);
    setState(() {
      _categories = cats;
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _delete(int id) async {
    await _noteCtrl.delete(id);
    await _loadAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Đã xóa ghi chú'), backgroundColor: Colors.red),
      );
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa ghi chú này?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _delete(id);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm({NoteWithCategory? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteFormView(note: note)),
    );
    if (result == true) await _loadAll();
  }

  Future<void> _openCategoryManager() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CategoryManagerView()),
    );
    await _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.label_outline),
            tooltip: 'Quản lý danh mục',
            onPressed: _openCategoryManager,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        tooltip: 'Thêm ghi chú',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return _chip(
                    label: 'Tất cả',
                    selected: _filterCategory == null,
                    onTap: () {
                      setState(() => _filterCategory = null);
                      _loadAll();
                    },
                  );
                }
                final cat = _categories[index - 1];
                return _chip(
                  label: cat.name,
                  selected: _filterCategory?.id == cat.id,
                  onTap: () {
                    setState(() => _filterCategory = cat);
                    _loadAll();
                  },
                );
              },
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                ? const Center(
              child: Text(
                'Chưa có ghi chú nào.\nNhấn + để thêm mới.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.separated(
              itemCount: _notes.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1),
              itemBuilder: (_, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        note.categoryName,
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red),
                    onPressed: () => _confirmDelete(note.id!),
                  ),
                  onTap: () => _openForm(note: note),
                );
              },
            ),
          ),

          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '6451071021 - Phạm Công Đức',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}