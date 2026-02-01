import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_app/features/expenses/domain/models/expense_models.dart';

class ExpensePieChart extends StatelessWidget {
  final List<ExpenseSummary> categorySummaries;

  const ExpensePieChart({
    super.key,
    required this.categorySummaries,
  });

  Color _getCategoryColor(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.food => const Color(0xFFFF6B6B),
      ExpenseCategory.transportation => const Color(0xFF4ECDC4),
      ExpenseCategory.entertainment => const Color(0xFFFFE66D),
      ExpenseCategory.utilities => const Color(0xFF95E1D3),
      ExpenseCategory.healthcare => const Color(0xFFF38181),
      ExpenseCategory.shopping => const Color(0xFFAA96DA),
      ExpenseCategory.education => const Color(0xFF5DADE2),
      ExpenseCategory.other => const Color(0xFFBDC3C7),
    };
  }

  List<PieChartSectionData> _getSections() {
    return categorySummaries.map((summary) {
      return PieChartSectionData(
        color: _getCategoryColor(summary.category),
        value: summary.percentage,
        title: '${summary.percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (categorySummaries.isEmpty) {
      return Center(
        child: Text(
          'No expenses to display',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return Column(
      children: [
        // Pie Chart
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: _getSections(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ),
        // Legend
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categorySummaries.length,
            itemBuilder: (context, index) {
              final summary = categorySummaries[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(summary.category),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${summary.category.emoji} ${summary.category.label}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${summary.totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${summary.percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
