import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/models/child_profile.dart';
import '../services/local_storage_service.dart';
import 'games_tab_view.dart';
import 'chapters_tab_view.dart';
import 'friend_tab_view.dart';
import 'dashboard_tab_view.dart';
import '../widgets/smartino_mascot_placeholder.dart';
import '../theme/smartino_colors.dart';

/// Main navigation screen with bottom tabs
/// Implements Requirements: 1.1 (Navigation), 17.7 (Mascot Overlay)
class MainNavigationScreen extends StatefulWidget {
  final String profileId;

  const MainNavigationScreen({
    super.key,
    required this.profileId,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  ChildProfile? _profile;
  MascotMood _mascotMood = MascotMood.idle;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final storage = context.read<LocalStorageService>();
    final profile = await storage.loadProfile(widget.profileId);
    if (mounted) {
      setState(() {
        _profile = profile;
      });
    }
  }

  void _onTabChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentIndex = index;
      // Update mascot mood based on tab
      _mascotMood = _getMoodForTab(index);
    });
  }

  MascotMood _getMoodForTab(int index) {
    switch (index) {
      case 0: // Games
        return MascotMood.excited;
      case 1: // Chapters
        return MascotMood.thinking;
      case 2: // Friend
        return MascotMood.happy;
      case 3: // Dashboard
        return MascotMood.idle;
      default:
        return MascotMood.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: [
              GamesTabView(profile: _profile!),
              ChaptersTabView(profile: _profile!),
              FriendTabView(profileId: widget.profileId),
              DashboardTabView(profile: _profile!),
            ],
          ),

          // Mascot overlay (top-right corner)
          Positioned(
            top: 60,
            right: 16,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() {
                  _mascotMood = MascotMood.happy;
                });
                // Reset mood after animation
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _mascotMood = _getMoodForTab(_currentIndex);
                    });
                  }
                });
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: SmartinoColors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SmartinoMascotPlaceholder(
                  mood: _mascotMood,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.games_rounded,
                label: 'ألعاب',
                emoji: '🎮',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.menu_book_rounded,
                label: 'فصول',
                emoji: '📚',
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.chat_bubble_rounded,
                label: 'صاحبي',
                emoji: '💬',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.dashboard_rounded,
                label: 'لوحتي',
                emoji: '⭐',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required String emoji,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? SmartinoColors.purple : Colors.grey;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? SmartinoColors.purple.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Emoji + Icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    emoji,
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 20,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: isSelected ? 14 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: color,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
