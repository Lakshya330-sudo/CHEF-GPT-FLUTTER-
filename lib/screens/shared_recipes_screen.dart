import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SharedRecipesScreen extends StatefulWidget {
  const SharedRecipesScreen({super.key});

  @override
  State<SharedRecipesScreen> createState() => _SharedRecipesScreenState();
}

class _SharedRecipesScreenState extends State<SharedRecipesScreen> {
  // Brand Colors
  static const Color spiceRed = Color(0xFFE63946);
  static const Color rotiBeige = Color(0xFFFFF8E1);
  static const Color charcoalInk = Color(0xFF1A1A1A);

  final List<Map<String, String>> _sharedRecipes = [
    {'title': 'Butter Chicken', 'sharedBy': 'Priya S.'},
    {'title': 'Masala Dosa', 'sharedBy': 'Rahul K.'},
    {'title': 'Biryani', 'sharedBy': 'Ananya M.'},
    {'title': 'Dal Makhani', 'sharedBy': 'Arjun R.'},
    {'title': 'Pav Bhaji', 'sharedBy': 'Sneha T.'},
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
            'Shared Recipes',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: charcoalInk,
            ),
          ),
          const SizedBox(width: 48), // Balance for back button
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
            hintText: 'Search shared recipes...',
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
      itemCount: _sharedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _sharedRecipes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: rotiBeige,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: spiceRed, width: 2),
            ),
            child: Row(
              children: [
                // Recipe icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: spiceRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.restaurant_menu, color: spiceRed, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['title']!,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: charcoalInk,
                        ),
                      ),
                      Text(
                        'Shared by ${recipe['sharedBy']!}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: charcoalInk.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: spiceRed, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }
}
