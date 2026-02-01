import 'package:finance_app/core/di/service_locator.dart';
import 'package:finance_app/core/widgets/base_feature_view.dart';
import 'package:finance_app/features/dashboard/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/material.dart';

class DashboardView extends BaseFeatureView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  String get title => '';

  @override
  DashboardViewModel createViewModel() => getIt<DashboardViewModel>();

  @override
  Widget buildContent(BuildContext context, DashboardViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Your net worth overview',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
