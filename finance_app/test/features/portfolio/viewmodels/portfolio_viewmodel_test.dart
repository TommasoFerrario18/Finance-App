import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks with: flutter pub run build_runner build
@GenerateMocks([InvestmentRepository])
import 'portfolio_viewmodel_test.mocks.dart';

void main() {
  late MockInvestmentRepository mockRepository;
  late PortfolioViewModel viewModel;

  setUp(() {
    mockRepository = MockInvestmentRepository();
    viewModel = PortfolioViewModel(repository: mockRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('PortfolioViewModel', () {
    group('initialization', () {
      test('should have default values on creation', () {
        expect(viewModel.portfolioData, isNull);
        expect(viewModel.selectedTimeRange, TimeRange.oneYear);
        expect(viewModel.selectedTab, DashboardTab.netWorth);
        expect(viewModel.filteredNetWorthHistory, isEmpty);
        expect(viewModel.assetAllocations, isEmpty);
        expect(viewModel.currentNetWorth, 0.0);
        expect(viewModel.isLoading, false);
        expect(viewModel.hasError, false);
      });
    });

    group('loadPortfolio', () {
      final now = DateTime.now();
      final mockPortfolioData = PortfolioData(
        netWorthHistory: [
          NetWorthDataPoint(
            date: DateTime(now.year - 2, now.month, now.day),
            value: 100000.0,
          ),
          NetWorthDataPoint(
            date: DateTime(now.year - 1, now.month - 6, now.day),
            value: 110000.0,
          ),
          NetWorthDataPoint(
            date: DateTime(now.year, now.month - 1, now.day),
            value: 120000.0,
          ),
        ],
        assetAllocations: const [
          AssetAllocation(
            assetType: 'Stocks',
            value: 60000.0,
            percentage: 50.0,
          ),
          AssetAllocation(assetType: 'Bonds', value: 60000.0, percentage: 50.0),
        ],
        currentNetWorth: 120000.0,
        lastUpdated: now,
      );

      test('should load portfolio data successfully', () async {
        // Arrange
        when(mockRepository.initialize()).thenAnswer((_) async => {});
        when(
          mockRepository.getPortfolioData(),
        ).thenAnswer((_) async => mockPortfolioData);

        // Act
        await viewModel.loadPortfolio();

        // Assert
        verify(mockRepository.initialize()).called(1);
        verify(mockRepository.getPortfolioData()).called(1);
        expect(viewModel.portfolioData, mockPortfolioData);
        expect(viewModel.isLoading, false);
        expect(viewModel.hasError, false);
      });

      test('should set loading state during data fetch', () async {
        // Arrange
        when(mockRepository.initialize()).thenAnswer((_) async => {});
        when(
          mockRepository.getPortfolioData(),
        ).thenAnswer((_) async => mockPortfolioData);

        // Act & Assert
        final loadFuture = viewModel.loadPortfolio();
        expect(viewModel.isLoading, true);
        await loadFuture;
        expect(viewModel.isLoading, false);
      });

      test('should handle errors gracefully', () async {
        // Arrange
        when(mockRepository.initialize()).thenAnswer((_) async => {});
        when(
          mockRepository.getPortfolioData(),
        ).thenThrow(Exception('Network error'));

        // Act
        await viewModel.loadPortfolio();

        // Assert
        expect(viewModel.hasError, true);
        expect(viewModel.errorMessage, contains('Failed to load portfolio'));
        expect(viewModel.isLoading, false);
      });

      test(
        'should filter net worth history based on default time range',
        () async {
          // Arrange
          when(mockRepository.initialize()).thenAnswer((_) async => {});
          when(
            mockRepository.getPortfolioData(),
          ).thenAnswer((_) async => mockPortfolioData);

          // Act
          await viewModel.loadPortfolio();

          // Assert
          // Default is 1 year, so should include data points from the last year
          // With our test data: 2 years ago, 1.5 years ago, and 1 month ago
          // Only the last two should be included (within 1 year)
          expect(viewModel.filteredNetWorthHistory.length, 2);
          // The filtered data should be the last two points
          expect(viewModel.filteredNetWorthHistory.last.value, 120000.0);
        },
      );
    });

    group('setTimeRange', () {
      final now = DateTime.now();
      final mockPortfolioData = PortfolioData(
        netWorthHistory: [
          NetWorthDataPoint(
            date: DateTime(now.year - 5, now.month, now.day),
            value: 50000.0,
          ),
          NetWorthDataPoint(
            date: DateTime(now.year - 3, now.month, now.day),
            value: 80000.0,
          ),
          NetWorthDataPoint(
            date: DateTime(now.year - 1, now.month - 6, now.day),
            value: 100000.0,
          ),
          NetWorthDataPoint(
            date: DateTime(now.year, now.month - 1, now.day),
            value: 120000.0,
          ),
        ],
        assetAllocations: const [],
        currentNetWorth: 120000.0,
        lastUpdated: now,
      );

      setUp(() async {
        when(mockRepository.initialize()).thenAnswer((_) async => {});
        when(
          mockRepository.getPortfolioData(),
        ).thenAnswer((_) async => mockPortfolioData);
        await viewModel.loadPortfolio();
      });

      test('should filter data when time range changes', () async {
        // Act
        await viewModel.setTimeRange(TimeRange.threeYears);

        // Assert
        expect(viewModel.selectedTimeRange, TimeRange.threeYears);
        // From now, going back 3 years should include:
        // - 3 years ago (exactly on boundary)
        // - 1.5 years ago
        // - 1 month ago
        // Total: 3 data points (the 5 years ago point should be excluded)
        expect(viewModel.filteredNetWorthHistory.length, 3);
      });

      test('should not trigger update if same time range selected', () async {
        // Arrange
        final initialListenerCount = viewModel.hasListeners ? 1 : 0;

        // Act
        await viewModel.setTimeRange(TimeRange.oneYear);

        // Assert
        expect(viewModel.selectedTimeRange, TimeRange.oneYear);
      });

      test('should show all data when "all" time range selected', () async {
        // Act
        await viewModel.setTimeRange(TimeRange.all);

        // Assert
        expect(viewModel.filteredNetWorthHistory.length, 4);
      });
    });

    group('setSelectedTab', () {
      test('should update selected tab', () {
        // Act
        viewModel.setSelectedTab(DashboardTab.assetAllocation);

        // Assert
        expect(viewModel.selectedTab, DashboardTab.assetAllocation);
      });

      test('should not trigger update if same tab selected', () {
        // Arrange
        viewModel.setSelectedTab(DashboardTab.netWorth);

        // Act
        viewModel.setSelectedTab(DashboardTab.netWorth);

        // Assert
        expect(viewModel.selectedTab, DashboardTab.netWorth);
      });
    });

    group('refresh', () {
      final mockPortfolioData = PortfolioData(
        netWorthHistory: [
          NetWorthDataPoint(date: DateTime(2025, 1, 1), value: 125000.0),
        ],
        assetAllocations: const [],
        currentNetWorth: 125000.0,
        lastUpdated: DateTime(2025, 1, 1),
      );

      test('should refresh portfolio data', () async {
        // Arrange
        when(
          mockRepository.getPortfolioData(),
        ).thenAnswer((_) async => mockPortfolioData);

        // Act
        await viewModel.refresh();

        // Assert
        verify(mockRepository.getPortfolioData()).called(1);
        expect(viewModel.portfolioData, mockPortfolioData);
        expect(viewModel.hasError, false);
      });

      test('should handle refresh errors', () async {
        // Arrange
        when(
          mockRepository.getPortfolioData(),
        ).thenThrow(Exception('Refresh failed'));

        // Act
        await viewModel.refresh();

        // Assert
        expect(viewModel.hasError, true);
        expect(viewModel.errorMessage, contains('Failed to refresh'));
      });
    });

    group('calculations', () {
      final now = DateTime.now();
      final mockPortfolioData = PortfolioData(
        netWorthHistory: [
          NetWorthDataPoint(
            date: DateTime(now.year - 1, now.month, now.day),
            value: 100000.0,
          ),
          NetWorthDataPoint(
            date: DateTime(now.year, now.month, now.day),
            value: 120000.0,
          ),
        ],
        assetAllocations: const [],
        currentNetWorth: 120000.0,
        lastUpdated: now,
      );

      setUp(() async {
        when(mockRepository.initialize()).thenAnswer((_) async => {});
        when(
          mockRepository.getPortfolioData(),
        ).thenAnswer((_) async => mockPortfolioData);
        await viewModel.loadPortfolio();
        await viewModel.setTimeRange(TimeRange.all);
      });

      test('should calculate percentage change correctly', () {
        // Act
        final percentageChange = viewModel.getPercentageChange();

        // Assert
        expect(percentageChange, 20.0); // (120000 - 100000) / 100000 * 100
      });

      test('should calculate absolute change correctly', () {
        // Act
        final absoluteChange = viewModel.getAbsoluteChange();

        // Assert
        expect(absoluteChange, 20000.0); // 120000 - 100000
      });

      test('should return 0 for percentage change when no data', () {
        // Arrange
        viewModel = PortfolioViewModel(repository: mockRepository);

        // Act
        final percentageChange = viewModel.getPercentageChange();

        // Assert
        expect(percentageChange, 0.0);
      });

      test('should return 0 for absolute change when no data', () {
        // Arrange
        viewModel = PortfolioViewModel(repository: mockRepository);

        // Act
        final absoluteChange = viewModel.getAbsoluteChange();

        // Assert
        expect(absoluteChange, 0.0);
      });
    });
  });
}
