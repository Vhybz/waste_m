
import 'package:cjt_scan/screens/about_screen.dart';
import 'package:cjt_scan/screens/analytics_screen.dart';
import 'package:cjt_scan/screens/capture_screen.dart';
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
        child: const CjtScanAIApp(),
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

class CjtScanAIApp extends StatefulWidget {
  const CjtScanAIApp({super.key});

  @override
  State<CjtScanAIApp> createState() => _CjtScanAIAppState();
}

class _CjtScanAIAppState extends State<CjtScanAIApp> {
  @override
  void initState() {
    super.initState();
    // Listen for auth state changes globally
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        // Force refresh the app state if a session is detected
        debugPrint('Auth session detected globally');
      }
    });
  }

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
          darkTheme: ThemeData.dark(useMaterial3: true),
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
            AppRoutes.about: (context) => const AboutScreen(),
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
