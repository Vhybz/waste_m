
import 'package:flutter_test/flutter_test.dart';
import 'package:cjt_scan/main.dart';
import 'package:provider/provider.dart';
import 'package:cjt_scan/theme/theme_provider.dart';

void main() {
  testWidgets('Splash screen shows app name', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const AnemiaScanAIApp(), // Updated to match renamed class in main.dart
      ),
    );

    // Verify that the splash screen shows the app name "cjt_scan AI".
    expect(find.textContaining('cjt_scan AI'), findsOneWidget);
  });
}
