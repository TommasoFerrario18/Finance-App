import 'package:finance_app/features/expenses/data/datasources/expense_mock_data.dart';
import 'package:finance_app/features/expenses/domain/models/expense_models.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  @override
  Future<void> initialize() async {
    // Placeholder for initialization logic
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<MonthlyExpenseData> getMonthlyExpenseData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return ExpenseMockData.getMonthlyExpenseDataForCurrentMonth();
  }

  @override
  Future<List<Expense>> getExpensesForCurrentMonth() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return ExpenseMockData.getExpensesForCurrentMonth();
  }

  @override
  Future<List<ExpenseSummary>> getCategorySummaries() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return ExpenseMockData.getCategorySummariesForCurrentMonth();
  }

  @override
  Future<double> getTotalExpenses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    return ExpenseMockData.getTotalExpensesForCurrentMonth();
  }
}
