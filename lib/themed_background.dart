import 'package:flutter/material.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: [
          // Background image with Key for testing
          Positioned.fill(
            child: Image.asset(
              isDark ? 'assets/dark_mode_background.png' : 'assets/image.jpeg',
              fit: BoxFit.cover,
              key: Key(isDark ? 'dark_background' : 'light_background'),
            ),
          ),

          // Overlay container with Key for testing
          Container(
            key: const Key('background_overlay'),
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.white.withOpacity(0.1),
          ),

          // Child content
          SafeArea(child: child),
        ],
      ),
    );
  }
}


