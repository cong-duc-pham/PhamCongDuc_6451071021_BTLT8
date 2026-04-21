// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_backup_app/app/my_app.dart';

void main() {
  testWidgets('To-do List app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts with the title 'To-do List'.
    expect(find.text('To-do List'), findsOneWidget);

    // Verify that the empty state message is shown if no tasks.
    // Note: This depends on the initial state of the app.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Thêm'), findsOneWidget);
  });
}
