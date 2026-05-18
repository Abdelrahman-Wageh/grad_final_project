import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/game_state.dart';
import '../utils/app_constants.dart';

class GameWorld extends StatelessWidget {
  final AnimationController controller;
  final GameState gameState;

  const GameWorld({
    super.key,
    required this.controller,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Background based on game state
              _buildBackground(),
              
              // Interactive elements
              _buildInteractiveElements(),
              
              // Floating particles/effects
              _buildParticleEffects(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground() {
    switch (gameState) {
      case GameState.forestAdventure:
        return _buildForestBackground();
      case GameState.castleExploration:
        return _buildCastleBackground();
      case GameState.drawingGame:
        return _buildDrawingBackground();
      default:
        return _buildForestBackground();
    }
  }

  Widget _buildForestBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.forestGreen,
            Color(0xFF2ECC71),
            Color(0xFF27AE60),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Trees
          Positioned(
            left: 50,
            bottom: 100,
            child: _buildTree().animate().slideX(
              begin: -1,
              duration: 2000.ms,
              curve: Curves.easeOut,
            ),
          ),
          Positioned(
            right: 80,
            bottom: 80,
            child: _buildTree().animate().slideX(
              begin: 1,
              duration: 2000.ms,
              delay: 500.ms,
              curve: Curves.easeOut,
            ),
          ),
          
          // Clouds
          Positioned(
            top: 50,
            left: 100,
            child: _buildCloud().animate().slideX(
              begin: -1,
              duration: 3000.ms,
              curve: Curves.easeInOut,
            ),
          ),
          
          // Sun
          Positioned(
            top: 80,
            right: 60,
            child: _buildSun().animate().scale(
              begin: const Offset(0, 0),
              duration: 1500.ms,
              curve: Curves.elasticOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastleBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.castlePurple,
            Color(0xFF8E44AD),
            Color(0xFF7D3C98),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Castle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCastle().animate().slideY(
              begin: 1,
              duration: 2000.ms,
              curve: Curves.easeOut,
            ),
          ),
          
          // Stars
          ...List.generate(10, (index) => _buildStar(index)),
        ],
      ),
    );
  }

  Widget _buildDrawingBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.oceanBlue,
            Color(0xFF5DADE2),
            Color(0xFF3498DB),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Drawing canvas area
          Positioned(
            top: 100,
            left: 50,
            right: 50,
            bottom: 200,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.primaryColor,
                  width: 3,
                ),
              ),
              child: const Center(
                child: Text(
                  '🎨 Drawing Area 🎨',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ).animate().scale(
              begin: const Offset(0, 0),
              duration: 1000.ms,
              curve: Curves.elasticOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTree() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Container(
          width: 120,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF228B22),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildCloud() {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildSun() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFFFD700),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildCastle() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF8B4513),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Castle towers
          Positioned(
            left: 20,
            top: -30,
            child: Container(
              width: 40,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF8B4513),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: -30,
            child: Container(
              width: 40,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF8B4513),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStar(int index) {
    return Positioned(
      top: 50 + (index * 30),
      left: 50 + (index * 40),
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ).animate().fadeIn(
        duration: 1000.ms,
        delay: (index * 200).ms,
      ),
    );
  }

  Widget _buildInteractiveElements() {
    // Add interactive game objects based on current state
    return Container();
  }

  Widget _buildParticleEffects() {
    // Add floating particles or magical effects
    return Container();
  }
}
