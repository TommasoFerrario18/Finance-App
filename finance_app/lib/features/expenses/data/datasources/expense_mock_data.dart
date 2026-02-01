import 'package:finance_app/features/expenses/domain/models/expense_models.dart';

class ExpenseMockData {
  static final DateTime now = DateTime.now();
  static final DateTime currentMonth = DateTime(now.year, now.month, 1);

  static final List<Expense> mockExpenses = [
    // Food expenses
    Expense(
      id: 'exp_001',
      title: 'Grocery Shopping',
      amount: 85.50,
      category: ExpenseCategory.food,
      date: DateTime(now.year, now.month, 1),
      description: 'Weekly groceries',
    ),
    Expense(
      id: 'exp_002',
      title: 'Restaurant Dinner',
      amount: 45.75,
      category: ExpenseCategory.food,
      date: DateTime(now.year, now.month, 3),
      description: 'Dinner with friends',
    ),
    Expense(
      id: 'exp_003',
      title: 'Coffee & Snacks',
      amount: 12.50,
      category: ExpenseCategory.food,
      date: DateTime(now.year, now.month, 5),
      description: 'Daily coffee',
    ),
    Expense(
      id: 'exp_004',
      title: 'Fast Food',
      amount: 18.99,
      category: ExpenseCategory.food,
      date: DateTime(now.year, now.month, 7),
      description: 'Quick lunch',
    ),
    Expense(
      id: 'exp_005',
      title: 'Grocery Shopping',
      amount: 92.30,
      category: ExpenseCategory.food,
      date: DateTime(now.year, now.month, 8),
      description: 'Weekly groceries',
    ),

    // Transportation expenses
    Expense(
      id: 'exp_006',
      title: 'Gas Fill-up',
      amount: 55.00,
      category: ExpenseCategory.transportation,
      date: DateTime(now.year, now.month, 2),
      description: 'Car fuel',
    ),
    Expense(
      id: 'exp_007',
      title: 'Taxi Ride',
      amount: 22.50,
      category: ExpenseCategory.transportation,
      date: DateTime(now.year, now.month, 9),
      description: 'Airport taxi',
    ),
    Expense(
      id: 'exp_008',
      title: 'Public Transport',
      amount: 15.00,
      category: ExpenseCategory.transportation,
      date: DateTime(now.year, now.month, 15),
      description: 'Monthly pass',
    ),

    // Entertainment expenses
    Expense(
      id: 'exp_009',
      title: 'Movie Tickets',
      amount: 28.00,
      category: ExpenseCategory.entertainment,
      date: DateTime(now.year, now.month, 4),
      description: 'Cinema with family',
    ),
    Expense(
      id: 'exp_010',
      title: 'Spotify Premium',
      amount: 10.99,
      category: ExpenseCategory.entertainment,
      date: DateTime(now.year, now.month, 1),
      description: 'Monthly subscription',
    ),
    Expense(
      id: 'exp_011',
      title: 'Concert Tickets',
      amount: 120.00,
      category: ExpenseCategory.entertainment,
      date: DateTime(now.year, now.month, 12),
      description: 'Live music event',
    ),

    // Utilities expenses
    Expense(
      id: 'exp_012',
      title: 'Electricity Bill',
      amount: 85.00,
      category: ExpenseCategory.utilities,
      date: DateTime(now.year, now.month, 5),
      description: 'Monthly electricity',
    ),
    Expense(
      id: 'exp_013',
      title: 'Internet Bill',
      amount: 49.99,
      category: ExpenseCategory.utilities,
      date: DateTime(now.year, now.month, 1),
      description: 'ISP charges',
    ),
    Expense(
      id: 'exp_014',
      title: 'Water Bill',
      amount: 35.50,
      category: ExpenseCategory.utilities,
      date: DateTime(now.year, now.month, 10),
      description: 'Monthly water',
    ),

    // Healthcare expenses
    Expense(
      id: 'exp_015',
      title: 'Doctor Appointment',
      amount: 120.00,
      category: ExpenseCategory.healthcare,
      date: DateTime(now.year, now.month, 6),
      description: 'Medical checkup',
    ),
    Expense(
      id: 'exp_016',
      title: 'Pharmacy',
      amount: 45.00,
      category: ExpenseCategory.healthcare,
      date: DateTime(now.year, now.month, 9),
      description: 'Medicines',
    ),

    // Shopping expenses
    Expense(
      id: 'exp_017',
      title: 'Clothing Store',
      amount: 125.99,
      category: ExpenseCategory.shopping,
      date: DateTime(now.year, now.month, 11),
      description: 'New shirts and pants',
    ),
    Expense(
      id: 'exp_018',
      title: 'Electronics',
      amount: 299.99,
      category: ExpenseCategory.shopping,
      date: DateTime(now.year, now.month, 13),
      description: 'Wireless headphones',
    ),

    // Education expenses
    Expense(
      id: 'exp_019',
      title: 'Online Course',
      amount: 49.99,
      category: ExpenseCategory.education,
      date: DateTime(now.year, now.month, 14),
      description: 'Udemy course',
    ),
  ];

  /// Get expenses for current month
  static List<Expense> getExpensesForCurrentMonth() {
    return mockExpenses.where((expense) {
      return expense.date.year == now.year && expense.date.month == now.month;
    }).toList();
  }

  /// Get total expenses for current month
  static double getTotalExpensesForCurrentMonth() {
    return getExpensesForCurrentMonth().fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  /// Get category summaries for current month
  static List<ExpenseSummary> getCategorySummariesForCurrentMonth() {
    final expenses = getExpensesForCurrentMonth();
    final total = getTotalExpensesForCurrentMonth();

    final Map<ExpenseCategory, List<Expense>> grouped = {};
    for (final expense in expenses) {
      grouped.putIfAbsent(expense.category, () => []).add(expense);
    }

    return grouped.entries
        .map((entry) {
          final categoryExpenses = entry.value;
          final categoryTotal =
              categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
          final percentage = total > 0 ? (categoryTotal / total) * 100 : 0.0;

          return ExpenseSummary(
            category: entry.key,
            totalAmount: categoryTotal,
            count: categoryExpenses.length,
            percentage: percentage,
          );
        })
        .toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
  }

  /// Get monthly expense data for current month
  static MonthlyExpenseData getMonthlyExpenseDataForCurrentMonth() {
    final expenses = getExpensesForCurrentMonth();
    final total = getTotalExpensesForCurrentMonth();
    final summaries = getCategorySummariesForCurrentMonth();

    return MonthlyExpenseData(
      month: currentMonth,
      totalExpenses: total,
      categorySummaries: summaries,
      expenses: expenses,
    );
  }
}
