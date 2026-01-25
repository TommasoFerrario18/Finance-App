import 'package:finance_app/features/portfolio/presentation/viewmodels/add_investment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewAssetForm extends StatelessWidget {
  const NewAssetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddInvestmentViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Asset Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Asset Name',
            hintText: 'e.g. S&P 500 ETF or Bitcoin',
            prefixIcon: Icon(Icons.label_outline),
          ),
          onChanged: (value) => viewModel.assetName = value,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Category',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: ['Stocks', 'Crypto', 'Real Estate', 'Cash']
              .map(
                (label) => DropdownMenuItem(value: label, child: Text(label)),
              )
              .toList(),
          onChanged: (value) => viewModel.category = value,
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Initial Principal',
            prefixIcon: Icon(Icons.attach_money),
          ),
          onChanged: (value) =>
              viewModel.amount = double.tryParse(value) ?? 0.0,
        ),
      ],
    );
  }
}
