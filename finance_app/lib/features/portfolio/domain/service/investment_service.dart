import 'package:drift/drift.dart';
import 'package:finance_app/core/database/app_database.dart';
import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class InvestmentService implements InvestmentRepository {
  final AppDatabase _database;

  InvestmentService({required AppDatabase database}) : _database = database;

  @override
  Future<void> initialize() async {}

  @override
  Future<PortfolioData> getPortfolioData() async {
    final netWorthHistory = await getNetWorthHistory();
    final assetAllocations = await getAssetAllocations();
    final currentNetWorth = await getCurrentNetWorth();

    return PortfolioData(
      netWorthHistory: netWorthHistory,
      assetAllocations: assetAllocations,
      currentNetWorth: currentNetWorth,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<List<NetWorthDataPoint>> getNetWorthHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Get all asset prices with their corresponding positions
    final query = _database.select(_database.assetPrices).join([
      leftOuterJoin(
        _database.assets,
        _database.assets.id.equalsExp(_database.assetPrices.assetId),
      ),
    ]);

    // Apply date filters
    if (startDate != null) {
      query.where(
        _database.assetPrices.priceDate.isBiggerOrEqualValue(startDate),
      );
    }
    if (endDate != null) {
      query.where(
        _database.assetPrices.priceDate.isSmallerOrEqualValue(endDate),
      );
    }

    query.orderBy([OrderingTerm.asc(_database.assetPrices.priceDate)]);

    final results = await query.get();

    // Group by date and calculate total portfolio value for each date
    final Map<DateTime, double> valuesByDate = {};

    for (final row in results) {
      final price = row.readTable(_database.assetPrices);
      final asset = row.readTableOrNull(_database.assets);

      if (asset == null) continue;

      final date = _normalizeDate(price.priceDate);

      // Get position for this asset at this date
      final position = await _getPositionAtDate(asset.id, price.priceDate);
      final value = position * price.closePrice;

      valuesByDate[date] = (valuesByDate[date] ?? 0.0) + value;
    }

    // Convert to list of NetWorthDataPoint
    final dataPoints =
        valuesByDate.entries
            .map(
              (entry) => NetWorthDataPoint(date: entry.key, value: entry.value),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    return dataPoints;
  }

  @override
  Future<List<AssetAllocation>> getAssetAllocations({
    DateTime? asOfDate,
  }) async {
    final effectiveDate = asOfDate ?? DateTime.now();

    // Get all active assets
    final activeAssets = await (_database.select(
      _database.assets,
    )..where((a) => a.isActive.equals(true))).get();

    // Calculate value by asset class
    final Map<String, double> valuesByClass = {};

    for (final asset in activeAssets) {
      if (asset.assetClass == null) continue;

      // Get current position
      final position = await _getPositionAtDate(asset.id, effectiveDate);

      if (position <= 0) continue;

      // Get latest price
      final latestPrice = await _getLatestPrice(asset.id, effectiveDate);

      if (latestPrice == null) continue;

      final value = position * latestPrice;
      valuesByClass[asset.assetClass!] =
          (valuesByClass[asset.assetClass!] ?? 0.0) + value;
    }

    // Calculate total
    final total = valuesByClass.values.fold<double>(
      0.0,
      (sum, value) => sum + value,
    );

    // Convert to AssetAllocation list
    return valuesByClass.entries
        .map(
          (entry) => AssetAllocation(
            assetType: entry.key,
            value: entry.value,
            percentage: total > 0 ? (entry.value / total) * 100 : 0.0,
          ),
        )
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Future<double> getCurrentNetWorth() async {
    // Get all active assets
    final activeAssets = await (_database.select(
      _database.assets,
    )..where((a) => a.isActive.equals(true))).get();

    double totalValue = 0.0;
    final now = DateTime.now();

    for (final asset in activeAssets) {
      // Get current position
      final position = await _getPositionAtDate(asset.id, now);

      if (position <= 0) continue;

      // Get latest price
      final latestPrice = await _getLatestPrice(asset.id, now);

      if (latestPrice == null) continue;

      totalValue += position * latestPrice;
    }

    return totalValue;
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get the position (quantity) of an asset at a specific date
  Future<double> _getPositionAtDate(int assetId, DateTime date) async {
    final transactions =
        await (_database.select(_database.assetTransactions)
              ..where((t) => t.assetId.equals(assetId))
              ..where((t) => t.transactionDate.isSmallerOrEqualValue(date)))
            .get();

    double position = 0.0;

    for (final transaction in transactions) {
      switch (transaction.transactionType) {
        case 'BUY':
        case 'TRANSFER_IN':
          position += transaction.quantity;
          break;
        case 'SELL':
        case 'TRANSFER_OUT':
          position -= transaction.quantity;
          break;
        default:
          break;
      }
    }

    return position;
  }

  /// Get the latest price for an asset on or before a specific date
  Future<double?> _getLatestPrice(int assetId, DateTime date) async {
    final price =
        await (_database.select(_database.assetPrices)
              ..where((p) => p.assetId.equals(assetId))
              ..where((p) => p.priceDate.isSmallerOrEqualValue(date))
              ..orderBy([(p) => OrderingTerm.desc(p.priceDate)])
              ..limit(1))
            .getSingleOrNull();

    return price?.closePrice;
  }

  /// Normalize date to remove time component
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
