import 'package:flutter/material.dart';
import '../controller/note_controller.dart';
import '../data/models/note.dart';

class NoteFormView extends StatefulWidget {
  final Note? note;
  const NoteFormView({super.key, this.note});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final NoteController _controller = NoteController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề')),
      );
      return;
    }

    setState(() => _isSaving = true);

    if (_isEditing) {
      await _controller.updateNote(
        widget.note!.copyWith(title: title, content: content),
      );
    } else {
      await _controller.addNote(title, content);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Đã cập nhật ghi chú' : 'Đã thêm ghi chú mới'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
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
            tooltip: 'Lưu',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tiêu đề'),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Nhập tiêu đề ghi chú',
                border: OutlineInputBorder(),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Nội dung'),
            const SizedBox(height: 6),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Nhập nội dung ghi chú...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
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