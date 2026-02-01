import 'package:finance_app/features/portfolio/domain/models/investment_models.dart';

class PortfolioMockData {
  static final DateTime now = DateTime.now();

  static final List<Investment> mockInvestments = [
    // Stocks
    Investment(
      id: 'inv_001',
      name: 'Apple Inc.',
      ticker: 'AAPL',
      assetType: AssetType.stock,
      quantity: 50,
      currentPrice: 178.50,
      costBasis: 145.00,
      purchaseDate: DateTime(2022, 6, 15),
    ),
    Investment(
      id: 'inv_002',
      name: 'Microsoft Corporation',
      ticker: 'MSFT',
      assetType: AssetType.stock,
      quantity: 30,
      currentPrice: 380.00,
      costBasis: 310.00,
      purchaseDate: DateTime(2022, 9, 20),
    ),
    Investment(
      id: 'inv_003',
      name: 'Tesla Inc.',
      ticker: 'TSLA',
      assetType: AssetType.stock,
      quantity: 20,
      currentPrice: 242.50,
      costBasis: 280.00,
      purchaseDate: DateTime(2023, 1, 10),
    ),
    Investment(
      id: 'inv_004',
      name: 'Amazon.com Inc.',
      ticker: 'AMZN',
      assetType: AssetType.stock,
      quantity: 15,
      currentPrice: 170.00,
      costBasis: 140.00,
      purchaseDate: DateTime(2023, 3, 5),
    ),

    // Bonds
    Investment(
      id: 'inv_005',
      name: 'US Treasury Bond',
      ticker: 'UST',
      assetType: AssetType.bond,
      quantity: 100,
      currentPrice: 1015.00,
      costBasis: 1000.00,
      purchaseDate: DateTime(2022, 1, 1),
    ),
    Investment(
      id: 'inv_006',
      name: 'Corporate Bond ETF',
      ticker: 'LQD',
      assetType: AssetType.bond,
      quantity: 200,
      currentPrice: 98.50,
      costBasis: 102.00,
      purchaseDate: DateTime(2022, 4, 10),
    ),

    // Real Estate
    Investment(
      id: 'inv_007',
      name: 'Real Estate Investment Trust',
      ticker: 'REIT',
      assetType: AssetType.realestate,
      quantity: 75,
      currentPrice: 45.00,
      costBasis: 38.00,
      purchaseDate: DateTime(2021, 11, 1),
    ),

    // Cryptocurrency
    Investment(
      id: 'inv_008',
      name: 'Bitcoin',
      ticker: 'BTC',
      assetType: AssetType.crypto,
      quantity: 0.5,
      currentPrice: 42500.00,
      costBasis: 28000.00,
      purchaseDate: DateTime(2021, 6, 15),
    ),
    Investment(
      id: 'inv_009',
      name: 'Ethereum',
      ticker: 'ETH',
      assetType: AssetType.crypto,
      quantity: 5,
      currentPrice: 2250.00,
      costBasis: 1800.00,
      purchaseDate: DateTime(2021, 9, 1),
    ),

    // Cash
    Investment(
      id: 'inv_010',
      name: 'Savings Account',
      ticker: 'CASH',
      assetType: AssetType.cash,
      quantity: 1.0,
      currentPrice: 25000.00,
      costBasis: 25000.00,
      purchaseDate: DateTime(2020, 1, 1),
    ),
  ];

  /// Calculate portfolio summary
  static PortfolioSummary getPortfolioSummary() {
    double totalValue = 0;
    double totalCost = 0;

    for (final investment in mockInvestments) {
      totalValue += investment.currentValue;
      totalCost += investment.totalCost;
    }

    final totalGainLoss = totalValue - totalCost;
    final totalGainLossPercentage =
        totalCost > 0 ? (totalGainLoss / totalCost) * 100 : 0.0;

    // Group by asset type
    final Map<AssetType, List<Investment>> grouped = {};
    for (final investment in mockInvestments) {
      grouped.putIfAbsent(investment.assetType, () => []).add(investment);
    }

    final assetAllocations = grouped.entries
        .map((entry) {
          final investments = entry.value;
          final typeTotal =
              investments.fold(0.0, (sum, inv) => sum + inv.currentValue);
          final percentage = totalValue > 0 ? (typeTotal / totalValue) * 100 : 0.0;

          return AssetTypeAllocation(
            assetType: entry.key,
            totalValue: typeTotal,
            percentage: percentage,
            investments: investments,
          );
        })
        .toList()
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));

    return PortfolioSummary(
      totalValue: totalValue,
      totalCost: totalCost,
      totalGainLoss: totalGainLoss,
      totalGainLossPercentage: totalGainLossPercentage,
      allInvestments: mockInvestments,
      assetAllocations: assetAllocations,
      lastUpdated: now,
    );
  }

  /// Get all investments
  static List<Investment> getAllInvestments() {
    return mockInvestments;
  }

  /// Get investments by asset type
  static List<Investment> getInvestmentsByType(AssetType assetType) {
    return mockInvestments.where((inv) => inv.assetType == assetType).toList();
  }
}
