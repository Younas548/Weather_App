import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'weather_provider.dart';
import 'home.dart';

class AppColors {
  static const paper = Color(0xFFFAF8F3);
  static const ink = Color(0xFF22262B);
  static const inkMuted = Color(0xFF6B7280);
  static const line = Color(0xFFE4E0D6);
  static const accent = Color(0xFF2B5876); // default/base accent
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

// 'serif' Flutter ka built-in generic font family hai (platform ka apna
// serif font use karta hai) — koi download/network/plugin ki zaroorat
// nahi, isliye desktop pe google_fonts wala crash bhi nahi aayega
const _headlineFont = 'serif';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          primary: AppColors.accent,
          surface: AppColors.paper,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: _headlineFont,
            fontSize: 64,
            fontWeight: FontWeight.w300,
            color: AppColors.ink,
          ),
          headlineSmall: TextStyle(
            fontFamily: _headlineFont,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          titleLarge: TextStyle(
            fontFamily: _headlineFont,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.ink),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.ink),
          bodySmall: TextStyle(fontSize: 13, color: AppColors.inkMuted),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.paper,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.ink,
          titleTextStyle: TextStyle(
            fontFamily: _headlineFont,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.line,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.inkMuted),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}