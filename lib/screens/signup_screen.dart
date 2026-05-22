import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Color palette
  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);

  bool _obscurePassword = true;
  bool _agreeToTOS = false;

  // Controllers for validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email.trim());
  }

  void _validate(BuildContext context) {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError(context, 'Please fill in all fields');
      return;
    }
    if (name.length < 2) {
      _showError(context, 'Please enter your full name');
      return;
    }
    if (!_isValidEmail(email)) {
      _showError(context, 'Please enter a valid email address');
      return;
    }
    if (password.length < 6) {
      _showError(context, 'Password must be at least 6 characters');
      return;
    }
    if (!_agreeToTOS) {
      _showError(context, 'Please agree to the Terms of Service');
      return;
    }

    Navigator.pop(context);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: spiceRed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: rotiBeige,
      body: Stack(
        children: [
          // Background overlay
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Header: "Join ChefGPT"
                    _buildJoinHeader(),
                    const SizedBox(height: 20),
                    // Mascot
                    SvgPicture.asset(
                      'assets/images/login_mascot.svg',
                      height: 180,
                    ),
                    const SizedBox(height: 20),
                    // "CREATE YOUR ACCOUNT"
                    const Text(
                      'CREATE YOUR ACCOUNT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: charcoalInk,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Name field
                    _buildInputField(
                      controller: _nameController,
                      hintText: 'Name',
                      iconAsset: 'assets/images/profile_icon.svg',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    // Email field
                    _buildInputField(
                      controller: _emailController,
                      hintText: 'Email/Username',
                      iconAsset: 'assets/images/mail_icon.svg',
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    // Password field
                    _buildInputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      iconAsset: 'assets/images/lock.svg',
                      obscureText: _obscurePassword,
                      isPassword: true,
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    // TOS Checkbox Row
                    _buildTOSRow(),
                    const SizedBox(height: 24),
                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => _validate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: spiceRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: const BorderSide(
                              color: charcoalInk,
                              width: 2,
                            ),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Create Account'),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Footer: Already have an account? Log in
                    _buildFooter(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinHeader() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          fontFamily: 'Poppins',
        ),
        children: [
          TextSpan(
            text: 'Join ',
            style: TextStyle(color: charcoalInk),
          ),
          TextSpan(
            text: 'ChefGPT',
            style: TextStyle(color: spiceRed),
          ),
        ],
      ),
    );
  }

  Widget _buildTOSRow() {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            unselectedWidgetColor: charcoalInk,
          ),
          child: Checkbox(
            value: _agreeToTOS,
            activeColor: spiceRed,
            onChanged: (value) {
              setState(() {
                _agreeToTOS = value ?? false;
              });
            },
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: charcoalInk,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
                    color: spiceRed,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: spiceRed,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: charcoalInk,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            foregroundColor: spiceRed,
            padding: EdgeInsets.zero,
          ),
          child: const Text(
            'Log in',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String iconAsset,
    required bool obscureText,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: rotiBeige,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: charcoalInk,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: charcoalInk,
              ),
              cursorColor: charcoalInk,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: charcoalInk.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (isPassword)
            IconButton(
              onPressed: onToggleVisibility,
              icon: SvgPicture.asset(
                obscureText ? 'assets/images/hidden_icon.svg' : 'assets/images/hidden_icon.svg', // Assuming hidden_icon for both for now based on mockup
                width: 24,
                height: 24,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
