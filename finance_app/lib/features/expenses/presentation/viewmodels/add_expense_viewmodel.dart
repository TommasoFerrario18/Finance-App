import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/expenses/domain/repositories/expense_repository.dart';

class AddExpenseViewModel extends BaseViewModel {
  // You would inject the expense repository here
  final ExpenseRepository repository;

  AddExpenseViewModel({required this.repository});

  // Private Form Fields
  String _description = '';
  String? _category;
  double _amount = 0.0;
  String? _paymentMethod;
  DateTime _expenseDate = DateTime.now();
  bool _isRecurring = false;
  String? _recurringFrequency;
  String _notes = '';

  // Getters
  String get description => _description;
  String? get category => _category;
  double get amount => _amount;
  String? get paymentMethod => _paymentMethod;
  DateTime get expenseDate => _expenseDate;
  bool get isRecurring => _isRecurring;
  String? get recurringFrequency => _recurringFrequency;
  String get notes => _notes;

  // Dropdown Options
  final List<String> categories = [
    'Food & Dining',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills & Utilities',
    'Healthcare',
    'Education',
    'Travel',
    'Personal Care',
    'Other',
  ];

  final List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Digital Wallet',
    'Other',
  ];

  final List<String> recurringFrequencies = [
    'Daily',
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'Quarterly',
    'Yearly',
  ];

  // Validation
  final Map<String, String> _validationErrors = {};
  Map<String, String> get validationErrors => _validationErrors;

  // Setters with notification
  set description(String value) {
    _description = value;
    _validationErrors.remove('description');
    notifyListeners();
  }

  set category(String? value) {
    _category = value;
    _validationErrors.remove('category');
    notifyListeners();
  }

  set amount(double value) {
    _amount = value;
    _validationErrors.remove('amount');
    notifyListeners();
  }

  set paymentMethod(String? value) {
    _paymentMethod = value;
    notifyListeners();
  }

  set expenseDate(DateTime value) {
    _expenseDate = value;
    _validationErrors.remove('expenseDate');
    notifyListeners();
  }

  set isRecurring(bool value) {
    _isRecurring = value;
    if (!value) {
      _recurringFrequency = null;
    } else if (_recurringFrequency == null) {
      _recurringFrequency = recurringFrequencies.first;
    }
    notifyListeners();
  }

  set recurringFrequency(String? value) {
    _recurringFrequency = value;
    notifyListeners();
  }

  set notes(String value) {
    _notes = value;
    notifyListeners();
  }

  bool validate() {
    _validationErrors.clear();

    // Validate description
    if (_description.trim().isEmpty) {
      _validationErrors['description'] = 'Description is required';
    } else if (_description.trim().length < 3) {
      _validationErrors['description'] =
          'Description must be at least 3 characters';
    }

    // Validate category
    if (_category == null || _category!.isEmpty) {
      _validationErrors['category'] = 'Category is required';
    }

    // Validate amount
    if (_amount <= 0) {
      _validationErrors['amount'] = 'Amount must be greater than 0';
    } else if (_amount > 1000000) {
      _validationErrors['amount'] = 'Amount seems unusually high';
    }

    // Validate expense date
    if (_expenseDate.isAfter(DateTime.now())) {
      _validationErrors['expenseDate'] = 'Expense date cannot be in the future';
    }

    // Validate recurring frequency if recurring is enabled
    if (_isRecurring &&
        (_recurringFrequency == null || _recurringFrequency!.isEmpty)) {
      _validationErrors['recurringFrequency'] = 'Please select a frequency';
    }

    notifyListeners();
    return _validationErrors.isEmpty;
  }

  Future<bool> save() async {
    if (!validate()) return false;

    setLoading(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual save logic
      print('Saving expense...');
      print('Description: $_description');
      print('Category: $_category');
      print('Amount: $_amount');
      print('Payment Method: $_paymentMethod');
      print('Date: $_expenseDate');
      print('Is Recurring: $_isRecurring');
      if (_isRecurring) print('Frequency: $_recurringFrequency');
      print('Notes: $_notes');

      // await repository.createExpense(
      //   description: _description,
      //   category: _category!,
      //   amount: _amount,
      //   paymentMethod: _paymentMethod,
      //   expenseDate: _expenseDate,
      //   isRecurring: _isRecurring,
      //   recurringFrequency: _recurringFrequency,
      //   notes: _notes,
      // );

      // Clear form after successful save
      _clearForm();

      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setLoading(false);
    }
  }

  void _clearForm() {
    _description = '';
    _category = null;
    _amount = 0.0;
    _paymentMethod = null;
    _expenseDate = DateTime.now();
    _isRecurring = false;
    _recurringFrequency = null;
    _notes = '';
    _validationErrors.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _validationErrors.clear();
    super.dispose();
  }
}
