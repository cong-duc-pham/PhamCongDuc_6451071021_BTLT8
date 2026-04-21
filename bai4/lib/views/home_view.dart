import 'package:flutter/material.dart';
import '../controller/expense_controller.dart';
import '../data/models/expense_model.dart';
import 'expense_form_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ExpenseController _controller = ExpenseController();

  @override
  void initState() {
    super.initState();
    _controller.loadAll();
  }

  Future<void> _navigateToForm({Expense? expense}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExpenseFormView(
          controller: _controller,
          expense: expense,
        ),
      ),
    );
    setState(() {}); // refresh after form closes
  }

  Future<void> _confirmDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa chi tiêu này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _controller.deleteExpense(id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Tổng chi tiêu
              Container(
                width: double.infinity,
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  'Tổng chi tiêu: ${_formatAmount(_controller.totalAmount)} ₫',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tổng theo danh mục
              if (_controller.totalByCategory.isNotEmpty)
                ExpansionTile(
                  title: const Text('Chi tiết theo danh mục'),
                  children: _controller.totalByCategory.map((item) {
                    return ListTile(
                      dense: true,
                      title: Text(item['categoryName'] as String),
                      trailing: Text(
                        '${_formatAmount((item['total'] as num).toDouble())} ₫',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),

              const Divider(height: 1),

              // Danh sách chi tiêu
              Expanded(
                child: _controller.expenses.isEmpty
                    ? const Center(child: Text('Chưa có chi tiêu nào'))
                    : ListView.builder(
                        itemCount: _controller.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = _controller.expenses[index];
                          final categoryName =
                              _controller.getCategoryName(expense.categoryId);
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text(expense.note),
                              subtitle: Text(categoryName),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_formatAmount(expense.amount)} ₫',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 20),
                                    onPressed: () =>
                                        _navigateToForm(expense: expense),
                                    tooltip: 'Sửa',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 20, color: Colors.red),
                                    onPressed: () =>
                                        _confirmDelete(expense.id!),
                                    tooltip: 'Xóa',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Footer
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Colors.grey[200],
                child: const Text(
                  '6451071021 - Phạm Công Đức',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        tooltip: 'Thêm chi tiêu',
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}
