import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class InvestmentRepositoryImpl implements InvestmentRepository {
  @override
  Future<void> initialize() async {
    // Placeholder for initialization logic
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<PortfolioData> getPortfolioData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock data
    return PortfolioData(
      netWorthHistory: _generateMockNetWorthHistory(),
      assetAllocations: _generateMockAssetAllocations(),
      currentNetWorth: 125000.00,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<List<NetWorthDataPoint>> getNetWorthHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allHistory = _generateMockNetWorthHistory();

    if (startDate == null && endDate == null) {
      return allHistory;
    }

    return allHistory.where((point) {
      if (startDate != null && point.date.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && point.date.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<AssetAllocation>> getAssetAllocations({
    DateTime? asOfDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _generateMockAssetAllocations();
  }

  @override
  Future<double> getCurrentNetWorth() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 125000.00;
  }

  /// Generate mock net worth history data for the past 5 years
  List<NetWorthDataPoint> _generateMockNetWorthHistory() {
    final now = DateTime.now();
    final fiveYearsAgo = DateTime(now.year - 5, now.month, now.day);
    final dataPoints = <NetWorthDataPoint>[];

    double baseValue = 50000.0;
    DateTime currentDate = fiveYearsAgo;

    // Generate monthly data points
    while (currentDate.isBefore(now)) {
      // Add some realistic growth and volatility
      final monthsFromStart = currentDate.difference(fiveYearsAgo).inDays / 30;
      final growth = monthsFromStart * 300; // ~3600 per year growth
      final volatility =
          (monthsFromStart % 12) * 200 - 1000; // Seasonal variation

      dataPoints.add(
        NetWorthDataPoint(
          date: currentDate,
          value: baseValue + growth + volatility,
        ),
      );

      // Move to next month
      currentDate = DateTime(
        currentDate.year,
        currentDate.month + 1,
        currentDate.day,
      );
    }

    return dataPoints;
  }

  /// Generate mock asset allocation data
  List<AssetAllocation> _generateMockAssetAllocations() {
    const totalValue = 125000.0;

    return [
      const AssetAllocation(
        assetType: 'Stocks',
        value: 62500.0,
        percentage: 50.0,
      ),
      const AssetAllocation(
        assetType: 'Bonds',
        value: 25000.0,
        percentage: 20.0,
      ),
      const AssetAllocation(
        assetType: 'Real Estate',
        value: 18750.0,
        percentage: 15.0,
      ),
      const AssetAllocation(
        assetType: 'Cash',
        value: 12500.0,
        percentage: 10.0,
      ),
      const AssetAllocation(
        assetType: 'Crypto',
        value: 6250.0,
        percentage: 5.0,
      ),
    ];
  }
}
