import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  /// Initialize the ViewModel. Override in subclasses to perform initialization logic.
  Future<void> init() async {}

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

  Future<T> executeAsync<T>(
    Future<T> Function() operation, {
    bool showLoading = true,
  }) async {
    if (showLoading) setLoading(true);
    clearError();

    try {
      return await operation();
    } catch (e) {
      setError(e.toString());
      rethrow;
    } finally {
      if (showLoading) setLoading(false);
    }
  }
}
