import 'dart:io';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Replace the placeholder below with your actual Gemini API key.
/// Get yours free at: https://aistudio.google.com/app/apikey
/// ─────────────────────────────────────────────────────────────────────────────
const String _kGeminiApiKey = 'AIzaSyDejlvVKKY6faj5k6GWT2NbiMpTw9mv-Pk';

/// Manages a multi-turn Gemini chat session (text + optional image).
class GeminiService {
  static const String _model = 'gemini-2.5-flash';

  late final GenerativeModel _generativeModel;
  late final ChatSession _chat;

  bool get isConfigured => _kGeminiApiKey != 'YOUR_GEMINI_API_KEY_HERE';

  GeminiService() {
    _generativeModel = GenerativeModel(
      model: _model,
      apiKey: _kGeminiApiKey,
      systemInstruction: Content.system(
        'You are ChefGPT, a friendly AI sous-chef. '
        'When a user shares a photo of their ingredients or kitchen, '
        'analyse what you see and suggest creative, practical recipes '
        'tailored to their dietary preferences. '
        'Keep answers concise, warm, and encouraging. '
        'Format recipe suggestions clearly with ingredients and short steps.',
      ),
    );
    _chat = _generativeModel.startChat();
  }

  /// Send a text-only message and return the AI reply.
  Future<String> sendText(String message) async {
    if (!isConfigured) {
      return '⚠️ Please add your Gemini API key in `gemini_service.dart` to '
          'enable AI responses.';
    }
    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? '(No response)';
    } on GenerativeAIException catch (e) {
      return '❌ Gemini error: ${e.message}';
    } catch (e) {
      return '❌ Unexpected error: $e';
    }
  }

  /// Send a message with an image attachment.
  Future<String> sendWithImage({
    required File imageFile,
    required String text,
  }) async {
    if (!isConfigured) {
      return '⚠️ Please add your Gemini API key in `gemini_service.dart` to '
          'enable AI responses.';
    }
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final response = await _chat.sendMessage(
        Content.multi([
          DataPart('image/jpeg', imageBytes),
          TextPart(text),
        ]),
      );
      return response.text ?? '(No response)';
    } on GenerativeAIException catch (e) {
      return '❌ Gemini error: ${e.message}';
    } catch (e) {
      return '❌ Unexpected error: $e';
    }
  }
}
