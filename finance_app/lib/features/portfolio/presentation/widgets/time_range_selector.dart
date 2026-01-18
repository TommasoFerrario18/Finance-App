import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:flutter/material.dart';

/// Reusable widget for selecting time range filters
class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedTimeRange;
  final ValueChanged<TimeRange> onTimeRangeChanged;

  const TimeRangeSelector({
    super.key,
    required this.selectedTimeRange,
    required this.onTimeRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TimeRange.values.map((timeRange) {
            final isSelected = timeRange == selectedTimeRange;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _TimeRangeChip(
                label: timeRange.label,
                isSelected: isSelected,
                onTap: () => onTimeRangeChanged(timeRange),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TimeRangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeRangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
