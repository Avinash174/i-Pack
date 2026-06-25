import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme mode enum
enum ThemeModeOption {
  system,
  light,
  dark,
}

// Theme mode provider
class ThemeModeNotifier extends StateNotifier<ThemeModeOption> {
  ThemeModeNotifier() : super(ThemeModeOption.system) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme_mode');
    if (savedTheme != null) {
      state = ThemeModeOption.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeModeOption.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }
}

// Provider for theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeModeOption>(
  (ref) => ThemeModeNotifier(),
);

// Provider to convert ThemeModeOption to ThemeMode
final themeModeConverterProvider = Provider<ThemeMode>((ref) {
  final mode = ref.watch(themeModeProvider);
  switch (mode) {
    case ThemeModeOption.system:
      return ThemeMode.system;
    case ThemeModeOption.light:
      return ThemeMode.light;
    case ThemeModeOption.dark:
      return ThemeMode.dark;
  }
});
