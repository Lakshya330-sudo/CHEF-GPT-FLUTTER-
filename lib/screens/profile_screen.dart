import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'starting_screen.dart';
import 'shared_recipes_screen.dart';
import 'diet_setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rotiBeige,
      body: Stack(
        children: [
          // Background food pattern overlay
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
          
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                // ── Top Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: spiceRed,
                          size: 28,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: charcoalInk,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Balance for the back button
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // ── Avatar Area ──
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: spiceRed,
                      width: 4,
                    ),
                    color: Colors.transparent,
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/images/profile_icon.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // ── User Info ──
                const Text(
                  'Sarthak Sarin',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: charcoalInk,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'sarthaksarin@123.com',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: charcoalInk,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Member since: 2026',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: spiceRed,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // ── Preferences Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preferences',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: charcoalInk,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMenuItem(
                        'Diet Restrictions',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DietSettingScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem('Account'),
                      _buildMenuItem('Notifications'),
                      _buildMenuItem(
                        'Shared Recipe',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SharedRecipesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // ── Log Out Button ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StartingScreen(),
                          ),
                          (route) => false, // Clears the navigation stack
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: spiceRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: rotiBeige,
                        ),
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: charcoalInk,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: charcoalInk,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
