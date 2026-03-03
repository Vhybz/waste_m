
import 'dart:async';
import 'package:waste_sort_ai/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Small delay for the splash animation
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    // Check session - Supabase handles persistence automatically
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF1F8E9),
                    image: DecorationImage(
                      image: AssetImage('asset/images/a.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'WasteSort AI',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Smart Waste Classification',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
