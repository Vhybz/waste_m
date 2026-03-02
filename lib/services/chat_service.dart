
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final supabase = Supabase.instance.client;
  GenerativeModel? _model;
  ChatSession? _chat;
  bool _isInitialized = false;

  /// Initializes the AI model using the key from Supabase
  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      final session = supabase.auth.currentSession;
      if (session == null) throw Exception("AUTH_ERROR");

      final response = await supabase
          .from('app_config')
          .select('value')
          .eq('id', 'gemini_api_key')
          .maybeSingle();

      final String? apiKey = response?['value'];
      if (apiKey == null || apiKey.isEmpty) throw Exception("CONFIG_ERROR");

      // Use the explicit model name that Google AI Studio expects
      _model = GenerativeModel(
        model: 'gemini-1.5-flash', 
        apiKey: apiKey,
      );

      _chat = _model!.startChat(history: [
        Content.text(
          "You are an AI Health Assistant inside a mobile Anemia Screening App. "
          "IMPORTANT: You are NOT a doctor. You NEVER diagnose. Only laboratory blood tests diagnose anemia. "
          "Respond professionally and prioritize user safety."
        ),
      ]);

      _isInitialized = true;
      debugPrint('ChatService: AI successfully initialized.');
    } catch (e) {
      debugPrint('ChatService Init Error: $e');
      rethrow;
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      await _initialize();

      if (message.trim().isEmpty) return "Please enter a message.";

      final response = await _chat!.sendMessage(Content.text(message));
      final text = response.text;

      if (text == null || text.isEmpty) {
        return "Assistant: I couldn't generate a response. Please try rephrasing.";
      }

      return text;
    } catch (e) {
      debugPrint('--- MASTER DEBUG: AI ASSISTANT ERROR ---');
      debugPrint('Detailed Error: $e');

      String errorMsg = e.toString();

      // Displaying more specific errors to help you debug
      if (errorMsg.contains('v1beta') || errorMsg.contains('not found')) {
        return "AI Configuration Error: Google is reporting that this model ID is not found. Please ensure 'Generative Language API' is enabled in your Google Console.";
      }

      if (kIsWeb && errorMsg.contains('TypeError')) {
        return "Web Security Block: Chrome is blocking the AI. Please run with '--disable-web-security'.";
      }

      if (errorMsg.contains('403')) {
        return "Access Denied: The API key in Supabase may be incorrect or restricted.";
      }

      return "Assistant Error: ${errorMsg.split(':').last.trim()}";
    }
  }
}
