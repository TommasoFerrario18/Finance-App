import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';

class ExpensesViewModel extends BaseViewModel {
  final ExpenseRepository repository;

  ExpensesViewModel({required this.repository});

  @override
  Future<void> init() => loadExpenses();

  Future<void> loadExpenses() async {
    await executeAsync(() => repository.initialize());
  }
}
