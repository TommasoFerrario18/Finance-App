import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';
import 'package:finance_app/features/portfolio/domain/models/asset.dart';

enum InvestmentMode { newAsset, updatePrice }

class AddInvestmentViewModel extends BaseViewModel {
  final InvestmentRepository repository;

  AddInvestmentViewModel({required this.repository});

  InvestmentMode _currentMode = InvestmentMode.newAsset;
  InvestmentMode get currentMode => _currentMode;

  List<Asset> existingAssets = [];
  String? selectedAssetId;

  // Form Fields
  String assetName = '';
  String? category;
  double amount = 0.0;
  String ticker = '';
  String isin = '';
  DateTime? firstInvestmentDate = DateTime.now();
  DateTime observationDate = DateTime.now();
  List<String> tags = ['Stocks', 'Crypto', 'Real Estate', 'Cash'];

  // Validation
  final Map<String, String> _validationErrors = {};
  Map<String, String> get validationErrors => _validationErrors;

  void setDate(DateTime date) {
    observationDate = date;
    notifyListeners();
  }

  void setMode(InvestmentMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  bool validate() {
    _validationErrors.clear();

    // Validate asset name
    if (assetName.trim().isEmpty) {
      _validationErrors['assetName'] = 'Asset name is required';
    }

    // Validate category
    if (category == null || category!.isEmpty) {
      _validationErrors['category'] = 'Category is required';
    }

    // Validate amount
    if (amount <= 0) {
      _validationErrors['amount'] = 'Amount must be greater than 0';
    }

    // Validate ticker
    if (ticker.trim().isEmpty) {
      _validationErrors['ticker'] = 'Ticker is required';
    }

    // Validate ISIN format if provided
    if (isin.isNotEmpty && !_isValidIsin(isin)) {
      _validationErrors['isin'] =
          'Invalid ISIN format (should be 12 alphanumeric characters)';
    }

    // Validate first investment date
    if (firstInvestmentDate == null) {
      _validationErrors['firstInvestmentDate'] =
          'First investment date is required';
    } else if (firstInvestmentDate!.isAfter(DateTime.now())) {
      _validationErrors['firstInvestmentDate'] =
          'First investment date cannot be in the future';
    }

    // Validate observation date
    if (observationDate.isAfter(DateTime.now())) {
      _validationErrors['observationDate'] =
          'Observation date cannot be in the future';
    }

    notifyListeners();
    return _validationErrors.isEmpty;
  }

  bool _isValidIsin(String isin) {
    // ISIN format: 2 letters (country code) + 9 alphanumeric + 1 check digit
    final isinRegex = RegExp(r'^[A-Z]{2}[A-Z0-9]{9}[0-9]$');
    return isinRegex.hasMatch(isin);
  }

  Future<void> save() async {
    if (!validate()) return;

    setLoading(true);
    try {
      if (_currentMode == InvestmentMode.newAsset) {
        print('Creating new asset...');
        // await repository.createAsset(...);
      } else {
        print('Adding price point...');
        // await repository.addPricePoint(
        //   selectedAssetId!,
        //   amount,
        //   observationDate,
        // );
      }
      // Success logic: clear form or show snackbar
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
