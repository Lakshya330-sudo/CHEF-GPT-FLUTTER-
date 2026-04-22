import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  // Brand Colors
  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);

  final List<String> _recipes = [
    'Aloo Gobi',
    'Paneer Paratha',
    'Salad',
    'Fruit Juice',
    'Fried Rice',
    'Jeera Rice',
    'Halwa',
  ];

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
            child: Column(
              children: [
                _buildAppBar(context),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildRecipeList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: spiceRed, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Saved Recipe',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: charcoalInk,
            ),
          ),
          const SizedBox(width: 48), // Padding to keep title centered
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: rotiBeige,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: spiceRed, width: 2),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: '',
            prefixIcon: Icon(Icons.search, color: spiceRed, size: 28),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: rotiBeige,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: spiceRed, width: 2),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _recipes[index],
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: charcoalInk,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: spiceRed, size: 28),
                  onPressed: () {
                    // Action for removing item
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
