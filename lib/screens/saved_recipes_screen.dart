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

  String _searchQuery = '';

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
        child: TextField(
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: charcoalInk,
          ),
          onChanged: (val) {
            setState(() {
              _searchQuery = val.trim().toLowerCase();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search saved recipes…',
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
            prefixIcon: Icon(Icons.search, color: spiceRed, size: 28),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: spiceRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                color: spiceRed,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Saved Recipes',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: charcoalInk,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _recipes.isEmpty
                  ? 'Save your favorite recipes from the chat page to view them here later.'
                  : 'No recipes match your search query.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: charcoalInk.withValues(alpha: 0.6),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeList() {
    final filtered = _recipes
        .where((recipe) => recipe.toLowerCase().contains(_searchQuery))
        .toList();

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final recipe = filtered[index];
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
                    recipe,
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
                    setState(() {
                      _recipes.remove(recipe);
                    });
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
