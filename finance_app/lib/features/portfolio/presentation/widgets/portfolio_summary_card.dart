import 'package:flutter/material.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final double totalValue;
  final double totalCost;
  final double totalGainLoss;
  final double totalGainLossPercentage;

  const PortfolioSummaryCard({
    super.key,
    required this.totalValue,
    required this.totalCost,
    required this.totalGainLoss,
    required this.totalGainLossPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = totalGainLoss >= 0;
    final gainLossColor = isPositive
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF6B6B);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Total Value
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Value',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '\$${totalValue.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Total Cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Cost',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Divider
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 12),
            // Gain/Loss
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gain / Loss',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isPositive ? '+' : ''}\$${totalGainLoss.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: gainLossColor,
                      ),
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${totalGainLossPercentage.toStringAsFixed(2)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: gainLossColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
