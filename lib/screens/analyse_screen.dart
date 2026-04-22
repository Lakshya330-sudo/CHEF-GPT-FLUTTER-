import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'diet_setting_screen.dart';
import 'chat_window_screen.dart';

class AnalyseScreen extends StatefulWidget {
  /// Path to the image picked from the gallery / camera.
  final String imagePath;

  const AnalyseScreen({super.key, required this.imagePath});

  @override
  State<AnalyseScreen> createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  static const Color spiceRed    = Color(0xFFE63946);
  static const Color rotiBeige   = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);
  static const Color boxBeige    = Color(0xFFF5E6A3);

  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: rotiBeige,
        body: Stack(
          children: [
            // ── Background food-pattern overlay ──
            Positioned.fill(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/images/background_overlay.png',
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),

            // ── Foreground content ──
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── App-bar row ──
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
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
                            'Analyze',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: charcoalInk,
                            ),
                          ),
                        ),
                        const SizedBox(width: 26),
                      ],
                    ),
                  ),

                  const Divider(
                      color: Color(0xFFD9D9D9), thickness: 1, height: 1),

                  // ── Scrollable body ──
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Uploaded image preview ──
                          Container(
                            width: double.infinity,
                            height: 260,
                            decoration: BoxDecoration(
                              color: boxBeige,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: charcoalInk, width: 1.8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(
                                File(widget.imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Description label ──
                          const Text(
                            'Description box',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: charcoalInk,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ── Description text-field ──
                          Container(
                            decoration: BoxDecoration(
                              color: boxBeige,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: charcoalInk, width: 1.8),
                            ),
                            child: TextField(
                              controller: _descController,
                              maxLines: 8,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: charcoalInk,
                              ),
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                hintText: 'Add some more ingredients',
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: charcoalInk.withValues(alpha: 0.45),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Bottom buttons ──
                          Row(
                            children: [
                              // Diet Setting
                              Expanded(
                                child: _buildRedButton(
                                  label: 'Diet Setting',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DietSettingScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Analyze Photo
                              Expanded(
                                child: _buildRedButton(
                                  label: 'Analyze Photo',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChatWindowScreen(
                                          imagePath: widget.imagePath,
                                          description:
                                              _descController.text,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: spiceRed,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: spiceRed.withValues(alpha: 0.35),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
