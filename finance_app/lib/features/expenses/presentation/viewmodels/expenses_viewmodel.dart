import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';

class ExpensesViewModel extends BaseViewModel {
  final ExpenseRepository repository;

  ExpensesViewModel({required this.repository});

  Future<void> loadExpenses() async {
    setLoading(true);
    clearError();

    try {
      await repository.initialize();
      // Placeholder for loading expenses data
    } catch (e) {
      setError('Failed to load expenses: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
