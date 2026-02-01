import 'package:finance_app/features/expenses/presentation/viewmodels/add_expense_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddExpenseForm extends StatelessWidget {
  const AddExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddExpenseViewModel>();

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Expense Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // --- Description & Category Section ---
          TextField(
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'e.g. Grocery shopping or Electricity bill',
              prefixIcon: const Icon(Icons.description_outlined),
              errorText: viewModel.validationErrors['description'],
            ),
            onChanged: (value) => viewModel.description = value,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Category',
              prefixIcon: const Icon(Icons.category_outlined),
              errorText: viewModel.validationErrors['category'],
            ),
            value: viewModel.category,
            items: viewModel.categories
                .map(
                  (label) => DropdownMenuItem(value: label, child: Text(label)),
                )
                .toList(),
            onChanged: (value) => viewModel.category = value,
          ),
          const SizedBox(height: 16),

          // --- Amount & Payment Method Section ---
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixIcon: const Icon(Icons.attach_money),
              suffixText: 'USD',
              errorText: viewModel.validationErrors['amount'],
            ),
            onChanged: (value) =>
                viewModel.amount = double.tryParse(value) ?? 0.0,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Payment Method',
              prefixIcon: Icon(Icons.payment_outlined),
            ),
            value: viewModel.paymentMethod,
            items: viewModel.paymentMethods
                .map(
                  (method) =>
                      DropdownMenuItem(value: method, child: Text(method)),
                )
                .toList(),
            onChanged: (value) => viewModel.paymentMethod = value,
          ),
          const SizedBox(height: 16),

          // --- Date Picker Field ---
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: viewModel.expenseDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                viewModel.expenseDate = pickedDate;
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Expense Date',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                errorText: viewModel.validationErrors['expenseDate'],
              ),
              child: Text(
                DateFormat('yyyy-MM-dd').format(viewModel.expenseDate),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Recurring Expense Toggle ---
          SwitchListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            title: const Text('Recurring Expense'),
            subtitle: const Text('Mark if this is a regular expense'),
            value: viewModel.isRecurring,
            onChanged: (value) => viewModel.isRecurring = value,
          ),

          // --- Recurring Frequency (shown only if recurring) ---
          if (viewModel.isRecurring) ...[
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Frequency',
                prefixIcon: Icon(Icons.repeat),
              ),
              value: viewModel.recurringFrequency,
              items: viewModel.recurringFrequencies
                  .map(
                    (freq) => DropdownMenuItem(value: freq, child: Text(freq)),
                  )
                  .toList(),
              onChanged: (value) => viewModel.recurringFrequency = value,
            ),
          ],
          const SizedBox(height: 16),

          // --- Notes Section ---
          TextField(
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Add any additional details',
              prefixIcon: Icon(Icons.notes_outlined),
              alignLabelWithHint: true,
            ),
            onChanged: (value) => viewModel.notes = value,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
