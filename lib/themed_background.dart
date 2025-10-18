import 'package:flutter/material.dart';

class ThemedBackground extends StatelessWidget {
  final Widget child;

  const ThemedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            isDark
                ? 'assets/dark_mode_background.png'
                : 'assets/image.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
