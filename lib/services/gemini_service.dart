import 'dart:io';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

const String _kGeminiApiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
);

/// Maximum number of automatic retries for transient failures.
const int _kMaxRetries = 3;

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
        'Tu ChefGPT hai — ek expert Indian home chef aur AI assistant. '
        'Jab bhi user koi image share kare, sabse pehle us image mein '
        'dikhne wale saare ingredients ko dhyan se identify kar. '
        'Phir sirf unhi identified ingredients aur common Indian pantry '
        'staples (jaise atta, chawal, dal, haldi, jeera, sarson, laal mirch, '
        'dhaniya powder, garam masala, namak, tel, pyaaz, lahsun, adrak, '
        'tamatar) ka use karke recipes suggest kar. '
        'Jo ingredient image mein nahi hai aur pantry staple bhi nahi hai, '
        'use recipe mein mat daalna. '
        'Mostly Indian dishes suggest kar '
        'Western dishes bahut kam suggest karna, aur sirf tab jab ingredients '
        'clearly western hon. '
        'Apna saara response Hinglish mein de — matlab Hindi aur English '
        'ka mix, jaise aam Indian log baat karte hain. '
        'Tone warm, encouraging aur ghar jaisi rakhna. '
        'Recipe ka format clear rakho: ingredients list aur short steps. '
        'IMPORTANT: Do NOT use any markdown formatting — no *, **, #, ##, '
        '- bullet points, or backticks. Write in plain text only.',
      ),
    );
    _chat = _generativeModel.startChat();
  }

  // ── Friendly error handler ────────────────────────────────────────────────
  /// Returns `true` if the error looks transient (503 / 429 / network).
  bool _isTransientError(Object error) {
    final msg = error.toString().toLowerCase();
    return msg.contains('503') ||
        msg.contains('429') ||
        msg.contains('unavailable') ||
        msg.contains('overloaded') ||
        msg.contains('high demand') ||
        msg.contains('deadline') ||
        msg.contains('timeout') ||
        msg.contains('socket') ||
        msg.contains('connection');
  }

  /// Converts a raw exception into a short, user-friendly message.
  String _friendlyError(Object error) {
    final msg = error.toString().toLowerCase();

    if (msg.contains('503') ||
        msg.contains('unavailable') ||
        msg.contains('overloaded') ||
        msg.contains('high demand')) {
      return '🍳 Our AI chef is taking a short break due to high demand. '
          'Please try again in a moment!';
    }
    if (msg.contains('429') || msg.contains('rate') || msg.contains('quota')) {
      return '⏳ You\'ve been cooking up a storm! Please wait a few seconds '
          'before sending another message.';
    }
    if (msg.contains('timeout') || msg.contains('deadline')) {
      return '⏱️ The request took too long. Please check your connection '
          'and try again.';
    }
    if (msg.contains('socket') ||
        msg.contains('connection') ||
        msg.contains('network') ||
        msg.contains('host')) {
      return '📶 Couldn\'t reach the server. Please check your internet '
          'connection and try again.';
    }
    if (msg.contains('invalid') && msg.contains('key')) {
      return '🔑 API key issue — please verify the Gemini API key in settings.';
    }
    if (msg.contains('permission') || msg.contains('forbidden')) {
      return '🚫 Access denied. The API key may not have the required '
          'permissions.';
    }
    if (msg.contains('safety')) {
      return '⚠️ The response was blocked by content safety filters. '
          'Try rephrasing your request.';
    }
    // Generic fallback — still friendly, no raw JSON
    return '😕 Something went wrong. Please try again in a moment.';
  }

  // ── Markdown stripper ────────────────────────────────────────────────────
  /// Removes common markdown symbols from AI responses so they render as
  /// clean plain text in the chat UI.
  String _stripMarkdown(String text) {
    return text
        // Remove heading markers (## Heading)
        .replaceAll(RegExp(r'^#{1,6}\s*', multiLine: true), '')
        // Remove bold/italic (**, *, __, _)
        .replaceAll(RegExp(r'\*{1,3}'), '')
        .replaceAll(RegExp(r'_{1,2}'), '')
        // Remove inline code (` backtick`)
        .replaceAll(RegExp(r'`{1,3}'), '')
        // Remove leading bullet/dash markers (- item or * item)
        .replaceAll(RegExp(r'^[\-\*]\s+', multiLine: true), '')
        // Remove numbered list markers (1. 2. etc)
        .replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '')
        // Collapse multiple blank lines into one
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  // ── Retry helper ──────────────────────────────────────────────────────────
  Future<String> _withRetry(Future<String> Function() action) async {
    for (int attempt = 0; attempt <= _kMaxRetries; attempt++) {
      try {
        return await action();
      } on GenerativeAIException catch (e) {
        if (attempt < _kMaxRetries && _isTransientError(e)) {
          // Exponential backoff: 1s, 2s, 4s
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        return _friendlyError(e);
      } catch (e) {
        if (attempt < _kMaxRetries && _isTransientError(e)) {
          await Future.delayed(Duration(seconds: 1 << attempt));
          continue;
        }
        return _friendlyError(e);
      }
    }
    // Should never reach here, but just in case:
    return _friendlyError('max retries exceeded');
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Send a text-only message and return the AI reply.
  Future<String> sendText(String message) async {
    if (!isConfigured) {
      return '⚠️ Please add your Gemini API key in `gemini_service.dart` to '
          'enable AI responses.';
    }
    return _withRetry(() async {
      final response = await _chat.sendMessage(Content.text(message));
      return _stripMarkdown(response.text ?? '(No response)');
    });
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
    return _withRetry(() async {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final response = await _chat.sendMessage(
        Content.multi([
          DataPart('image/jpeg', imageBytes),
          TextPart(text),
        ]),
      );
      return _stripMarkdown(response.text ?? '(No response)');
    });
  }
}
