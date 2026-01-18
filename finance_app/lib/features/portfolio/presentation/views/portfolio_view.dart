import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/portfolio_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<PortfolioViewModel>()..loadPortfolio(),
      child: Consumer<PortfolioViewModel>(
        builder: (context, viewModel, child) {
          return FeatureScaffold(
            title: 'Portfolio',
            child: Center(
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.trending_up,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Portfolio',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Track your investments',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
