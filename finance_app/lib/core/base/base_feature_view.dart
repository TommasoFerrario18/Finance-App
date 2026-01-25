import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseFeatureView<T extends BaseViewModel>
    extends StatelessWidget {
  const BaseFeatureView({super.key});

  String get title;
  T createViewModel();

  Widget buildContent(BuildContext context, T viewModel);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => createViewModel()..init(),
      child: Consumer<T>(
        builder: (context, viewModel, _) {
          return FeatureScaffold(
            title: title,
            child: _buildBody(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, T viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.hasError) {
      return _buildErrorWidget(context, viewModel);
    }

    return buildContent(context, viewModel);
  }

  Widget _buildErrorWidget(BuildContext context, T viewModel) {
    // Reusable error state
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            viewModel.errorMessage ?? 'An unexpected error occurred.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              viewModel.init();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
