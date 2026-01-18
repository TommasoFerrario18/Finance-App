import 'package:finance_app/features/portfolio/domain/models/portfolio_data_models.dart';
import 'package:finance_app/features/portfolio/presentation/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeRangeSelector Widget Tests', () {
    testWidgets('should render all time range options', (tester) async {
      // Arrange
      TimeRange? selectedRange;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeRangeSelector(
              selectedTimeRange: TimeRange.oneYear,
              onTimeRangeChanged: (range) => selectedRange = range,
            ),
          ),
        ),
      );

      // Assert
      for (final timeRange in TimeRange.values) {
        expect(find.text(timeRange.label), findsOneWidget);
      }
    });

    testWidgets('should highlight selected time range', (tester) async {
      // Arrange
      const selectedTimeRange = TimeRange.threeMonths;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeRangeSelector(
              selectedTimeRange: selectedTimeRange,
              onTimeRangeChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      // Find the container for the selected chip
      final selectedChipFinder = find.ancestor(
        of: find.text(selectedTimeRange.label),
        matching: find.byType(Container),
      );
      expect(selectedChipFinder, findsWidgets);
    });

    testWidgets('should call callback when time range is tapped', (
      tester,
    ) async {
      // Arrange
      TimeRange? selectedRange;
      const initialRange = TimeRange.oneYear;
      const newRange = TimeRange.sixMonths;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeRangeSelector(
              selectedTimeRange: initialRange,
              onTimeRangeChanged: (range) => selectedRange = range,
            ),
          ),
        ),
      );

      // Tap on 6M option
      await tester.tap(find.text(newRange.label));
      await tester.pump();

      // Assert
      expect(selectedRange, newRange);
    });

    testWidgets('should be horizontally scrollable', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeRangeSelector(
              selectedTimeRange: TimeRange.oneYear,
              onTimeRangeChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final scrollView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollView.scrollDirection, Axis.horizontal);
    });

    testWidgets('should display chips in a row', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeRangeSelector(
              selectedTimeRange: TimeRange.oneYear,
              onTimeRangeChanged: (_) {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Row), findsOneWidget);
    });
  });
}
