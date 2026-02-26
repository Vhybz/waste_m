
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cjt_scan/main.dart';

void main() {
  testWidgets('Splash screen navigates to Login screen after delay', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CjtScanApp());

    // Verify that the splash screen is shown with the app name.
    expect(find.text('cjt scan'), findsOneWidget);
    expect(find.text('Welcome Back'), findsNothing);

    // Fast-forward time by 3 seconds to trigger the navigation timer.
    await tester.pump(const Duration(seconds: 3));
    
    // pumpAndSettle waits for all animations (like the route transition) to complete.
    await tester.pumpAndSettle();

    // Verify that the app has navigated to the LoginScreen.
    expect(find.text('cjt scan'), findsNothing);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
