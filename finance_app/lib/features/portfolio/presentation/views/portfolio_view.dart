import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/portfolio_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<PortfolioViewModel>()..loadPortfolio(),
      child: Consumer<PortfolioViewModel>(
        builder: (context, viewModel, child) {
          return FeatureScaffold(
            title: 'Portfolio',
            child: _buildContent(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PortfolioViewModel viewModel) {
    // Show loading state
    if (viewModel.isLoading && viewModel.portfolioData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (viewModel.hasError && viewModel.portfolioData == null) {
      return _buildErrorState(context, viewModel);
    }

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

    // Fallback empty state
    return _buildEmptyState(context);
  }

  Widget _buildErrorState(BuildContext context, PortfolioViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('Error', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'An unexpected error occurred',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: viewModel.loadPortfolio,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
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
