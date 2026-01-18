import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/features/portfolio/domain/repositories/investment_repository.dart';

class PortfolioViewModel extends BaseViewModel {
  final InvestmentRepository repository;

  PortfolioViewModel({required this.repository});

  Future<void> loadPortfolio() async {
    setLoading(true);
    clearError();

    try {
      await repository.initialize();
      // Placeholder for loading portfolio data
    } catch (e) {
      setError('Failed to load portfolio: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}
