import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'login_screen.dart';

class StartingScreen extends StatelessWidget {
  const StartingScreen({super.key});

  // Color palette
  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);
  static const Color pudinaGreen = Color(0xFF4CAF76);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rotiBeige,
      body: Stack(
        children: [
          // Layer 1: Food pattern background overlay
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
          // Layer 2: Main content
          SafeArea(
            child: Column(
              children: [
                // Top spacer
                const Spacer(flex: 2),
                // Mascot
                SvgPicture.asset(
                  'assets/images/mascot.svg',
                  width: 260,
                  height: 260,
                ),
                const SizedBox(height: 16),
                // Title: "ChefGPT"
                const Text(
                  'ChefGPT',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: charcoalInk,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                // Tagline: "Cook Smart, Eat Well"
                const Text(
                  'Cook Smart,\nEat Well',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: spiceRed,
                    height: 1.3,
                  ),
                ),
                // Bottom spacer
                const Spacer(flex: 3),
                // "Get Started" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: spiceRed,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: spiceRed.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
