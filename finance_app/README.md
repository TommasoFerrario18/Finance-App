# Net Worth Tracker

## Overview
A complete Flutter application scaffolding with MVVM architecture, repository pattern, and modern navigation system for tracking net worth, investments, and expenses.

## What's Included

### ✅ Navigation System
Bottom navigation with 5 tabs:
1. **Portfolio** - View investments and assets
2. **Add Asset** - Record new investments
3. **Dashboard** - Net worth overview (home screen)
4. **Expenses** - Track and analyze spending
5. **Add Expense** - Record new expenses

## Architecture

This project follows **MVVM (Model-View-ViewModel)** pattern with **Repository** pattern for data management.

### Project Structure

```
lib/
├── core/
│   ├── base/
│   │   └── base_viewmodel.dart          # Base class for all ViewModels
│   ├── di/
│   │   └── service_locator.dart         # Dependency injection setup
│   ├── navigation/
│   │   └── app_router.dart              # Navigation configuration
│   └── widgets/
│       └── feature_scaffold.dart        # Reusable scaffold widget
├── features/
│   ├── main_navigation/
│   │   └── presentation/
│   │       └── views/
│   │           └── main_navigation_view.dart  # Bottom navigation
│   ├── dashboard/
│   │   └── presentation/
│   │       ├── viewmodels/
│   │       │   └── dashboard_viewmodel.dart
│   │       └── views/
│   │           └── dashboard_view.dart
│   ├── portfolio/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── investment_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── investment_repository.dart
│   │   └── presentation/
│   │       ├── viewmodels/
│   │       │   ├── portfolio_viewmodel.dart
│   │       │   └── add_investment_viewmodel.dart
│   │       └── views/
│   │           ├── portfolio_view.dart
│   │           └── add_investment_view.dart
│   └── expenses/
│       ├── data/
│       │   └── repositories/
│       │       └── expense_repository_impl.dart
│       ├── domain/
│       │   └── repositories/
│       │       └── expense_repository.dart
│       └── presentation/
│           ├── viewmodels/
│           │   ├── expenses_viewmodel.dart
│           │   └── add_expense_viewmodel.dart
│           └── views/
│               ├── expenses_view.dart
│               └── add_expense_view.dart
└── main.dart
```