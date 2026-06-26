import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Brand Colors
class AppColors {
  // Brand color aliases matching the user's color system
  static const Color ipackBlue = Color(0xFF42C8B7); // Primary Teal (#42C8B7)
  static const Color ipackOrange = Color(0xFF80E2D6); // Secondary/Dark Mode Teal (#80E2D6)
  
  static const Color primary = Color(0xFF42C8B7);
  static const Color secondary = Color(0xFF80E2D6);
  static const Color accent = Color(0xFF06B6D4);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Light theme colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF111827);
  static const Color lightOnSurface = Color(0xFF111827);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800 for cards
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  static const Color darkOnSecondary = Color(0xFFFFFFFF);
  static const Color darkOnBackground = Color(0xFFF8FAFC);
  static const Color darkOnSurface = Color(0xFFF8FAFC);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeConverterProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'I-PACK',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: AppColors.ipackBlue,
          secondary: AppColors.ipackOrange,
          surface: AppColors.lightSurface,
          onPrimary: AppColors.lightOnPrimary,
          onSecondary: AppColors.lightOnSecondary,
          onSurface: AppColors.lightOnSurface,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.ipackBlue,
          foregroundColor: AppColors.lightOnPrimary,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.ipackOrange,
          foregroundColor: AppColors.lightOnSecondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ipackBlue,
            foregroundColor: AppColors.lightOnPrimary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.ipackBlue,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ipackBlue,
            side: const BorderSide(color: AppColors.ipackBlue),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.ipackOrange,
          secondary: AppColors.ipackOrange,
          surface: AppColors.darkSurface,
          onPrimary: AppColors.darkOnPrimary,
          onSecondary: AppColors.darkOnSecondary,
          onSurface: AppColors.darkOnSurface,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkOnBackground,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.ipackOrange,
          foregroundColor: AppColors.darkOnSecondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ipackOrange,
            foregroundColor: AppColors.darkOnPrimary,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.ipackOrange,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.ipackOrange,
            side: const BorderSide(color: AppColors.ipackOrange),
          ),
        ),
      ),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
