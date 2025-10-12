import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);
  void setTheme(ThemeMode mode) => value = mode;
}

final themeNotifier = ThemeNotifier();






