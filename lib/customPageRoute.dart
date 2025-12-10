import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.left,
  }) : super(
    transitionDuration: const Duration(milliseconds: 600),

    pageBuilder: (context, animation, secondaryAnimation) => child,

    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: _getBeginOffset(direction),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );

  // Helper function
  static Offset _getBeginOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}
 