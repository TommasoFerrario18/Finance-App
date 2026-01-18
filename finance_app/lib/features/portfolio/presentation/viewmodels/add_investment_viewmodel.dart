import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class AddInvestmentViewModel extends BaseViewModel {
  final InvestmentRepository repository;

  AddInvestmentViewModel({required this.repository});

  Future<void> addInvestment() async {
    setLoading(true);
    clearError();

    try {
      // Placeholder for adding investment logic
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      setError('Failed to add investment: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
