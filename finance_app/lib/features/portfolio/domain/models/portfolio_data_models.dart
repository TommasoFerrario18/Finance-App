import 'package:equatable/equatable.dart';

/// Represents a single point in the net worth time series
class NetWorthDataPoint extends Equatable {
  final DateTime date;
  final double value;

  const NetWorthDataPoint({required this.date, required this.value});

  @override
  List<Object?> get props => [date, value];

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'value': value,
  };

  factory NetWorthDataPoint.fromJson(Map<String, dynamic> json) {
    return NetWorthDataPoint(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
    );
  }
}

/// Represents an asset allocation segment
class AssetAllocation extends Equatable {
  final String assetType;
  final double value;
  final double percentage;

  const AssetAllocation({
    required this.assetType,
    required this.value,
    required this.percentage,
  });

  @override
  List<Object?> get props => [assetType, value, percentage];

  Map<String, dynamic> toJson() => {
    'assetType': assetType,
    'value': value,
    'percentage': percentage,
  };

  factory AssetAllocation.fromJson(Map<String, dynamic> json) {
    return AssetAllocation(
      assetType: json['assetType'] as String,
      value: (json['value'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Represents complete portfolio data
class PortfolioData extends Equatable {
  final List<NetWorthDataPoint> netWorthHistory;
  final List<AssetAllocation> assetAllocations;
  final double currentNetWorth;
  final DateTime lastUpdated;

  const PortfolioData({
    required this.netWorthHistory,
    required this.assetAllocations,
    required this.currentNetWorth,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    netWorthHistory,
    assetAllocations,
    currentNetWorth,
    lastUpdated,
  ];

  Map<String, dynamic> toJson() => {
    'netWorthHistory': netWorthHistory.map((point) => point.toJson()).toList(),
    'assetAllocations': assetAllocations
        .map((allocation) => allocation.toJson())
        .toList(),
    'currentNetWorth': currentNetWorth,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      netWorthHistory: (json['netWorthHistory'] as List)
          .map((e) => NetWorthDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      assetAllocations: (json['assetAllocations'] as List)
          .map((e) => AssetAllocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentNetWorth: (json['currentNetWorth'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Create an empty portfolio
  factory PortfolioData.empty() {
    return PortfolioData(
      netWorthHistory: const [],
      assetAllocations: const [],
      currentNetWorth: 0.0,
      lastUpdated: DateTime.now(),
    );
  }
}

/// Time range filter options
enum TimeRange {
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  threeYears,
  fiveYears,
  all;

  String get label {
    switch (this) {
      case TimeRange.oneMonth:
        return '1M';
      case TimeRange.threeMonths:
        return '3M';
      case TimeRange.sixMonths:
        return '6M';
      case TimeRange.oneYear:
        return '1Y';
      case TimeRange.threeYears:
        return '3Y';
      case TimeRange.fiveYears:
        return '5Y';
      case TimeRange.all:
        return 'All';
    }
  }

  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case TimeRange.oneMonth:
        return DateTime(now.year, now.month - 1, now.day);
      case TimeRange.threeMonths:
        return DateTime(now.year, now.month - 3, now.day);
      case TimeRange.sixMonths:
        return DateTime(now.year, now.month - 6, now.day);
      case TimeRange.oneYear:
        return DateTime(now.year - 1, now.month, now.day);
      case TimeRange.threeYears:
        return DateTime(now.year - 3, now.month, now.day);
      case TimeRange.fiveYears:
        return DateTime(now.year - 5, now.month, now.day);
      case TimeRange.all:
        return DateTime(1900, 1, 1); // Far past date
    }
  }
}

/// Dashboard tab types
enum DashboardTab {
  netWorth,
  assetAllocation;

  String get label {
    switch (this) {
      case DashboardTab.netWorth:
        return 'Net Worth';
      case DashboardTab.assetAllocation:
        return 'Asset Allocation';
    }
  }
}
