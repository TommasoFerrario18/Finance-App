import 'package:flutter/material.dart';
import 'package:finance_app/features/portfolio/domain/models/investment_models.dart';

class PortfolioHoldingsWidget extends StatelessWidget {
  final List<AssetTypeAllocation> assetAllocations;

  const PortfolioHoldingsWidget({
    super.key,
    required this.assetAllocations,
  });

  Color _getAssetTypeColor(AssetType assetType) {
    return switch (assetType) {
      AssetType.stock => const Color(0xFF2196F3),
      AssetType.bond => const Color(0xFF4CAF50),
      AssetType.realestate => const Color(0xFFFF9800),
      AssetType.crypto => const Color(0xFFF44336),
      AssetType.cash => const Color(0xFF9C27B0),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (assetAllocations.isEmpty) {
      return Center(
        child: Text(
          'No holdings',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: assetAllocations.length,
      itemBuilder: (context, index) {
        final allocation = assetAllocations[index];
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with type and percentage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getAssetTypeColor(allocation.assetType),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${allocation.assetType.emoji} ${allocation.assetType.label}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      '${allocation.percentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Value
                Text(
                  'Value: \$${allocation.totalValue.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                // Holdings count
                Text(
                  '${allocation.investments.length} ${allocation.investments.length == 1 ? 'holding' : 'holdings'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
