import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// THEME & PROVIDERS
import 'package:waste_sort_ai/theme/app_theme.dart';
import 'package:waste_sort_ai/theme/theme_provider.dart';
import 'package:waste_sort_ai/utils/app_routes.dart';

// SCREENS
import 'package:waste_sort_ai/screens/splash_screen.dart';
import 'package:waste_sort_ai/screens/onboarding_screen.dart';
import 'package:waste_sort_ai/screens/login_screen.dart';
import 'package:waste_sort_ai/screens/signup_screen.dart';
import 'package:waste_sort_ai/screens/home_screen.dart';
import 'package:waste_sort_ai/screens/profile_screen.dart';
import 'package:waste_sort_ai/screens/settings_screen.dart';
import 'package:waste_sort_ai/screens/analytics_screen.dart';
import 'package:waste_sort_ai/screens/chat_screen.dart';
import 'package:waste_sort_ai/screens/about_app_screen.dart';
import 'package:waste_sort_ai/screens/developer_screen.dart';
import 'package:waste_sort_ai/screens/disclaimer_screen.dart';
import 'package:waste_sort_ai/screens/capture_screen.dart';
import 'package:waste_sort_ai/screens/processing_screen.dart';
import 'package:waste_sort_ai/screens/results_screen.dart';
import 'package:waste_sort_ai/screens/history_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Supabase Initialization with NEW PROJECT URL and CORRECT Anon Key
    await Supabase.initialize(
      url: 'https://ilgyasgxrremkhinfxuq.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlsZ3lhc2d4cnJlbWtoaW5meHVxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI1MzE0NzcsImV4cCI6MjA4ODEwNzQ3N30.BesFQrZtVzP4Du7bbwa3EINAOXVWdg8rvIY_umYysGg',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const WasteSortAIApp(),
      ),
    );
  } catch (e) {
    debugPrint('Supabase Initialization Error: $e');
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Connectivity Error: $e')),
          ),
        ),
      ),
    );
  }
}

class WasteSortAIApp extends StatelessWidget {
  const WasteSortAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait for a better UI experience
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'WasteSort AI',
          debugShowCheckedModeBanner: false,
          
          // Theme Configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          
          // Navigation
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.onboarding: (context) => const OnboardingScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.signup: (context) => const SignUpScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.settings: (context) => const SettingsScreen(),
            AppRoutes.analytics: (context) => const AnalyticsScreen(),
            AppRoutes.chat: (context) => const ChatScreen(),
            AppRoutes.aboutApp: (context) => const AboutAppScreen(),
            AppRoutes.developer: (context) => const DeveloperScreen(),
            AppRoutes.disclaimer: (context) => const DisclaimerScreen(),
            AppRoutes.capture: (context) => const CaptureScreen(),
            AppRoutes.processing: (context) => const ProcessingScreen(),
            AppRoutes.results: (context) => const ResultsScreen(),
            AppRoutes.history: (context) => const HistoryScreen(),
          },
        );
      },
    );
  }
}
