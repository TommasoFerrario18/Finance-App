import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays a pie chart showing asset allocation
class AssetAllocationChart extends StatefulWidget {
  final List<AssetAllocation> allocations;

  const AssetAllocationChart({super.key, required this.allocations});

  @override
  State<AssetAllocationChart> createState() => _AssetAllocationChartState();
}

class _AssetAllocationChartState extends State<AssetAllocationChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.allocations.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: _buildEmptyState(context),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildChartHeader(context),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: Row(
              children: [
                Expanded(flex: 2, child: _buildPieChart()),
                Expanded(flex: 1, child: _buildLegend(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartHeader(BuildContext context) {
    final totalValue = widget.allocations.fold<double>(
      0,
      (sum, allocation) => sum + allocation.value,
    );

    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asset Allocation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(totalValue),
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Portfolio Value',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: _buildSections(context),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final colors = _getChartColors(context);

    return List.generate(widget.allocations.length, (index) {
      final isTouched = index == touchedIndex;
      final allocation = widget.allocations[index];
      final radius = isTouched ? 70.0 : 60.0;
      final fontSize = isTouched ? 16.0 : 12.0;

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: allocation.percentage,
        title: '${allocation.percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend(BuildContext context) {
    final colors = _getChartColors(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return ListView.builder(
      itemCount: widget.allocations.length,
      itemBuilder: (context, index) {
        final allocation = widget.allocations[index];
        final isTouched = index == touchedIndex;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                  border: isTouched
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allocation.assetType,
                      style: TextStyle(
                        fontSize: isTouched ? 14 : 12,
                        fontWeight: isTouched
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isTouched
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      currencyFormat.format(allocation.value),
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pie_chart,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No allocation data available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getChartColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
    ];
  }
}
