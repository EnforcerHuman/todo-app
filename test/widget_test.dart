import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test renders material app', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Task Flow'))),
    );

    expect(find.text('Task Flow'), findsOneWidget);
  });
}
