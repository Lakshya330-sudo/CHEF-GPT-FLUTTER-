import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DietSettingScreen extends StatefulWidget {
  const DietSettingScreen({super.key});

  @override
  State<DietSettingScreen> createState() => _DietSettingScreenState();
}

class _DietSettingScreenState extends State<DietSettingScreen> {
  // Brand colours (matching the rest of the app)
  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);
  static const Color checkboxBeige = Color(0xFFF5E6A3);

  // Diet options: label, asset path, selected state
  final List<_DietOption> _options = [
    _DietOption(label: 'Vegan', assetPath: 'assets/images/diet_vegan.svg'),
    _DietOption(label: 'Keto', assetPath: 'assets/images/diet_keto.svg'),
    _DietOption(label: 'Low Carbs', assetPath: 'assets/images/diet_low_carbs.svg'),
    _DietOption(label: 'Gluten-Free', assetPath: 'assets/images/diet_gluten_free.svg'),
    _DietOption(label: 'Fasting', assetPath: 'assets/images/diet_fasting.svg'),
    _DietOption(label: 'Low salt', assetPath: 'assets/images/diet_low_salt.svg'),
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDiets = prefs.getStringList('selected_diets') ?? [];
    setState(() {
      for (var option in _options) {
        option.selected = savedDiets.contains(option.label);
      }
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedDiets = _options
        .where((opt) => opt.selected)
        .map((opt) => opt.label)
        .toList();
    await prefs.setStringList('selected_diets', selectedDiets);
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
                            'Diet Setting',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: charcoalInk,
                            ),
                          ),
                        ),
                        // Balance the back arrow width
                        const SizedBox(width: 26),
                      ],
                    ),
                  ),

                  const Divider(color: Color(0xFFD9D9D9), thickness: 1, height: 1),

                  // ── Scrollable body ──
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Section title ──
                          const Text(
                            'Dietary Preferences',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: charcoalInk,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Diet option rows ──
                          ..._options.map((opt) => _buildDietRow(opt)),

                          const SizedBox(height: 32),

                          // ── Save Setting button ──
                          Center(
                            child: SizedBox(
                              width: 240,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: spiceRed,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 4,
                                  shadowColor: spiceRed.withValues(alpha: 0.4),
                                ),
                                 onPressed: () async {
                                   await _saveSettings();
                                   if (context.mounted) {
                                     Navigator.pop(context);
                                   }
                                 },
                                child: const Text(
                                  'Save Setting',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
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

  Widget _buildDietRow(_DietOption option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: GestureDetector(
        onTap: () => setState(() => option.selected = !option.selected),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: spiceRed,
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: charcoalInk.withValues(alpha: 0.06),
                offset: const Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
            child: Row(
              children: [
                // ── Diet icon ──
                SizedBox(
                  width: 52,
                  height: 52,
                  child: option.assetPath != null
                      ? SvgPicture.asset(
                          option.assetPath!,
                          fit: BoxFit.contain,
                        )
                      : const Icon(
                          Icons.local_dining_rounded,
                          size: 36,
                          color: charcoalInk,
                        ),
                ),
                const SizedBox(width: 14),

                // ── Label ──
                Expanded(
                  child: Text(
                    option.label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: charcoalInk,
                    ),
                  ),
                ),

                // ── Custom checkbox ──
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: option.selected ? spiceRed : checkboxBeige,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: option.selected ? spiceRed : const Color(0xFFD4B56A),
                      width: 1.5,
                    ),
                  ),
                  child: option.selected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 22)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Simple data class for a diet option ──
class _DietOption {
  final String label;
  final String? assetPath;
  bool selected = false;

  _DietOption({
    required this.label,
    required this.assetPath,
  });
}
