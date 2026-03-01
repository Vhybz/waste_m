
import 'package:flutter_test/flutter_test.dart';
import 'package:cjt_scan/main.dart';
import 'package:provider/provider.dart';
import 'package:cjt_scan/theme/theme_provider.dart';

void main() {
  testWidgets('Splash screen shows app name', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Note: We need to wrap it in the same provider used in main.dart if we want to test the full app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const CjtScanAIApp(),
      ),
    );

    // Verify that the splash screen shows the app name "cjt_scan AI".
    // Using find.textContaining to be safe with formatting
    expect(find.textContaining('cjt_scan AI'), findsOneWidget);
  });
}
