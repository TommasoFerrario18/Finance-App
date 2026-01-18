import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  /// Set the loading state and notify listeners
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set an error message and notify listeners
  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear the current error
  void clearError() {
    _errorMessage = null;
  }
}
