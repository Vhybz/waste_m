
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Back button is automatically added
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create Account', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Start your journey with cjt scan.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 48),
              const TextField(decoration: InputDecoration(hintText: 'Full Name')),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(hintText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(hintText: 'Password'), obscureText: true),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(hintText: 'Confirm Password'), obscureText: true),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.disclaimer, (route) => false);
                  },
                  child: const Text('Create Account'),
                ),
              ),
              const SizedBox(height: 24),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  children: [
                    const TextSpan(text: "Already have an account? "),
                    TextSpan(
                      text: 'Log In',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
