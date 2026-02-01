import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/expenses/domain/models/expense_models.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';

class ExpensesViewModel extends BaseViewModel {
  final ExpenseRepository repository;

  ExpensesViewModel({required this.repository});

  // State
  MonthlyExpenseData? _monthlyData;
  List<ExpenseSummary> _categorySummaries = [];
  double _totalExpenses = 0.0;

  // Getters
  MonthlyExpenseData? get monthlyData => _monthlyData;
  List<ExpenseSummary> get categorySummaries => _categorySummaries;
  double get totalExpenses => _totalExpenses;

  @override
  Future<void> init() => loadExpenses();

  Future<void> loadExpenses() async {
    await executeAsync(() async {
      _monthlyData = await repository.getMonthlyExpenseData();
      _categorySummaries = await repository.getCategorySummaries();
      _totalExpenses = await repository.getTotalExpenses();
      notifyListeners();
    });
  }

  /// Refresh expense data
  Future<void> refresh() async {
    await executeAsync(() async {
      _monthlyData = await repository.getMonthlyExpenseData();
      _categorySummaries = await repository.getCategorySummaries();
      _totalExpenses = await repository.getTotalExpenses();
      notifyListeners();
    }, showLoading: false);
  }
}
