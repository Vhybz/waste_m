
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
  /// Updated redirect to match WasteSort AI package name
  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
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
