import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';

class AddExpenseViewModel extends BaseViewModel {
  final ExpenseRepository repository;

  AddExpenseViewModel({required this.repository});

  Future<void> addExpense() async {
    setLoading(true);
    clearError();

    try {
      // Placeholder for adding expense logic
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      setError('Failed to add expense: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
