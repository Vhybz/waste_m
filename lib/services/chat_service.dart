
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

      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      _chat = _model!.startChat(history: [
        Content.text(
          "You are a Waste Management and Recycling Expert Assistant inside the WasteSort AI app. "
          "Your purpose is to provide educational information about waste classification, recycling practices, and sustainability. "
          "RULES: "
          "1. Provide clear guidance on whether items are biodegradable, non-biodegradable, or recyclable. "
          "2. Offer practical tips for reducing waste and composting. "
          "3. If unsure about a specific local recycling rule, advise the user to check with their local municipality. "
          "4. Maintain an encouraging and eco-conscious tone."
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

      if (errorMsg.contains('not found') || errorMsg.contains('404')) {
        return "AI Error: The assistant model is currently being updated. We will be back online shortly.";
      }

      if (kIsWeb && errorMsg.contains('TypeError')) {
        return "Web Security Block: Chrome is blocking the AI. Please run with '--disable-web-security'.";
      }

      return "Assistant is currently offline. Please check your internet connection.";
    }
  }
}
