
import 'package:cjt_scan/screens/capture_screen.dart';
import 'package:cjt_scan/screens/disclaimer_screen.dart';
import 'package:cjt_scan/screens/history_screen.dart';
import 'package:cjt_scan/screens/login_screen.dart';
import 'package:cjt_scan/screens/processing_screen.dart';
import 'package:cjt_scan/screens/results_screen.dart';
import 'package:cjt_scan/screens/signup_screen.dart';
import 'package:cjt_scan/screens/splash_screen.dart';
import 'package:cjt_scan/theme/app_theme.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CjtScanApp());
}

class CjtScanApp extends StatelessWidget {
  const CjtScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Enforce portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'cjt scan',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.signup: (context) => const SignUpScreen(),
        AppRoutes.disclaimer: (context) => const DisclaimerScreen(),
        AppRoutes.capture: (context) => const CaptureScreen(),
        AppRoutes.processing: (context) => const ProcessingScreen(),
        AppRoutes.results: (context) => const ResultsScreen(),
        AppRoutes.history: (context) => const HistoryScreen(),
      },
    );
  }
}
