import 'package:flutter/material.dart';
import '../data/models/category_model.dart';
import '../data/models/expense_model.dart';
import '../data/repository/expense_repository.dart';

class ExpenseController extends ChangeNotifier {
  final ExpenseRepository _repository = ExpenseRepository();

  List<Expense> expenses = [];
  List<Category> categories = [];
  List<Map<String, dynamic>> totalByCategory = [];

  bool isLoading = false;

  Future<void> loadAll() async {
    isLoading = true;
    notifyListeners();

    expenses = await _repository.getExpenses();
    categories = await _repository.getCategories();
    totalByCategory = await _repository.getTotalByCategory();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _repository.addExpense(expense);
    await loadAll();
  }

  Future<void> editExpense(Expense expense) async {
    await _repository.editExpense(expense);
    await loadAll();
  }

  Future<void> deleteExpense(int id) async {
    await _repository.removeExpense(id);
    await loadAll();
  }

  double get totalAmount =>
      expenses.fold(0.0, (sum, e) => sum + e.amount);

  String getCategoryName(int categoryId) {
    final cat = categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(name: 'Không rõ'),
    );
    return cat.name;
  }
}
