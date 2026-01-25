import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/base_feature_view.dart';
import 'package:finance_app/features/expenses/presentation/viewmodels/expenses_viewmodel.dart';
import 'package:flutter/material.dart';

class ExpensesView extends BaseFeatureView<ExpensesViewModel> {
  const ExpensesView({super.key});

  @override
  String get title => 'Expenses';

  @override
  ExpensesViewModel createViewModel() => getIt<ExpensesViewModel>();

  @override
  Widget buildContent(BuildContext context, ExpensesViewModel viewModel) {
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
            'Expenses',
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
