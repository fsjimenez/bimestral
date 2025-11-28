
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:myapp/populate_database.dart';

void main() {
  testWidgets('Main screen loads', (WidgetTester tester) async {
    // Populate the database before running the app.
    await populateDatabase();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // The first frame is a splash screen, let it settle.
    await tester.pumpAndSettle();

    // Verify that the main screen title is displayed.
    expect(find.text('Tradición Lojana'), findsOneWidget);
  });
}
