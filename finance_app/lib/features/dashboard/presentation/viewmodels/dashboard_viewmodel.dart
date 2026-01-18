import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class DashboardViewModel extends BaseViewModel {
  final InvestmentRepository investmentRepository;
  final ExpenseRepository expenseRepository;

  DashboardViewModel({
    required this.investmentRepository,
    required this.expenseRepository,
  });

  Future<void> loadDashboardData() async {
    setLoading(true);
    clearError();

    try {
      // Placeholder for loading logic
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      setError('Failed to load dashboard data: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
