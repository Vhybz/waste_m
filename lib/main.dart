
import 'package:cjt_scan/screens/about_app_screen.dart'; // Verified Import
import 'package:cjt_scan/screens/analytics_screen.dart';
import 'package:cjt_scan/screens/capture_screen.dart';
import 'package:cjt_scan/screens/chat_screen.dart';
import 'package:cjt_scan/screens/disclaimer_screen.dart';
import 'package:cjt_scan/screens/history_screen.dart';
import 'package:cjt_scan/screens/home_screen.dart';
import 'package:cjt_scan/screens/login_screen.dart';
import 'package:cjt_scan/screens/onboarding_screen.dart';
import 'package:cjt_scan/screens/processing_screen.dart';
import 'package:cjt_scan/screens/profile_screen.dart';
import 'package:cjt_scan/screens/results_screen.dart';
import 'package:cjt_scan/screens/settings_screen.dart';
import 'package:cjt_scan/screens/signup_screen.dart';
import 'package:cjt_scan/screens/splash_screen.dart';
import 'package:cjt_scan/theme/app_theme.dart';
import 'package:cjt_scan/theme/theme_provider.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await Supabase.initialize(
      url: 'https://zslhlrdhawzchcyfewjf.supabase.co',
      anonKey: 'sb_publishable_Eiygms-eo_cfn5k6DilwXA_9mcDF19D',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const AnemiaScanAIApp(),
      ),
    );
  } catch (e) {
    debugPrint('Supabase Initialization Error: $e');
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Connection Error: Please check your internet.')),
          ),
        ),
      ),
    );
  }
}

class AnemiaScanAIApp extends StatefulWidget {
  const AnemiaScanAIApp({super.key});

  @override
  State<AnemiaScanAIApp> createState() => _AnemiaScanAIAppState();
}

class _AnemiaScanAIAppState extends State<AnemiaScanAIApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'cjt_scan AI',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
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
            AppRoutes.aboutApp: (context) => const AboutAppScreen(), // REGISTERED ROUTE
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
