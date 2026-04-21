import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../services/database_helper.dart';

class ExpenseRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<Category>> getCategories() => _db.getAllCategories();

  Future<List<Expense>> getExpenses() => _db.getAllExpenses();

  Future<int> addExpense(Expense expense) => _db.insertExpense(expense);

  Future<int> editExpense(Expense expense) => _db.updateExpense(expense);

  Future<int> removeExpense(int id) => _db.deleteExpense(id);

  Future<List<Map<String, dynamic>>> getTotalByCategory() =>
      _db.getTotalByCategory();
}
