import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ============================================================================
// TABLE DEFINITIONS
// ============================================================================

/// Assets table - stores investment assets (stocks, bonds, ETFs, etc.)
class Assets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get tickerSymbol => text().withLength(max: 20).nullable()();
  TextColumn get assetType => text().withLength(max: 50)();
  TextColumn get assetClass => text().withLength(max: 50).nullable()();
  TextColumn get currency =>
      text().withLength(max: 3).withDefault(const Constant('EUR'))();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {tickerSymbol},
  ];
}

/// Asset Transactions - buy/sell history
class AssetTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assetId =>
      integer().references(Assets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get transactionType => text().withLength(max: 20)();
  RealColumn get quantity => real()();
  RealColumn get pricePerUnit => real()();
  RealColumn get totalCost => real()();
  RealColumn get fees => real().withDefault(const Constant(0.0))();
  TextColumn get currency =>
      text().withLength(max: 3).withDefault(const Constant('EUR'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Asset Prices - historical market prices
class AssetPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assetId =>
      integer().references(Assets, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get priceDate => dateTime()();
  RealColumn get closePrice => real()();
  TextColumn get currency =>
      text().withLength(max: 3).withDefault(const Constant('EUR'))();
  TextColumn get source =>
      text().withLength(max: 50).withDefault(const Constant('MANUAL'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {assetId, priceDate},
  ];
}

/// Expense Categories
class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  IntColumn get parentId => integer().nullable().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get icon => text().withLength(max: 50).nullable()();
  TextColumn get color =>
      text().withLength(max: 7).withDefault(const Constant('#FF6B6B'))();
  RealColumn get monthlyBudget => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Expenses
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get transactionDate => dateTime()();
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get subcategory => text().withLength(max: 100).nullable()();
  TextColumn get merchant => text().withLength(max: 200).nullable()();
  TextColumn get location => text().withLength(max: 200).nullable()();
  TextColumn get paymentMethod =>
      text().withLength(max: 50).withDefault(const Constant('Cash'))();
  TextColumn get description => text().nullable()();
  TextColumn get tags => text().nullable()(); // JSON array as string
  TextColumn get receiptPath => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringInterval => text().withLength(max: 20).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Monthly Income
class MonthlyIncome extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get month => dateTime().unique()();
  RealColumn get salary => real().withDefault(const Constant(0.0))();
  RealColumn get investmentIncome => real().withDefault(const Constant(0.0))();
  RealColumn get rentalIncome => real().withDefault(const Constant(0.0))();
  RealColumn get businessIncome => real().withDefault(const Constant(0.0))();
  RealColumn get otherIncome => real().withDefault(const Constant(0.0))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Budgets
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(
    ExpenseCategories,
    #id,
    onDelete: KeyAction.cascade,
  )();
  DateTimeColumn get month => dateTime()();
  RealColumn get amount => real()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {categoryId, month},
  ];
}

// ============================================================================
// DATABASE CLASS
// ============================================================================

@DriftDatabase(
  tables: [
    Assets,
    AssetTransactions,
    AssetPrices,
    ExpenseCategories,
    Expenses,
    MonthlyIncome,
    Budgets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();

        // Insert default expense categories
        await _insertDefaultCategories();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future migrations here
      },
    );
  }

  Future<void> _insertDefaultCategories() async {
    final defaultCategories = [
      ExpenseCategoriesCompanion.insert(
        name: 'Food & Dining',
        icon: const Value('🍔'),
        color: const Value('#FF6B6B'),
        sortOrder: const Value(1),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Transportation',
        icon: const Value('🚗'),
        color: const Value('#4ECDC4'),
        sortOrder: const Value(2),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Shopping',
        icon: const Value('🛍️'),
        color: const Value('#95E1D3'),
        sortOrder: const Value(3),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Entertainment',
        icon: const Value('🎬'),
        color: const Value('#F38181'),
        sortOrder: const Value(4),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Bills & Utilities',
        icon: const Value('📱'),
        color: const Value('#AA96DA'),
        sortOrder: const Value(5),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Healthcare',
        icon: const Value('⚕️'),
        color: const Value('#FCBAD3'),
        sortOrder: const Value(6),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Education',
        icon: const Value('📚'),
        color: const Value('#A8D8EA'),
        sortOrder: const Value(7),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Personal Care',
        icon: const Value('💅'),
        color: const Value('#FFCCE7'),
        sortOrder: const Value(8),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Travel',
        icon: const Value('✈️'),
        color: const Value('#FEC8D8'),
        sortOrder: const Value(9),
      ),
      ExpenseCategoriesCompanion.insert(
        name: 'Other',
        icon: const Value('📌'),
        color: const Value('#E0BBE4'),
        sortOrder: const Value(10),
      ),
    ];

    for (final category in defaultCategories) {
      await into(
        expenseCategories,
      ).insert(category, mode: InsertMode.insertOrIgnore);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'finance_app.db'));
    return NativeDatabase(file);
  });
}
