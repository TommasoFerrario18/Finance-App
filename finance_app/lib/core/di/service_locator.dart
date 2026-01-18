import 'package:finance_app/core/database/app_database.dart';
import 'package:finance_app/core/database/database_seeder.dart';
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

Future<void> setupServiceLocator({bool seedDatabase = false}) async {
  // ============================================================================
  // Database (Singleton)
  // ============================================================================
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  // ============================================================================
  // Seed database if requested (development only)
  // ============================================================================
  if (seedDatabase) {
    final seeder = DatabaseSeeder(database);

    // Only seed if database is empty
    final hasData = await seeder.hasData();
    if (!hasData) {
      print('Seeding database with sample data...');
      await seeder.seedAll();
      print('Database seeded successfully!');
    }
  }

  // Core - Register as singleton and initialize immediately
  getIt.registerSingleton<AppRouter>(AppRouter());

  // Repositories
  getIt.registerLazySingleton<InvestmentRepository>(
    () => InvestmentRepositoryImpl(database: getIt<AppDatabase>()),
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

/// Cleanup resources (call this when app is closing)
Future<void> disposeServiceLocator() async {
  final database = getIt<AppDatabase>();
  await database.close();
  await getIt.reset();
}
