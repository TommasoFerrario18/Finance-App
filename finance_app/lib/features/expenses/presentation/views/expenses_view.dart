import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/base_feature_view.dart';
import 'package:finance_app/features/expenses/presentation/viewmodels/expenses_viewmodel.dart';
import 'package:finance_app/features/expenses/presentation/widgets/expense_summary_card.dart';
import 'package:finance_app/features/expenses/presentation/widgets/expense_pie_chart.dart';
import 'package:flutter/material.dart';

class ExpensesView extends BaseFeatureView<ExpensesViewModel> {
  const ExpensesView({super.key});

  @override
  String get title => '';

  @override
  ExpensesViewModel createViewModel() => getIt<ExpensesViewModel>();

  @override
  Widget buildContent(BuildContext context, ExpensesViewModel viewModel) {
    // Show dashboard with data
    if (viewModel.monthlyData != null &&
        viewModel.categorySummaries.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: ListView(
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Overview',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your spending and savings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Summary Card
            ExpenseSummaryCard(
              totalExpenses: viewModel.monthlyData!.totalExpenses,
              totalIncome: viewModel.monthlyData!.totalIncome,
              month: viewModel.monthlyData!.month,
            ),
            // Chart Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Breakdown by Category',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Pie Chart - Expanded to fill remaining space
            ExpensePieChart(categorySummaries: viewModel.categorySummaries),
          ],
        ),
      );
    }

    // Fallback empty state when no data available
    return _buildEmptyState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Expenses',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Analyze your spending',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
