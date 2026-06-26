import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:i_pack/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the splash screen shows the title 'I-PACK'.
    expect(find.text('I-PACK'), findsOneWidget);
    
    // Pump with duration to let animations and splash timer complete.
    await tester.pump(const Duration(milliseconds: 3000));
  });
}
