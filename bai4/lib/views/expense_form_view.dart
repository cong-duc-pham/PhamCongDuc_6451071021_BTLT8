import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controller/expense_controller.dart';
import '../data/models/category_model.dart';
import '../data/models/expense_model.dart';

class ExpenseFormView extends StatefulWidget {
  final ExpenseController controller;
  final Expense? expense; // null = add, not null = edit

  const ExpenseFormView({
    super.key,
    required this.controller,
    this.expense,
  });

  @override
  State<ExpenseFormView> createState() => _ExpenseFormViewState();
}

class _ExpenseFormViewState extends State<ExpenseFormView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  List<Category> _categories = [];
  int? _selectedCategoryId;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    _categories = widget.controller.categories;
    if (_isEditing) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      _selectedCategoryId = widget.expense!.categoryId;
    } else {
      _selectedCategoryId = _categories.isNotEmpty ? _categories.first.id : null;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục')),
      );
      return;
    }

    final expense = Expense(
      id: widget.expense?.id,
      amount: double.parse(_amountController.text.trim()),
      note: _noteController.text.trim(),
      categoryId: _selectedCategoryId!,
    );

    if (_isEditing) {
      await widget.controller.editExpense(expense);
    } else {
      await widget.controller.addExpense(expense);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Sửa chi tiêu' : 'Thêm chi tiêu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền (VND)',
                  border: OutlineInputBorder(),
                  prefixText: '₫ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng nhập số tiền';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Số tiền không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Vui lòng nhập ghi chú';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                validator: (val) => val == null ? 'Vui lòng chọn danh mục' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Cập nhật' : 'Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
