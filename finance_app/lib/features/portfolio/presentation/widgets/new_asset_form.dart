import 'package:finance_app/features/portfolio/presentation/viewmodels/add_investment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewAssetForm extends StatelessWidget {
  const NewAssetForm({super.key});

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
          Text('Asset Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),

          // --- Name & Category Section ---
          TextField(
            decoration: const InputDecoration(
              labelText: 'Asset Name',
              hintText: 'e.g. S&P 500 ETF or Bitcoin',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            onChanged: (value) => viewModel.assetName = value,
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Category',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: viewModel.tags
                .map(
                  (label) => DropdownMenuItem(value: label, child: Text(label)),
                )
                .toList(),
            onChanged: (value) => viewModel.category = value,
          ),
          const SizedBox(height: 16),

          // --- Identifiers Section (Ticker & ISIN) ---
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Ticker',
                    hintText: 'AAPL',
                    prefixIcon: Icon(Icons.show_chart),
                  ),
                  onChanged: (value) => viewModel.ticker = value,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'ISIN',
                    hintText: 'US0378331002',
                    prefixIcon: Icon(Icons.fingerprint),
                  ),
                  onChanged: (value) => viewModel.isin = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Financials & Date Section ---
          TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Initial Principal',
              prefixIcon: Icon(Icons.account_balance_wallet_outlined),
            ),
            onChanged: (value) =>
                viewModel.amount = double.tryParse(value) ?? 0.0,
          ),
          const SizedBox(height: 16),

          // Date Picker Field
          InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                viewModel.firstInvestmentDate = pickedDate;
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'First Investment Date',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
              child: Text(
                viewModel.firstInvestmentDate != null
                    ? DateFormat(
                        'yyyy-MM-dd',
                      ).format(viewModel.firstInvestmentDate!)
                    : 'Select Date',
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
