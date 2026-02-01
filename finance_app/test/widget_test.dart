import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NetWorthTrackerApp());

    // Verify app title is displayed
    expect(find.text('Net Worth Tracker'), findsWidgets);
  });
}
