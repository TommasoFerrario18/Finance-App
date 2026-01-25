import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:finance_app/features/portfolio/presentation/viewmodels/add_investment_viewmodel.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/new_asset_form.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/update_performance_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddInvestmentView extends StatelessWidget {
  const AddInvestmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AddInvestmentViewModel>(),
      child: Consumer<AddInvestmentViewModel>(
        builder: (context, viewModel, child) {
          return FeatureScaffold(
            title: 'Management',
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 1. Toggle between New Asset and Update
                  SegmentedButton<InvestmentMode>(
                    segments: const [
                      ButtonSegment(
                        value: InvestmentMode.newAsset,
                        label: Text('New Asset'),
                        icon: Icon(Icons.add),
                      ),
                      ButtonSegment(
                        value: InvestmentMode.updatePrice,
                        label: Text('Update Price'),
                        icon: Icon(Icons.trending_up),
                      ),
                    ],
                    selected: {viewModel.currentMode},
                    onSelectionChanged: (Set<InvestmentMode> newSelection) {
                      viewModel.setMode(newSelection.first);
                    },
                  ),
                  const SizedBox(height: 24),

                  // 2. Dynamic Form based on Mode
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: viewModel.currentMode == InvestmentMode.newAsset
                        ? const NewAssetForm()
                        : const UpdatePerformanceForm(),
                  ),

                  // 3. Global Action Button
                  ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () => viewModel.save(),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Confirm Entry'),
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
