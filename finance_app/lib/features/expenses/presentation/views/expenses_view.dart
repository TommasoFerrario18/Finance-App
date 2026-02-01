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
    if (viewModel.monthlyData != null && viewModel.categorySummaries.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: Column(
          children: [
            // Summary Card
            ExpenseSummaryCard(
              totalExpenses: viewModel.monthlyData!.totalExpenses,
              month: viewModel.monthlyData!.month,
            ),
            // Pie Chart
            Expanded(
              child: ExpensePieChart(
                categorySummaries: viewModel.categorySummaries,
              ),
            ),
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
