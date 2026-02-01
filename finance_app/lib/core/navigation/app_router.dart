import 'package:finance_app/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:finance_app/features/expenses/presentation/views/add_expense_view.dart';
import 'package:finance_app/features/expenses/presentation/views/expenses_view.dart';
import 'package:finance_app/features/main_navigation/presentation/views/main_navigation_view.dart';
import 'package:finance_app/features/main_navigation/presentation/views/settings_view.dart';
import 'package:finance_app/features/portfolio/presentation/views/add_investment_view.dart';
import 'package:finance_app/features/portfolio/presentation/views/portfolio_view.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String portfolio = '/portfolio';
  static const String addInvestment = '/add-investment';
  static const String expenses = '/expenses';
  static const String addExpense = '/add-expense';
  static const String settings = '/settings';

  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: dashboard,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainNavigationView(navigationShell: navigationShell);
          },
          branches: <StatefulShellBranch>[
            // Portfolio Branch
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: portfolio,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: PortfolioView()),
                ),
              ],
            ),
            // Add Investment Branch
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: addInvestment,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: AddInvestmentView()),
                ),
              ],
            ),
            // Dashboard Branch (Home)
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: dashboard,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: DashboardView()),
                ),
              ],
            ),
            // Expenses Branch
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: expenses,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: ExpensesView()),
                ),
              ],
            ),
            // Add Expense Branch
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: addExpense,
                  pageBuilder: (context, state) =>
                      const NoTransitionPage(child: AddExpenseView()),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: settings,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsView()),
        ),
      ],
    );
  }
}
