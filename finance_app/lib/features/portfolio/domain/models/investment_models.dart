import 'package:equatable/equatable.dart';

/// Enum for portfolio asset types
enum AssetType {
  stock('Stock', '📈'),
  bond('Bond', '📊'),
  realestate('Real Estate', '🏠'),
  crypto('Cryptocurrency', '₿'),
  cash('Cash', '💵');

  final String label;
  final String emoji;

  const AssetType(this.label, this.emoji);
}

/// Represents a single investment/holding
class Investment extends Equatable {
  final String id;
  final String name;
  final String ticker;
  final AssetType assetType;
  final double quantity;
  final double currentPrice;
  final double costBasis;
  final DateTime purchaseDate;

  const Investment({
    required this.id,
    required this.name,
    required this.ticker,
    required this.assetType,
    required this.quantity,
    required this.currentPrice,
    required this.costBasis,
    required this.purchaseDate,
  });

  /// Get the current value of this investment
  double get currentValue => quantity * currentPrice;

  /// Get the total cost
  double get totalCost => quantity * costBasis;

  /// Get gain/loss amount
  double get gainLoss => currentValue - totalCost;

  /// Get gain/loss percentage
  double get gainLossPercentage {
    if (totalCost == 0) return 0.0;
    return (gainLoss / totalCost) * 100;
  }

  @override
  List<Object?> get props =>
      [id, name, ticker, assetType, quantity, currentPrice, costBasis, purchaseDate];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ticker': ticker,
    'assetType': assetType.name,
    'quantity': quantity,
    'currentPrice': currentPrice,
    'costBasis': costBasis,
    'purchaseDate': purchaseDate.toIso8601String(),
  };

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'] as String,
      name: json['name'] as String,
      ticker: json['ticker'] as String,
      assetType: AssetType.values.firstWhere(
        (e) => e.name == json['assetType'] as String,
        orElse: () => AssetType.stock,
      ),
      quantity: (json['quantity'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
      costBasis: (json['costBasis'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
    );
  }
}

/// Represents portfolio asset type allocation
class AssetTypeAllocation extends Equatable {
  final AssetType assetType;
  final double totalValue;
  final double percentage;
  final List<Investment> investments;

  const AssetTypeAllocation({
    required this.assetType,
    required this.totalValue,
    required this.percentage,
    required this.investments,
  });

  @override
  List<Object?> get props =>
      [assetType, totalValue, percentage, investments];

  Map<String, dynamic> toJson() => {
    'assetType': assetType.name,
    'totalValue': totalValue,
    'percentage': percentage,
    'investments': investments.map((e) => e.toJson()).toList(),
  };

  factory AssetTypeAllocation.fromJson(Map<String, dynamic> json) {
    return AssetTypeAllocation(
      assetType: AssetType.values.firstWhere(
        (e) => e.name == json['assetType'] as String,
        orElse: () => AssetType.stock,
      ),
      totalValue: (json['totalValue'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      investments: (json['investments'] as List)
          .map((e) => Investment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Represents complete portfolio data
class PortfolioSummary extends Equatable {
  final double totalValue;
  final double totalCost;
  final double totalGainLoss;
  final double totalGainLossPercentage;
  final List<Investment> allInvestments;
  final List<AssetTypeAllocation> assetAllocations;
  final DateTime lastUpdated;

  const PortfolioSummary({
    required this.totalValue,
    required this.totalCost,
    required this.totalGainLoss,
    required this.totalGainLossPercentage,
    required this.allInvestments,
    required this.assetAllocations,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    totalValue,
    totalCost,
    totalGainLoss,
    totalGainLossPercentage,
    allInvestments,
    assetAllocations,
    lastUpdated,
  ];

  Map<String, dynamic> toJson() => {
    'totalValue': totalValue,
    'totalCost': totalCost,
    'totalGainLoss': totalGainLoss,
    'totalGainLossPercentage': totalGainLossPercentage,
    'allInvestments': allInvestments.map((e) => e.toJson()).toList(),
    'assetAllocations': assetAllocations.map((e) => e.toJson()).toList(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalValue: (json['totalValue'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      totalGainLoss: (json['totalGainLoss'] as num).toDouble(),
      totalGainLossPercentage:
          (json['totalGainLossPercentage'] as num).toDouble(),
      allInvestments: (json['allInvestments'] as List)
          .map((e) => Investment.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetAllocations: (json['assetAllocations'] as List)
          .map((e) => AssetTypeAllocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}
