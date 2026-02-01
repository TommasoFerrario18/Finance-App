import 'package:finance_app/features/portfolio/data/datasources/portfolio_mock_data.dart';
import 'package:finance_app/features/portfolio/domain/models/investment_models.dart';
import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class PortfolioRepositoryImpl implements InvestmentRepository {
  @override
  Future<void> initialize() async {
    // Placeholder for initialization logic
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<PortfolioData> getPortfolioData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final summary = PortfolioMockData.getPortfolioSummary();
    
    // Convert to PortfolioData (creating empty history for now)
    return PortfolioData(
      netWorthHistory: _generateMockNetWorthHistory(),
      assetAllocations: _convertToAssetAllocations(summary.assetAllocations),
      currentNetWorth: summary.totalValue,
      lastUpdated: summary.lastUpdated,
    );
  }

  @override
  Future<List<NetWorthDataPoint>> getNetWorthHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _generateMockNetWorthHistory();
  }

  @override
  Future<List<AssetAllocation>> getAssetAllocations({
    DateTime? asOfDate,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    final summary = PortfolioMockData.getPortfolioSummary();
    return _convertToAssetAllocations(summary.assetAllocations);
  }

  @override
  Future<double> getCurrentNetWorth() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    final summary = PortfolioMockData.getPortfolioSummary();
    return summary.totalValue;
  }

  /// Generate mock net worth history data
  List<NetWorthDataPoint> _generateMockNetWorthHistory() {
    final now = DateTime.now();
    final dataPoints = <NetWorthDataPoint>[];
    
    // Generate 12 months of data
    for (int i = 11; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      // Simulate growing portfolio with some variance
      final baseValue = 100000.0;
      final growthFactor = (12 - i) * 500.0;
      final variance = (i % 3) * 1000.0;
      final value = baseValue + growthFactor + variance;
      
      dataPoints.add(NetWorthDataPoint(date: date, value: value));
    }
    
    return dataPoints;
  }

  /// Convert AssetTypeAllocation to AssetAllocation
  List<AssetAllocation> _convertToAssetAllocations(
    List<AssetTypeAllocation> allocations,
  ) {
    return allocations
        .map((allocation) => AssetAllocation(
          assetType: allocation.assetType.label,
          value: allocation.totalValue,
          percentage: allocation.percentage,
        ))
        .toList();
  }
}
