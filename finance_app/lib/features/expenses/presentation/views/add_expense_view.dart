import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:finance_app/features/expenses/presentation/viewmodels/add_expense_viewmodel.dart';
import 'package:finance_app/features/expenses/presentation/widgets/add_expense_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseView extends StatelessWidget {
  const AddExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AddExpenseViewModel>(),
      child: Consumer<AddExpenseViewModel>(
        builder: (context, viewModel, child) {
          return FeatureScaffold(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add Expense',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Expense Form
                  const Expanded(child: AddExpenseForm()),

                  // Save Button
                  ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => _handleSave(context, viewModel),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Save Expense'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSave(
    BuildContext context,
    AddExpenseViewModel viewModel,
  ) async {
    final success = await viewModel.save();

    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else if (viewModel.validationErrors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fix the errors in the form'),
            backgroundColor: Colors.orange,
          ),
        );
      } else if (viewModel.validationErrors.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${viewModel.validationErrors}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
