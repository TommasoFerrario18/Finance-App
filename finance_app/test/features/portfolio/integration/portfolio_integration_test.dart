import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/portfolio_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

@GenerateMocks([InvestmentRepository])
import 'portfolio_integration_test.mocks.dart';

void main() {
  group('Portfolio Integration Tests', () {
    late MockInvestmentRepository mockRepository;
    late PortfolioViewModel viewModel;

    final mockPortfolioData = PortfolioData(
      netWorthHistory: [
        NetWorthDataPoint(date: DateTime(2024, 1, 1), value: 100000.0),
        NetWorthDataPoint(date: DateTime(2024, 6, 1), value: 110000.0),
        NetWorthDataPoint(date: DateTime(2025, 1, 1), value: 120000.0),
      ],
      assetAllocations: const [
        AssetAllocation(assetType: 'Stocks', value: 60000.0, percentage: 50.0),
        AssetAllocation(assetType: 'Bonds', value: 40000.0, percentage: 33.33),
        AssetAllocation(assetType: 'Cash', value: 20000.0, percentage: 16.67),
      ],
      currentNetWorth: 120000.0,
      lastUpdated: DateTime(2025, 1, 1),
    );

    setUp(() {
      mockRepository = MockInvestmentRepository();
      viewModel = PortfolioViewModel(repository: mockRepository);

      when(mockRepository.initialize()).thenAnswer((_) async => {});
      when(
        mockRepository.getPortfolioData(),
      ).thenAnswer((_) async => mockPortfolioData);
    });

    tearDown(() {
      viewModel.dispose();
    });

    testWidgets('should display dashboard with tabs', (tester) async {
      // Arrange
      await viewModel.loadPortfolio();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: viewModel,
              child: Consumer<PortfolioViewModel>(
                builder: (context, vm, _) {
                  return PortfolioDashboard(
                    selectedTab: vm.selectedTab,
                    onTabChanged: vm.setSelectedTab,
                    selectedTimeRange: vm.selectedTimeRange,
                    onTimeRangeChanged: vm.setTimeRange,
                    netWorthHistory: vm.filteredNetWorthHistory,
                    assetAllocations: vm.assetAllocations,
                    onRefresh: vm.refresh,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Check tabs are present
      expect(find.text('Net Worth'), findsOneWidget);
      expect(find.text('Asset Allocation'), findsOneWidget);
    });

    testWidgets('should switch between tabs', (tester) async {
      // Arrange
      await viewModel.loadPortfolio();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: viewModel,
              child: Consumer<PortfolioViewModel>(
                builder: (context, vm, _) {
                  return PortfolioDashboard(
                    selectedTab: vm.selectedTab,
                    onTabChanged: vm.setSelectedTab,
                    selectedTimeRange: vm.selectedTimeRange,
                    onTimeRangeChanged: vm.setTimeRange,
                    netWorthHistory: vm.filteredNetWorthHistory,
                    assetAllocations: vm.assetAllocations,
                    onRefresh: vm.refresh,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap on Asset Allocation tab
      await tester.tap(find.text('Asset Allocation'));
      await tester.pumpAndSettle();

      // Assert - Verify tab changed
      expect(viewModel.selectedTab, DashboardTab.assetAllocation);
    });

    testWidgets('should change time range filter', (tester) async {
      // Arrange
      await viewModel.loadPortfolio();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: viewModel,
              child: Consumer<PortfolioViewModel>(
                builder: (context, vm, _) {
                  return PortfolioDashboard(
                    selectedTab: vm.selectedTab,
                    onTabChanged: vm.setSelectedTab,
                    selectedTimeRange: vm.selectedTimeRange,
                    onTimeRangeChanged: vm.setTimeRange,
                    netWorthHistory: vm.filteredNetWorthHistory,
                    assetAllocations: vm.assetAllocations,
                    onRefresh: vm.refresh,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Act - Tap on 3M time range
      await tester.tap(find.text('3M'));
      await tester.pumpAndSettle();

      // Assert - Verify time range changed
      expect(viewModel.selectedTimeRange, TimeRange.threeMonths);
    });

    testWidgets('should handle pull to refresh', (tester) async {
      // Arrange
      await viewModel.loadPortfolio();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider.value(
              value: viewModel,
              child: Consumer<PortfolioViewModel>(
                builder: (context, vm, _) {
                  return PortfolioDashboard(
                    selectedTab: vm.selectedTab,
                    onTabChanged: vm.setSelectedTab,
                    selectedTimeRange: vm.selectedTimeRange,
                    onTimeRangeChanged: vm.setTimeRange,
                    netWorthHistory: vm.filteredNetWorthHistory,
                    assetAllocations: vm.assetAllocations,
                    onRefresh: vm.refresh,
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Reset mock call count
      reset(mockRepository);
      when(
        mockRepository.getPortfolioData(),
      ).thenAnswer((_) async => mockPortfolioData);

      // Act - Perform pull to refresh
      await tester.fling(
        find.byType(RefreshIndicator),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Assert - Verify refresh was called
      verify(mockRepository.getPortfolioData()).called(1);
    });
  });
}
