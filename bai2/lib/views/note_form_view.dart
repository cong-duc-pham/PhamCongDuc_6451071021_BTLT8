import 'package:flutter/material.dart';
import '../controller/category_controller.dart';
import '../controller/note_controller.dart';
import '../data/models/category.dart';
import '../data/models/note_with_category.dart';

class NoteFormView extends StatefulWidget {
  final NoteWithCategory? note;
  const NoteFormView({super.key, this.note});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final NoteController _noteCtrl = NoteController();
  final CategoryController _catCtrl = CategoryController();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = true;
  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleCtrl.text = widget.note!.title;
      _contentCtrl.text = widget.note!.content;
    }
    _loadCategories();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final cats = await _catCtrl.getAll();
    setState(() {
      _categories = cats;
      _selectedCategory = _isEditing
          ? cats.firstWhere((c) => c.id == widget.note!.categoryId,
          orElse: () => cats.first)
          : cats.isNotEmpty
          ? cats.first
          : null;
      _isLoading = false;
    });
  }

  Future<void> _save() async {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vui lòng nhập tiêu đề')));
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Vui lòng chọn danh mục')));
      return;
    }

    setState(() => _isSaving = true);

    if (_isEditing) {
      await _noteCtrl.update(
        id: widget.note!.id!,
        title: title,
        content: content,
        categoryId: _selectedCategory!.id!,
      );
    } else {
      await _noteCtrl.add(
        title: title,
        content: content,
        categoryId: _selectedCategory!.id!,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Đã cập nhật ghi chú' : 'Đã thêm ghi chú mới'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Chỉnh sửa ghi chú' : 'Thêm ghi chú'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown danh mục
            const Text('Danh mục'),
            const SizedBox(height: 6),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(
                  value: c, child: Text(c.name)))
                  .toList(),
              onChanged: (val) =>
                  setState(() => _selectedCategory = val),
            ),

            const SizedBox(height: 14),

            // Tiêu đề
            const Text('Tiêu đề'),
            const SizedBox(height: 6),
            TextField(
              controller: _titleCtrl,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Nhập tiêu đề ghi chú',
                border: OutlineInputBorder(),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),

            const SizedBox(height: 14),

            // Nội dung
            const Text('Nội dung'),
            const SizedBox(height: 6),
            Expanded(
              child: TextField(
                controller: _contentCtrl,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Nhập nội dung...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(_isEditing ? 'Cập nhật' : 'Lưu'),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                '6451071021 - Phạm Công Đức',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}