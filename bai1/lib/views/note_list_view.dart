import 'package:flutter/material.dart';
import '../controller/note_controller.dart';
import '../data/models/note.dart';
import 'note_form_view.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final NoteController _controller = NoteController();
  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final notes = await _controller.getAllNotes();
    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _delete(int id) async {
    await _controller.deleteNote(id);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa ghi chú'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
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

  Future<void> _openForm({Note? note}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteFormView(note: note)),
    );
    if (result == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ghi chú')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        tooltip: 'Thêm ghi chú',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? const Center(
        child: Text(
          'Chưa có ghi chú nào.\nNhấn + để thêm mới.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _notes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    note.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
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
}