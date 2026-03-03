
import 'package:flutter_test/flutter_test.dart';
import 'package:waste_sort_ai/main.dart';
import 'package:provider/provider.dart';
import 'package:waste_sort_ai/theme/theme_provider.dart';

void main() {
  testWidgets('Splash screen shows app name', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const WasteSortAIApp(),
      ),
    );

    expect(find.textContaining('WasteSort AI'), findsOneWidget);
  });
}
