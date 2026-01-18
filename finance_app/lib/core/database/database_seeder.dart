import 'package:drift/drift.dart';
import 'package:finance_app/core/database/app_database.dart';

/// Utility class to seed the database with sample data for development/testing
class DatabaseSeeder {
  final AppDatabase _database;

  DatabaseSeeder(this._database);

  /// Seed all tables with sample data
  Future<void> seedAll() async {
    await seedAssets();
    await seedAssetTransactions();
    await seedAssetPrices();
  }

  /// Seed sample assets
  Future<void> seedAssets() async {
    final sampleAssets = [
      AssetsCompanion.insert(
        name: 'Vanguard S&P 500 ETF',
        tickerSymbol: const Value('VOO'),
        assetType: 'ETF',
        assetClass: const Value('EQUITIES'),
        currency: const Value('USD'),
        description: const Value('Tracks the S&P 500 index'),
      ),
      AssetsCompanion.insert(
        name: 'iShares Core MSCI World',
        tickerSymbol: const Value('IWDA'),
        assetType: 'ETF',
        assetClass: const Value('EQUITIES'),
        currency: const Value('EUR'),
        description: const Value('Global equity exposure'),
      ),
      AssetsCompanion.insert(
        name: 'US Treasury Bond',
        tickerSymbol: const Value('TLT'),
        assetType: 'BOND',
        assetClass: const Value('FIXED_INCOME'),
        currency: const Value('USD'),
        description: const Value('20+ Year Treasury Bond ETF'),
      ),
      AssetsCompanion.insert(
        name: 'Bitcoin',
        tickerSymbol: const Value('BTC'),
        assetType: 'CRYPTO',
        assetClass: const Value('CRYPTO'),
        currency: const Value('USD'),
        description: const Value('Bitcoin cryptocurrency'),
      ),
      AssetsCompanion.insert(
        name: 'Rental Property - Rome',
        assetType: 'REAL_ESTATE',
        assetClass: const Value('REAL_ESTATE'),
        currency: const Value('EUR'),
        description: const Value('Apartment in Rome city center'),
      ),
    ];

    for (final asset in sampleAssets) {
      await _database
          .into(_database.assets)
          .insert(asset, mode: InsertMode.insertOrIgnore);
    }
  }

  /// Seed sample transactions
  Future<void> seedAssetTransactions() async {
    final now = DateTime.now();

    // Get asset IDs
    final vooAsset = await (_database.select(
      _database.assets,
    )..where((a) => a.tickerSymbol.equals('VOO'))).getSingleOrNull();

    final iwdaAsset = await (_database.select(
      _database.assets,
    )..where((a) => a.tickerSymbol.equals('IWDA'))).getSingleOrNull();

    final btcAsset = await (_database.select(
      _database.assets,
    )..where((a) => a.tickerSymbol.equals('BTC'))).getSingleOrNull();

    if (vooAsset != null) {
      // Simulate buying VOO over time
      final transactions = [
        AssetTransactionsCompanion.insert(
          assetId: vooAsset.id,
          transactionDate: DateTime(now.year - 5, now.month, now.day),
          transactionType: 'BUY',
          quantity: 10.0,
          pricePerUnit: 250.0,
          totalCost: 2500.0,
          fees: const Value(9.95),
        ),
        AssetTransactionsCompanion.insert(
          assetId: vooAsset.id,
          transactionDate: DateTime(now.year - 3, now.month, now.day),
          transactionType: 'BUY',
          quantity: 15.0,
          pricePerUnit: 300.0,
          totalCost: 4500.0,
          fees: const Value(9.95),
        ),
        AssetTransactionsCompanion.insert(
          assetId: vooAsset.id,
          transactionDate: DateTime(now.year - 1, now.month, now.day),
          transactionType: 'BUY',
          quantity: 20.0,
          pricePerUnit: 380.0,
          totalCost: 7600.0,
          fees: const Value(9.95),
        ),
      ];

      for (final transaction in transactions) {
        await _database
            .into(_database.assetTransactions)
            .insert(transaction, mode: InsertMode.insertOrIgnore);
      }
    }

    if (iwdaAsset != null) {
      final transactions = [
        AssetTransactionsCompanion.insert(
          assetId: iwdaAsset.id,
          transactionDate: DateTime(now.year - 4, now.month, now.day),
          transactionType: 'BUY',
          quantity: 50.0,
          pricePerUnit: 60.0,
          totalCost: 3000.0,
          fees: const Value(9.95),
        ),
        AssetTransactionsCompanion.insert(
          assetId: iwdaAsset.id,
          transactionDate: DateTime(now.year - 2, now.month, now.day),
          transactionType: 'BUY',
          quantity: 30.0,
          pricePerUnit: 70.0,
          totalCost: 2100.0,
          fees: const Value(9.95),
        ),
      ];

      for (final transaction in transactions) {
        await _database
            .into(_database.assetTransactions)
            .insert(transaction, mode: InsertMode.insertOrIgnore);
      }
    }

    if (btcAsset != null) {
      final transactions = [
        AssetTransactionsCompanion.insert(
          assetId: btcAsset.id,
          transactionDate: DateTime(now.year - 3, now.month, now.day),
          transactionType: 'BUY',
          quantity: 0.5,
          pricePerUnit: 30000.0,
          totalCost: 15000.0,
          fees: const Value(50.0),
        ),
        AssetTransactionsCompanion.insert(
          assetId: btcAsset.id,
          transactionDate: DateTime(now.year - 1, now.month, now.day),
          transactionType: 'BUY',
          quantity: 0.25,
          pricePerUnit: 40000.0,
          totalCost: 10000.0,
          fees: const Value(50.0),
        ),
      ];

      for (final transaction in transactions) {
        await _database
            .into(_database.assetTransactions)
            .insert(transaction, mode: InsertMode.insertOrIgnore);
      }
    }
  }

  /// Seed historical prices for assets
  Future<void> seedAssetPrices() async {
    final now = DateTime.now();

    // Get all assets
    final assets = await _database.select(_database.assets).get();

    for (final asset in assets) {
      // Generate monthly prices for the past 5 years
      for (int monthsAgo = 60; monthsAgo >= 0; monthsAgo--) {
        final date = DateTime(
          now.year,
          now.month - monthsAgo,
          1, // First day of month
        );

        double price;

        // Generate realistic price based on asset type
        switch (asset.tickerSymbol) {
          case 'VOO':
            price =
                250.0 + (60 - monthsAgo) * 3.5; // Growing from $250 to ~$460
            break;
          case 'IWDA':
            price = 60.0 + (60 - monthsAgo) * 0.5; // Growing from €60 to €90
            break;
          case 'TLT':
            price = 140.0 - (60 - monthsAgo) * 0.3; // Declining bond prices
            break;
          case 'BTC':
            // More volatile
            final base = 20000.0;
            final growth = (60 - monthsAgo) * 500;
            final volatility = (monthsAgo % 3 == 0)
                ? -2000
                : (monthsAgo % 3 == 1)
                ? 3000
                : 0;
            price = base + growth + volatility;
            break;
          default:
            // Real estate - slow steady growth
            price = 200000.0 + (60 - monthsAgo) * 200;
        }

        // Add some randomness
        final variance = (monthsAgo % 7) * 0.02 - 0.07; // -7% to +7%
        price = price * (1 + variance);

        await _database
            .into(_database.assetPrices)
            .insert(
              AssetPricesCompanion.insert(
                assetId: asset.id,
                priceDate: date,
                closePrice: price,
                currency: Value(asset.currency),
                source: const Value('SEEDED'),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
    }
  }

  /// Clear all data (useful for testing)
  Future<void> clearAll() async {
    await _database.delete(_database.assetPrices).go();
    await _database.delete(_database.assetTransactions).go();
    await _database.delete(_database.budgets).go();
    await _database.delete(_database.expenses).go();
    await _database.delete(_database.monthlyIncome).go();
    await _database.delete(_database.assets).go();
    // Don't delete expense categories as they're defaults
  }

  /// Check if database has any data
  Future<bool> hasData() async {
    final assetCount = await (_database.select(
      _database.assets,
    )..limit(1)).get();
    return assetCount.isNotEmpty;
  }
}
