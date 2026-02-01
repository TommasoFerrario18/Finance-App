import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/asset_allocation_chart.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/net_worth_chart.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';

/// Main dashboard container that handles tab navigation and filtering
class PortfolioDashboard extends StatefulWidget {
  final DashboardTab selectedTab;
  final ValueChanged<DashboardTab> onTabChanged;
  final TimeRange selectedTimeRange;
  final ValueChanged<TimeRange> onTimeRangeChanged;
  final List<NetWorthDataPoint> netWorthHistory;
  final List<AssetAllocation> assetAllocations;
  final VoidCallback onRefresh;

  const PortfolioDashboard({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.selectedTimeRange,
    required this.onTimeRangeChanged,
    required this.netWorthHistory,
    required this.assetAllocations,
    required this.onRefresh,
  });

  @override
  State<PortfolioDashboard> createState() => _PortfolioDashboardState();
}

class _PortfolioDashboardState extends State<PortfolioDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: DashboardTab.values.length,
      vsync: this,
      initialIndex: widget.selectedTab.index,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(PortfolioDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTab != oldWidget.selectedTab) {
      _tabController.animateTo(widget.selectedTab.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      widget.onTabChanged(DashboardTab.values[_tabController.index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(context),
        TimeRangeSelector(
          selectedTimeRange: widget.selectedTimeRange,
          onTimeRangeChanged: widget.onTimeRangeChanged,
        ),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              RefreshIndicator(
                onRefresh: () async => widget.onRefresh(),
                child: NetWorthChart(
                  dataPoints: widget.netWorthHistory,
                  timeRange: widget.selectedTimeRange,
                ),
              ),
              RefreshIndicator(
                onRefresh: () async => widget.onRefresh(),
                child: AssetAllocationChart(
                  allocations: widget.assetAllocations,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: DashboardTab.values.map((tab) {
          return Tab(text: tab.label);
        }).toList(),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
