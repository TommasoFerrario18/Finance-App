import 'package:finance_app/features/expenses/domain/models/expense_models.dart';

abstract class ExpenseRepository {
  // This is a placeholder for future implementation
  Future<void> initialize();

  /// Get monthly expense data for current month
  Future<MonthlyExpenseData> getMonthlyExpenseData();

  /// Get all expenses for current month
  Future<List<Expense>> getExpensesForCurrentMonth();

  /// Get category summaries for current month
  Future<List<ExpenseSummary>> getCategorySummaries();

  /// Get total expenses for current month
  Future<double> getTotalExpenses();
}
