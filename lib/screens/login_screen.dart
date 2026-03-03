
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waste_sort_ai/utils/app_colors.dart';
import 'package:waste_sort_ai/utils/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  late final StreamSubscription<AuthState> _authSubscription;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Listen for auth state changes to route to home automatically
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _socialSignIn(OAuthProvider provider) async {
    setState(() => _isLoading = true);
    try {
      // THE REDIRECT URL MUST BE ADDED TO SUPABASE DASHBOARD
      // AUTH -> URL CONFIGURATION -> REDIRECT URLS
      const String redirectUrl = 'com.example.waste_sort_ai://login-callback/';
      
      await supabase.auth.signInWithOAuth(
        provider,
        redirectTo: redirectUrl,
        queryParams: {'prompt': 'select_account'},
      );
    } on AuthException catch (e) {
      debugPrint('Auth Error: ${e.message}');
      _showErrorSnackBar('Google Sign-In Error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      _showErrorSnackBar('Could not sign in with Google.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('asset/images/a.jpg', height: 120),
                  const SizedBox(height: 32),
                  const Text(
                    'wasteAI',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Log in to your environmental dashboard.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),
                  const SizedBox(height: 48),
                  
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value == null || value.isEmpty) ? 'Please enter your email' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Please enter your password' : null,
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?', style: TextStyle(color: AppColors.primary)),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  FilledButton(
                    onPressed: _isLoading ? null : _signInWithEmail,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('OR', style: TextStyle(color: Colors.grey))),
                      Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  OutlinedButton.icon(
                    onPressed: () => _socialSignIn(OAuthProvider.google),
                    icon: const Icon(Icons.login_rounded, size: 24),
                    label: const Text('Sign in with Google'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      foregroundColor: Colors.black87,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).pushNamed(AppRoutes.signup),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
    );
  }
}
