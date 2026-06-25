import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Brand Colors
class AppColors {
  static const Color ipackBlue = Color(0xFF0B2D5C);
  static const Color ipackOrange = Color(0xFFF58220);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF5F5F5);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnSecondary = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF0B2D5C);
  static const Color lightOnSurface = Color(0xFF0B2D5C);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF0B2D5C);
  static const Color darkSurface = Color(0xFF1A3A6C);
  static const Color darkOnPrimary = Color(0xFF0B2D5C);
  static const Color darkOnSecondary = Color(0xFF0B2D5C);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeConverterProvider);
    
    return MaterialApp(
      title: 'I-PACK',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.ipackBlue,
          secondary: AppColors.ipackOrange,
          surface: AppColors.lightSurface,
          onPrimary: AppColors.lightOnPrimary,
          onSecondary: AppColors.lightOnSecondary,
          onSurface: AppColors.lightOnSurface,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
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
      home: const HomeScreen(),
    );
  }
}
