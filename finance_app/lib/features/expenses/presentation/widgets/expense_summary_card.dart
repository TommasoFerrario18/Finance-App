import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseSummaryCard extends StatelessWidget {
  final double totalExpenses;
  final DateTime month;

  const ExpenseSummaryCard({
    super.key,
    required this.totalExpenses,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat('MMMM yyyy').format(month);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              monthName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Expenses',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '\$${totalExpenses.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
