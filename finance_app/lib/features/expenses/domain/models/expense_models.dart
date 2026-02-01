import 'package:equatable/equatable.dart';

/// Enum for expense categories
enum ExpenseCategory {
  food('Food', '🍔'),
  transportation('Transportation', '🚗'),
  entertainment('Entertainment', '🎬'),
  utilities('Utilities', '💡'),
  healthcare('Healthcare', '⚕️'),
  shopping('Shopping', '🛍️'),
  education('Education', '📚'),
  other('Other', '📌');

  final String label;
  final String emoji;

  const ExpenseCategory(this.label, this.emoji);
}

/// Represents a single expense
class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? description;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, amount, category, date, description];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'category': category.name,
    'date': date.toIso8601String(),
    'description': description,
  };

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'] as String,
        orElse: () => ExpenseCategory.other,
      ),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );
  }
}

/// Represents the summary of expenses for a category
class ExpenseSummary extends Equatable {
  final ExpenseCategory category;
  final double totalAmount;
  final int count;
  final double percentage;

  const ExpenseSummary({
    required this.category,
    required this.totalAmount,
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [category, totalAmount, count, percentage];

  Map<String, dynamic> toJson() => {
    'category': category.name,
    'totalAmount': totalAmount,
    'count': count,
    'percentage': percentage,
  };

  factory ExpenseSummary.fromJson(Map<String, dynamic> json) {
    return ExpenseSummary(
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'] as String,
        orElse: () => ExpenseCategory.other,
      ),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Represents monthly expense data
class MonthlyExpenseData extends Equatable {
  final DateTime month;
  final double totalExpenses;
  final double totalIncome;
  final List<ExpenseSummary> categorySummaries;
  final List<Expense> expenses;

  const MonthlyExpenseData({
    required this.month,
    required this.totalExpenses,
    required this.totalIncome,
    required this.categorySummaries,
    required this.expenses,
  });

  /// Get the net income (income - expenses)
  double get netIncome => totalIncome - totalExpenses;

  /// Get the savings percentage
  double get savingsPercentage {
    if (totalIncome == 0) return 0.0;
    return (netIncome / totalIncome) * 100;
  }

  @override
  List<Object?> get props => [
    month,
    totalExpenses,
    totalIncome,
    categorySummaries,
    expenses,
  ];

  Map<String, dynamic> toJson() => {
    'month': month.toIso8601String(),
    'totalExpenses': totalExpenses,
    'totalIncome': totalIncome,
    'categorySummaries': categorySummaries.map((e) => e.toJson()).toList(),
    'expenses': expenses.map((e) => e.toJson()).toList(),
  };

  factory MonthlyExpenseData.fromJson(Map<String, dynamic> json) {
    return MonthlyExpenseData(
      month: DateTime.parse(json['month'] as String),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      categorySummaries: (json['categorySummaries'] as List)
          .map((e) => ExpenseSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      expenses: (json['expenses'] as List)
          .map((e) => Expense.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
