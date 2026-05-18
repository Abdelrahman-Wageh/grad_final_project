import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/game_service.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({super.key});

  @override
  State<CharacterSelectionScreen> createState() => _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  int _selectedIndex = 0;
  List<Character> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    // In production, load from backend
    setState(() {
      _characters = [
        Character(
          type: 'bird',
          name: 'زقزق',
          nameEnglish: 'Zaqzaq',
          description: 'عصفورة جميلة ومرحة تحب الطيران والغناء',
          color: const Color(0xFF4FC3F7),
          imagePath: 'assets/images/characters/bird.png',
        ),
        Character(
          type: 'cat',
          name: 'مشمش',
          nameEnglish: 'Mishmish',
          description: 'قطة لطيفة وفضولية تحب اللعب والاستكشاف',
          color: const Color(0xFFFFB74D),
          imagePath: 'assets/images/characters/cat.png',
        ),
        Character(
          type: 'dog',
          name: 'فرفور',
          nameEnglish: 'Farfour',
          description: 'كلب وفي ومخلص يحب الجري واللعب',
          color: const Color(0xFFA1887F),
          imagePath: 'assets/images/characters/dog.png',
        ),
        Character(
          type: 'rabbit',
          name: 'أرنوب',
          nameEnglish: 'Arnoub',
          description: 'أرنب سريع ونشيط يحب القفز والجزر',
          color: const Color(0xFFE1BEE7),
          imagePath: 'assets/images/characters/rabbit.png',
        ),
        Character(
          type: 'bear',
          name: 'دبدوب',
          nameEnglish: 'Dabdoub',
          description: 'دب قوي وحنون يحب العسل والأحضان',
          color: const Color(0xFF8D6E63),
          imagePath: 'assets/images/characters/bear.png',
        ),
        Character(
          type: 'elephant',
          name: 'فيلو',
          nameEnglish: 'Filo',
          description: 'فيل ذكي وقوي يحب الماء ولديه ذاكرة قوية',
          color: const Color(0xFF90A4AE),
          imagePath: 'assets/images/characters/elephant.png',
        ),
        Character(
          type: 'lion',
          name: 'سمبا',
          nameEnglish: 'Simba',
          description: 'أسد شجاع وملك الغابة يحب المغامرات',
          color: const Color(0xFFFFD54F),
          imagePath: 'assets/images/characters/lion.png',
        ),
        Character(
          type: 'monkey',
          name: 'قردوش',
          nameEnglish: 'Qerdoush',
          description: 'قرد مرح ونشيط يحب التسلق والموز',
          color: const Color(0xFFAED581),
          imagePath: 'assets/images/characters/monkey.png',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6C63FF),
              Color(0xFF4F46E5),
              Color(0xFF7C3AED),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Title
                      Text(
                        'اختر صديقك',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'من سيرافقك في المغامرة؟',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white70,
                            ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 40),
                      
                      // Character Grid
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _characters.length,
                          itemBuilder: (context, index) {
                            return _buildCharacterCard(index);
                          },
                        ),
                      ),
                      
                      // Continue Button
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: ElevatedButton(
                          onPressed: () => _selectCharacter(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6C63FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'ابدأ المغامرة',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(width: 15),
                              const Icon(Icons.arrow_forward, size: 28),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCharacterCard(int index) {
    final character = _characters[index];
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? character.color : Colors.transparent,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? character.color.withOpacity(0.5)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character Image Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: character.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCharacterIcon(character.type),
                size: 50,
                color: character.color,
              ),
            ),
            const SizedBox(height: 15),
            
            // Character Name
            Text(
              character.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: character.color,
              ),
              textDirection: TextDirection.rtl,
            ),
            
            const SizedBox(height: 5),
            
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                character.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            ),
            
            // Selection Indicator
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: character.color,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '✓ مختار',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCharacterIcon(String type) {
    switch (type) {
      case 'bird':
        return Icons.flutter_dash;
      case 'cat':
        return Icons.pets;
      case 'dog':
        return Icons.pets_outlined;
      case 'rabbit':
        return Icons.cruelty_free;
      case 'bear':
        return Icons.cabin;
      case 'elephant':
        return Icons.nature;
      case 'lion':
        return Icons.pets;
      case 'monkey':
        return Icons.emoji_nature;
      default:
        return Icons.star;
    }
  }

  void _selectCharacter(BuildContext context) async {
    final character = _characters[_selectedIndex];
    final gameService = Provider.of<GameService>(context, listen: false);
    
    // Save character selection
    await gameService.selectCharacter(character.type, character.name);
    
    // Navigate to home screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}

class Character {
  final String type;
  final String name;
  final String nameEnglish;
  final String description;
  final Color color;
  final String imagePath;

  Character({
    required this.type,
    required this.name,
    required this.nameEnglish,
    required this.description,
    required this.color,
    required this.imagePath,
  });
}

