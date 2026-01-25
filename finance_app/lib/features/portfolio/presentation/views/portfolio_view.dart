import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/base_feature_view.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/portfolio_dashboard.dart';
import 'package:flutter/material.dart';

class PortfolioView extends BaseFeatureView<PortfolioViewModel> {
  const PortfolioView({super.key});

  @override
  String get title => 'Portfolio';

  @override
  PortfolioViewModel createViewModel() => getIt<PortfolioViewModel>();

  @override
  Widget buildContent(BuildContext context, PortfolioViewModel viewModel) {
    // Show dashboard with data
    if (viewModel.portfolioData != null) {
      return PortfolioDashboard(
        selectedTab: viewModel.selectedTab,
        onTabChanged: viewModel.setSelectedTab,
        selectedTimeRange: viewModel.selectedTimeRange,
        onTimeRangeChanged: viewModel.setTimeRange,
        netWorthHistory: viewModel.filteredNetWorthHistory,
        assetAllocations: viewModel.assetAllocations,
        onRefresh: viewModel.refresh,
      );
    }

    // Fallback empty state when no data available
    return _buildEmptyState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Portfolio Data',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your investments',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
