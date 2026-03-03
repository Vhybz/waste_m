
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isSignedIn => currentUser != null;

  /// Sign in with Email and Password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Sign up with Email and Password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    try {
      return await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Sign in with Google (OAuth)
  /// Unified redirect URL with trailing slash for consistency
  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.waste_sort_ai://login-callback',
        queryParams: {'prompt': 'select_account'},
      );
    } on AuthException {
      rethrow;
    }
  }

  /// Send Password Reset Email
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
    } on AuthException {
      rethrow;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
