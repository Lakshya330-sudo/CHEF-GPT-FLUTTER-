import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/gemini_service.dart';

class ChatWindowScreen extends StatefulWidget {
  final String imagePath;
  final String description;

  const ChatWindowScreen({
    super.key,
    required this.imagePath,
    this.description = '',
  });

  @override
  State<ChatWindowScreen> createState() => _ChatWindowScreenState();
}

// ── Message model ─────────────────────────────────────────────────────────────
class _ChatMessage {
  final bool isUser;
  final String? text;
  final String? imagePath;

  const _ChatMessage({required this.isUser, this.text, this.imagePath});
}

// ─────────────────────────────────────────────────────────────────────────────

class _ChatWindowScreenState extends State<ChatWindowScreen>
    with SingleTickerProviderStateMixin {
  static const Color spiceRed    = Color(0xFFE63946);
  static const Color rotiBeige   = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);
  static const Color bubbleBeige = Color(0xFFF5E6A3);

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Thinking animation
  late final AnimationController _dotsController;
  late final Animation<int> _dotsAnim;
  bool _isThinking = false;

  // Speech-to-text
  late final stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';

  // Gemini
  late final GeminiService _gemini;

  // Chat messages
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _dotsAnim = IntTween(begin: 1, end: 10).animate(_dotsController);

    _speech  = stt.SpeechToText();
    _gemini  = GeminiService();

    // Kick off the initial analysis automatically
    _startInitialAnalysis();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Initial image analysis on page open ──────────────────────────────────
  Future<void> _startInitialAnalysis() async {
    final String prompt = widget.description.trim().isNotEmpty
        ? 'Analyse this image and recommend some recipes to me according to '
          'my dietary requirements. Extra note: ${widget.description}'
        : 'Analyse this image and recommend some recipes to me according to '
          'my dietary requirements.';

    // Show user's image + auto prompt
    setState(() {
      _messages.add(_ChatMessage(isUser: true, imagePath: widget.imagePath));
      _messages.add(_ChatMessage(isUser: true, text: prompt));
      _isThinking = true;
    });
    _scrollToBottom();

    final String reply = await _gemini.sendWithImage(
      imageFile: File(widget.imagePath),
      text: prompt,
    );

    if (mounted) {
      setState(() {
        _isThinking = false;
        _messages.add(_ChatMessage(isUser: false, text: reply));
      });
      _scrollToBottom();
    }
  }

  // ── Send a follow-up text message ─────────────────────────────────────────
  Future<void> _sendMessage() async {
    final String text = _inputController.text.trim();
    if (text.isEmpty || _isThinking) return;

    _inputController.clear();
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text));
      _isThinking = true;
    });
    _scrollToBottom();

    final String reply = await _gemini.sendText(text);

    if (mounted) {
      setState(() {
        _isThinking = false;
        _messages.add(_ChatMessage(isUser: false, text: reply));
      });
      _scrollToBottom();
    }
  }

  // ── Speech-to-text ────────────────────────────────────────────────────────
  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      if (mounted) setState(() => _isListening = false);
    } else {
      try {
        final available = await _speech.initialize(
          onStatus: (status) {
            if (status == 'done' || status == 'notListening') {
              if (mounted) setState(() => _isListening = false);
            }
          },
          onError: (_) {
            if (mounted) setState(() => _isListening = false);
          },
        );
        if (available) {
          if (mounted) setState(() => _isListening = true);
          _speech.listen(
            onResult: (result) {
              if (mounted) {
                setState(() {
                  _lastWords = result.recognizedWords;
                  _inputController.text = _lastWords;
                  _inputController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _inputController.text.length),
                  );
                });
              }
            },
            localeId: 'en_US',
          );
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Speech recognition not available on this device.'),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: spiceRed,
              content: Text(
                'Speech not ready — please do a full restart.\n(${e.runtimeType})',
                style: const TextStyle(
                    fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
          );
        }
      }
    }
  }

  // ── + attach menu ─────────────────────────────────────────────────────────
  void _showAttachMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: rotiBeige,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: charcoalInk.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            _buildAttachOption(
              icon: Icons.photo_library_rounded,
              label: 'Upload image from device',
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final XFile? img = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 90,
                );
                if (img != null && mounted) {
                  // Add image to chat and send to Gemini for analysis
                  setState(() {
                    _messages
                        .add(_ChatMessage(isUser: true, imagePath: img.path));
                    _isThinking = true;
                  });
                  _scrollToBottom();
                  final String reply = await _gemini.sendWithImage(
                    imageFile: File(img.path),
                    text: 'What do you see in this image? Can you suggest '
                        'any recipes based on these ingredients?',
                  );
                  if (mounted) {
                    setState(() {
                      _isThinking = false;
                      _messages
                          .add(_ChatMessage(isUser: false, text: reply));
                    });
                    _scrollToBottom();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: spiceRed.withValues(alpha: 0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: charcoalInk.withValues(alpha: 0.05),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: spiceRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: spiceRed, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: charcoalInk,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                color: charcoalInk.withValues(alpha: 0.3), size: 15),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: rotiBeige,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              const Divider(color: charcoalInk, thickness: 1.2, height: 1),
              Expanded(child: _buildChatList()),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: spiceRed,
              size: 26,
            ),
          ),
          const Expanded(
            child: Text(
              'ChefGPT',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: spiceRed,
              ),
            ),
          ),
          const SizedBox(width: 26),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    final int total = _messages.length + (_isThinking ? 1 : 0);
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      itemCount: total,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, i) {
        if (i == _messages.length) return _buildThinkingRow();
        final msg = _messages[i];
        if (msg.imagePath != null) return _buildImageBubble(msg.imagePath!);
        return _buildTextBubble(msg.text ?? '', msg.isUser);
      },
    );
  }

  // ── Bubbles ───────────────────────────────────────────────────────────────
  Widget _buildImageBubble(String path) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: bubbleBeige,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: charcoalInk.withValues(alpha: 0.15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(File(path), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildTextBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? rotiBeige : Colors.white,
          borderRadius: isUser
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          border: Border.all(
            color: isUser ? spiceRed : charcoalInk.withValues(alpha: 0.12),
            width: isUser ? 1.8 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: charcoalInk.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: isUser ? TextAlign.center : TextAlign.start,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: charcoalInk,
            height: 1.55,
          ),
        ),
      ),
    );
  }

  Widget _buildThinkingRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: SvgPicture.asset(
            'assets/images/chat_window_icon.svg',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 12),
        AnimatedBuilder(
          animation: _dotsAnim,
          builder: (_, _) => Text(
            'Thinking${'.' * _dotsAnim.value}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: spiceRed,
            ),
          ),
        ),
      ],
    );
  }

  // ── Input bar ──────────────────────────────────────────────────────────────
  Widget _buildInputBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening)
          Container(
            width: double.infinity,
            color: spiceRed.withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                _PulsingDot(color: spiceRed),
                const SizedBox(width: 10),
                const Text(
                  'Listening…',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: spiceRed,
                  ),
                ),
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          height: 56,
          decoration: BoxDecoration(
            color: bubbleBeige,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: spiceRed, width: 1.8),
          ),
          child: Row(
            children: [
              // ── + button ──
              GestureDetector(
                onTap: _showAttachMenu,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: spiceRed, width: 2),
                    ),
                    child: const Icon(Icons.add, color: spiceRed, size: 20),
                  ),
                ),
              ),
              // ── Text field ──
              Expanded(
                child: TextField(
                  controller: _inputController,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      color: charcoalInk),
                  decoration: InputDecoration(
                    hintText:
                        _isListening ? 'Speaking…' : 'Ask something…',
                    hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: charcoalInk.withValues(alpha: 0.4)),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              // ── Send button (shows when text entered) OR mic ──
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (_, value, _) {
                  final hasText = value.text.trim().isNotEmpty;
                  return GestureDetector(
                    onTap: hasText ? _sendMessage : _toggleListening,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: hasText
                            ? Container(
                                key: const ValueKey('send'),
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: spiceRed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.send_rounded,
                                    color: Colors.white, size: 18),
                              )
                            : AnimatedContainer(
                                key: const ValueKey('mic'),
                                duration: const Duration(milliseconds: 200),
                                padding: _isListening
                                    ? const EdgeInsets.all(4)
                                    : EdgeInsets.zero,
                                decoration: _isListening
                                    ? BoxDecoration(
                                        color:
                                            spiceRed.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      )
                                    : null,
                                child: Icon(
                                  _isListening
                                      ? Icons.mic_rounded
                                      : Icons.mic_none_rounded,
                                  color: spiceRed,
                                  size: 28,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Pulsing red dot ────────────────────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
