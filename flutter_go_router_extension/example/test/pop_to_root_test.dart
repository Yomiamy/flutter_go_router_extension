import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test popToRoot functionality from CommentsPage', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify we are on Home page
    expect(find.text('Home'), findsOneWidget);

    // Navigate to User 123
    await tester.tap(find.text('Go to User 123'));
    await tester.pumpAndSettle();
    expect(find.text('User 123'), findsOneWidget);

    // Navigate to Comments
    await tester.tap(find.text('Go to Comments'));
    await tester.pumpAndSettle();
    expect(find.text('Comments'), findsOneWidget);

    // Find and tap popToRoot button
    // We look for the button with the label 'popToRoot()'
    final popToRootFinder = find.widgetWithText(ElevatedButton, 'popToRoot()');
    expect(popToRootFinder, findsOneWidget);

    await tester.tap(popToRootFinder);
    await tester.pumpAndSettle();

    // Verify we are back at Home.
    // The title 'Home' should be visible in the AppBar.
    expect(find.text('Home'), findsOneWidget);

    // Verify stack is cleared (User 123 and Comments are gone from the view)
    // Note: They might physically exist in memory if not disposed, but should not be in tree.
    expect(find.text('User 123'), findsNothing);
    expect(find.text('Comments'), findsNothing);
  });
}
