import 'package:finance_app/core/navigation/app_router.dart';
import 'package:finance_app/features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:finance_app/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';
import 'package:finance_app/features/expenses/presentation/viewmodels/add_expense_viewmodel.dart';
import 'package:finance_app/features/expenses/presentation/viewmodels/expenses_viewmodel.dart';
import 'package:finance_app/features/portfolio/data/repositories/investment_repository_impl.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/add_investment_viewmodel.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core - Register as singleton and initialize immediately
  getIt.registerSingleton<AppRouter>(AppRouter());

  // Repositories
  getIt.registerLazySingleton<InvestmentRepository>(
    () => InvestmentRepositoryImpl(),
  );

  getIt.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl());

  // ViewModels - Factory pattern for proper lifecycle management
  getIt.registerFactory<DashboardViewModel>(
    () => DashboardViewModel(
      investmentRepository: getIt<InvestmentRepository>(),
      expenseRepository: getIt<ExpenseRepository>(),
    ),
  );

  getIt.registerFactory<PortfolioViewModel>(
    () => PortfolioViewModel(repository: getIt<InvestmentRepository>()),
  );

  getIt.registerFactory<AddInvestmentViewModel>(
    () => AddInvestmentViewModel(repository: getIt<InvestmentRepository>()),
  );

  getIt.registerFactory<ExpensesViewModel>(
    () => ExpensesViewModel(repository: getIt<ExpenseRepository>()),
  );

  getIt.registerFactory<AddExpenseViewModel>(
    () => AddExpenseViewModel(repository: getIt<ExpenseRepository>()),
  );
}
