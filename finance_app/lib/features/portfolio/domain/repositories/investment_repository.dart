import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';

abstract class InvestmentRepository {
  Future<void> initialize();

  /// Fetch complete portfolio data
  Future<PortfolioData> getPortfolioData();

  /// Fetch net worth history within a date range
  Future<List<NetWorthDataPoint>> getNetWorthHistory({
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Fetch asset allocations at a specific date
  Future<List<AssetAllocation>> getAssetAllocations({DateTime? asOfDate});

  /// Get current total net worth
  Future<double> getCurrentNetWorth();
}
