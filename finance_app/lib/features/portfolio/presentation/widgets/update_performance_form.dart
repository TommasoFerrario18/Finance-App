import 'package:finance_app/features/portfolio/presentation/viewmodels/add_investment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePerformanceForm extends StatelessWidget {
  const UpdatePerformanceForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddInvestmentViewModel>();

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Record Price Point',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          // Searchable Asset Selector (Simplified for example)
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select Asset',
              prefixIcon: Icon(Icons.account_balance_wallet_outlined),
            ),
            items: viewModel.existingAssets
                .map(
                  (asset) => DropdownMenuItem(
                    value: asset.id,
                    child: Text(asset.name),
                  ),
                )
                .toList(),
            onChanged: (value) => viewModel.selectedAssetId = value,
          ),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Current Market Price',
              prefixIcon: Icon(Icons.show_chart),
              suffixText: 'USD',
            ),
            onChanged: (value) =>
                viewModel.amount = double.tryParse(value) ?? 0.0,
          ),
          const SizedBox(height: 16),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            leading: const Icon(Icons.calendar_today),
            title: const Text('Observation Date'),
            subtitle: Text(
              '${viewModel.observationDate.toLocal()}'.split(' ')[0],
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: viewModel.observationDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null) viewModel.setDate(picked);
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
