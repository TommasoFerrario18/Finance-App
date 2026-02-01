import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Displays a line chart showing net worth history over time
class NetWorthChart extends StatelessWidget {
  final List<NetWorthDataPoint> dataPoints;
  final TimeRange timeRange;

  const NetWorthChart({
    super.key,
    required this.dataPoints,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    if (dataPoints.isEmpty) {
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                _buildChartData(context),
                duration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartHeader(BuildContext context) {
    final currentValue = dataPoints.last.value;
    final firstValue = dataPoints.first.value;
    final change = currentValue - firstValue;
    final percentChange = (change / firstValue) * 100;
    final isPositive = change >= 0;

    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    final percentFormat = NumberFormat('+#,##0.00;-#,##0.00');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Worth',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(currentValue),
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                '${currencyFormat.format(change.abs())} (${percentFormat.format(percentChange)}%)',
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                timeRange.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final spots = _convertToSpots();

    final minY = dataPoints.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxY = dataPoints.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 4,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _calculateBottomInterval(),
            getTitlesWidget: (value, meta) {
              return _buildBottomTitle(value.toInt(), context);
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
            interval: (maxY - minY) / 4,
            getTitlesWidget: (value, meta) {
              return _buildLeftTitle(value, context);
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (dataPoints.length - 1).toDouble(),
      minY: minY - padding,
      maxY: maxY + padding,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colorScheme.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: colorScheme.primary.withValues(alpha: 0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final dataPoint = dataPoints[spot.x.toInt()];
              final dateFormat = DateFormat('MMM d, yyyy');
              final currencyFormat = NumberFormat.currency(
                symbol: '\$',
                decimalDigits: 0,
              );

              return LineTooltipItem(
                '${dateFormat.format(dataPoint.date)}\n${currencyFormat.format(dataPoint.value)}',
                TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  List<FlSpot> _convertToSpots() {
    return List.generate(
      dataPoints.length,
      (index) => FlSpot(index.toDouble(), dataPoints[index].value),
    );
  }

  double _calculateBottomInterval() {
    final length = dataPoints.length;
    if (length <= 7) return 1;
    if (length <= 30) return 5;
    if (length <= 90) return 15;
    return 30;
  }

  Widget _buildBottomTitle(int index, BuildContext context) {
    if (index < 0 || index >= dataPoints.length) {
      return const SizedBox.shrink();
    }

    final date = dataPoints[index].date;
    final format = _getDateFormat();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        format.format(date),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, BuildContext context) {
    final format = NumberFormat.compact();

    return Text(
      '\$${format.format(value)}',
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 10,
      ),
    );
  }

  DateFormat _getDateFormat() {
    switch (timeRange) {
      case TimeRange.oneMonth:
      case TimeRange.threeMonths:
        return DateFormat('MMM d');
      case TimeRange.sixMonths:
      case TimeRange.oneYear:
        return DateFormat('MMM');
      default:
        return DateFormat('yyyy');
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
