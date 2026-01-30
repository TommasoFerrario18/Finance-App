import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class PortfolioViewModel extends BaseViewModel {
  final InvestmentRepository repository;

  PortfolioViewModel({required this.repository});

  // State
  PortfolioData? _portfolioData;
  TimeRange _selectedTimeRange = TimeRange.oneYear;
  DashboardTab _selectedTab = DashboardTab.netWorth;
  List<NetWorthDataPoint> _filteredNetWorthHistory = [];

  // Getters
  PortfolioData? get portfolioData => _portfolioData;
  TimeRange get selectedTimeRange => _selectedTimeRange;
  DashboardTab get selectedTab => _selectedTab;
  List<NetWorthDataPoint> get filteredNetWorthHistory =>
      _filteredNetWorthHistory;
  List<AssetAllocation> get assetAllocations =>
      _portfolioData?.assetAllocations ?? [];
  double get currentNetWorth => _portfolioData?.currentNetWorth ?? 0.0;

  @override
  Future<void> init() => loadPortfolio();

  /// Load initial portfolio data
  Future<void> loadPortfolio() async {
    await executeAsync(() async {
      await repository.initialize();
      _portfolioData = await repository.getPortfolioData();
      await _applyTimeRangeFilter();
      notifyListeners();
    });
  }

  /// Change the selected time range and filter data
  Future<void> setTimeRange(TimeRange timeRange) async {
    if (_selectedTimeRange == timeRange) return;

    _selectedTimeRange = timeRange;
    await _applyTimeRangeFilter();
    // Single notification after filtering is complete
    notifyListeners();
  }

  /// Change the selected dashboard tab
  void setSelectedTab(DashboardTab tab) {
    if (_selectedTab == tab) return;

    _selectedTab = tab;
    notifyListeners();
  }

  /// Apply time range filter to net worth history
  Future<void> _applyTimeRangeFilter() async {
    if (_portfolioData == null) {
      _filteredNetWorthHistory = [];
      return;
    }

    final startDate = _selectedTimeRange.getStartDate();

    _filteredNetWorthHistory = _portfolioData!.netWorthHistory
        .where((point) => point.date.isAfter(startDate))
        .toList();

    // Don't notify here - let the caller handle notification
  }

  /// Refresh portfolio data
  Future<void> refresh() async {
    await executeAsync(() async {
      _portfolioData = await repository.getPortfolioData();
      await _applyTimeRangeFilter();
      // Single notification after all updates
      notifyListeners();
    }, showLoading: false);
  }

  /// Get the percentage change for the selected time period
  double getPercentageChange() {
    if (_filteredNetWorthHistory.isEmpty ||
        _filteredNetWorthHistory.length < 2) {
      return 0.0;
    }

    final firstValue = _filteredNetWorthHistory.first.value;
    final lastValue = _filteredNetWorthHistory.last.value;

    if (firstValue == 0) return 0.0;

    return ((lastValue - firstValue) / firstValue) * 100;
  }

  /// Get the absolute change for the selected time period
  double getAbsoluteChange() {
    if (_filteredNetWorthHistory.isEmpty ||
        _filteredNetWorthHistory.length < 2) {
      return 0.0;
    }

    return _filteredNetWorthHistory.last.value -
        _filteredNetWorthHistory.first.value;
  }
}
