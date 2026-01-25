import 'package:finance_app/core/base/base_viewmodel.dart';
import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:finance_app/core/widgets/loading_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Abstract base class for feature views that use ChangeNotifierProvider pattern.
/// 
/// This eliminates boilerplate by handling the Provider setup, loading/error states,
/// and FeatureScaffold wrapping automatically.
/// 
/// Subclasses must:
/// 1. Implement [buildTitle] to return the screen title
/// 2. Implement [createViewModel] to provide the ViewModel instance
/// 3. Implement [buildContent] to build the actual content widget
abstract class BaseFeatureView<T extends BaseViewModel> extends StatelessWidget {
  const BaseFeatureView({super.key});

  /// Return the title for this feature screen
  String get title;

  /// Create and return a new instance of the ViewModel
  T createViewModel();

  /// Build the content widget when data is loaded
  Widget buildContent(BuildContext context, T viewModel);

  /// Optional callback when retry button is pressed. Defaults to calling init()
  Future<void> onRetry(T viewModel) async {
    await viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => createViewModel()..init(),
      child: Consumer<T>(
        builder: (context, viewModel, _) {
          return FeatureScaffold(
            title: title,
            child: LoadingErrorWidget(
              isLoading: viewModel.isLoading,
              hasError: viewModel.hasError,
              errorMessage: viewModel.errorMessage,
              onRetry: viewModel.hasError
                  ? () => onRetry(viewModel)
                  : null,
              child: buildContent(context, viewModel),
            ),
          );
        },
      ),
    );
  }
}
