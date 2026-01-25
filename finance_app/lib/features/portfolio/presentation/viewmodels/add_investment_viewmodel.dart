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
  DateTime observationDate = DateTime.now();

  void setDate(DateTime date) {
    observationDate = date;
    notifyListeners();
  }

  void setMode(InvestmentMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  Future<void> save() async {
    // if (!validate()) return;

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
