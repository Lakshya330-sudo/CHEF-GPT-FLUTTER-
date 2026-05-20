import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'saved_recipes_screen.dart';
import 'profile_screen.dart';
import 'diet_setting_screen.dart';
import 'analyse_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  // Brand Colors
  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);
  static const Color pudinaGreen = Color(0xFF4CAF76);
  static const Color pudinaGreenLight = Color(0xFF6FD89A);

  int _currentIndex = 0;

  // ── Entrance animation controllers ──
  AnimationController? _greetingController;
  AnimationController? _ctaController;
  AnimationController? _menuCardsController;

  Animation<double>? _greetingFade;
  Animation<Offset>? _greetingSlide;
  Animation<double>? _ctaFade;
  Animation<Offset>? _ctaSlide;
  Animation<double>? _menuCardsFade;
  Animation<Offset>? _menuCardsSlide;


  @override
  void initState() {
    super.initState();

    // Tint the status bar to match the green banner
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _initAnimations();
  }

  void _initAnimations() {
    // Staggered entrance animations
    _greetingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _ctaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _menuCardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _greetingFade = CurvedAnimation(
      parent: _greetingController!,
      curve: Curves.easeOut,
    );
    _greetingSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _greetingController!,
      curve: Curves.easeOut,
    ));

    _ctaFade = CurvedAnimation(
      parent: _ctaController!,
      curve: Curves.easeOut,
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctaController!,
      curve: Curves.easeOut,
    ));

    _menuCardsFade = CurvedAnimation(
      parent: _menuCardsController!,
      curve: Curves.easeOut,
    );
    _menuCardsSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _menuCardsController!,
      curve: Curves.easeOut,
    ));


    // Fire them with stagger delays
    _greetingController!.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctaController!.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _menuCardsController!.forward();
    });
  }

  @override
  void dispose() {
    _greetingController?.dispose();
    _ctaController?.dispose();
    _menuCardsController?.dispose();
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
            // Content
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Green Curved Banner + Mascot ──
                    _buildGreenBanner(context),
                    const SizedBox(height: 8),

                    // ── Greeting with doodle icons ──
                    FadeTransition(
                      opacity: _greetingFade ?? kAlwaysCompleteAnimation,
                      child: SlideTransition(
                        position: _greetingSlide ?? const AlwaysStoppedAnimation(Offset.zero),
                        child: _buildGreetingWithDoodles(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Main CTA: Analyze my kitchen ──
                    FadeTransition(
                      opacity: _ctaFade ?? kAlwaysCompleteAnimation,
                      child: SlideTransition(
                        position: _ctaSlide ?? const AlwaysStoppedAnimation(Offset.zero),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          child: _buildMainCTA(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Menu Cards: Saved Recipe & Diet Setting ──
                    FadeTransition(
                      opacity: _menuCardsFade ?? kAlwaysCompleteAnimation,
                      child: SlideTransition(
                        position: _menuCardsSlide ?? const AlwaysStoppedAnimation(Offset.zero),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 24.0),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _buildMenuCard(
                                    'Saved Recipe',
                                    'assets/images/saved_recipe.svg',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SavedRecipesScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildMenuCard(
                                    'Diet Setting',
                                    'assets/images/diet_setting.svg',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const DietSettingScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ── Greeting text with decorative food doodles
  // ─────────────────────────────────────────────
  Widget _buildGreetingWithDoodles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Text(
            'Hello,\nSarthak!!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: charcoalInk,
              height: 1.15,
            ),
          ),
          // Decorative doodle — fork & spoon
          Positioned(
            right: 8,
            top: -4,
            child: Text(
              '🍴',
              style: TextStyle(
                fontSize: 28,
                color: charcoalInk.withValues(alpha: 0.15),
              ),
            ),
          ),
          // Decorative doodle — leaf
          Positioned(
            right: 50,
            top: 30,
            child: Text(
              '🌿',
              style: TextStyle(
                fontSize: 22,
                color: charcoalInk.withValues(alpha: 0.12),
              ),
            ),
          ),
          // Decorative doodle — chili
          Positioned(
            right: 0,
            bottom: -4,
            child: Text(
              '🌶️',
              style: TextStyle(
                fontSize: 24,
                color: charcoalInk.withValues(alpha: 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ── Green curved banner with gradient
  // ─────────────────────────────────────────────
  Widget _buildGreenBanner(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: 220 + statusBarHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Green curved background — now with gradient
          ClipPath(
            clipper: _CurvedBannerClipper(),
            child: Container(
              height: 180 + statusBarHeight,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [pudinaGreenLight, pudinaGreen],
                ),
              ),
            ),
          ),
          // "ChefGPT" Title
          Positioned(
            top: statusBarHeight + 20,
            left: 24,
            child: const Text(
              'ChefGPT',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: charcoalInk,
                height: 1.1,
              ),
            ),
          ),
          // Mascot (positioned right, overlapping the banner bottom)
          Positioned(
            right: 0,
            top: statusBarHeight + 10,
            child: SvgPicture.asset(
              'assets/images/mascot.svg',
              height: 210,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ── Main CTA with 3D press animation & ripple
  // ─────────────────────────────────────────────
  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: rotiBeige,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: charcoalInk.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Analyse my kitchen',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: charcoalInk,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose how to add your photo',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: charcoalInk.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              // ── Upload from device ──
              _buildSheetOption(
                context,
                icon: Icons.photo_library_rounded,
                label: 'Upload from Device',
                subtitle: 'Pick a photo from your gallery',
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 90,
                  );
                  if (image != null && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnalyseScreen(imagePath: image.path),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              // ── Use camera ──
              _buildSheetOption(
                context,
                icon: Icons.camera_alt_rounded,
                label: 'Use Camera',
                subtitle: 'Take a photo right now',
                onTap: () {
                  Navigator.pop(context);
                  
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: spiceRed.withValues(alpha: 0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: charcoalInk.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: spiceRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: spiceRed, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: charcoalInk,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: charcoalInk.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: charcoalInk.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCTA() {
    return _Pressable3DCard(
      color: spiceRed,
      borderRadius: 24,
      shadowOffset: const Offset(5, 5),
      onTap: () => _showImageSourceSheet(context),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
        child: Column(
          children: [
            // Camera + Briyani graphic
            SvgPicture.asset(
              'assets/images/cam_and_briyani.svg',
              height: 200,
            ),
            const SizedBox(height: 12),
            // "Analyze my kitchen." text
            const Text(
              'Analyze my kitchen.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: charcoalInk,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ── Menu card with 3D press animation & ripple
  // ─────────────────────────────────────────────
  Widget _buildMenuCard(String label, String iconAsset, {VoidCallback? onTap}) {
    return _Pressable3DCard(
      color: Colors.white,
      borderRadius: 20,
      shadowOffset: const Offset(4, 4),
      onTap: onTap ?? () {
        // Handle menu action
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label on top
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: charcoalInk,
              ),
            ),
            const SizedBox(height: 12),
            // Icon below, centered
            Center(
              child: SvgPicture.asset(
                iconAsset,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ── Bottom nav with elevation + active dot
  // ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: charcoalInk.withValues(alpha: 0.08),
            offset: const Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'assets/images/nav_home.svg'),
            _buildNavItem(1, 'assets/images/nav_saved.svg'),
            _buildNavItem(2, 'assets/images/nav_profile.svg'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconAsset) {
    final bool isActive = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SavedRecipesScreen(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileScreen(),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconAsset,
              height: 40,
              width: 40,
            ),
            const SizedBox(height: 4),
            // Active dot indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 5,
              width: isActive ? 5 : 0,
              decoration: BoxDecoration(
                color: spiceRed,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ── Pressable 3D Card — reusable widget
// ── Animates shadow + translate on press
// ── Includes InkWell ripple for tactile feel
// ─────────────────────────────────────────────
class _Pressable3DCard extends StatefulWidget {
  final Color color;
  final double borderRadius;
  final Offset shadowOffset;
  final VoidCallback? onTap;
  final Widget child;

  const _Pressable3DCard({
    required this.color,
    required this.borderRadius,
    required this.shadowOffset,
    required this.child,
    this.onTap,
  });

  @override
  State<_Pressable3DCard> createState() => _Pressable3DCardState();
}

class _Pressable3DCardState extends State<_Pressable3DCard>
    with SingleTickerProviderStateMixin {
  static const Color charcoalInk = Color(0xFF1A1A1A);

  late final AnimationController _pressController;
  late final Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pressAnimation = CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    _pressController.forward();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pressAnimation,
      builder: (context, child) {
        final double t = _pressAnimation.value;
        final double dx = widget.shadowOffset.dx * (1 - t);
        final double dy = widget.shadowOffset.dy * (1 - t);
        final double tx = widget.shadowOffset.dx * t;
        final double ty = widget.shadowOffset.dy * t;

        return Transform.translate(
          offset: Offset(tx, ty),
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapCancel: _handleTapCancel,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: charcoalInk, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: charcoalInk,
                    offset: Offset(dx, dy),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: InkWell(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  onTap: () {
                    _pressController.reverse();
                    widget.onTap?.call();
                  },
                  splashColor: charcoalInk.withValues(alpha: 0.08),
                  highlightColor: charcoalInk.withValues(alpha: 0.04),
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Custom clipper for the green curved banner background.
class _CurvedBannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 20,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
