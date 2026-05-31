import 'package:flutter/material.dart';

class AppColors {
  // Dark Theme - Baseado em referências Figma premium
  static const Color darkBgPrimary = Color(0xFF0B1120);
  static const Color darkBgSecondary = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF334155);
  static const Color darkGlass = Color(0x0DFFFFFF); // 5% white
  static const Color darkGlassBorder = Color(0x1AFFFFFF); // 10% white
  
  // Light Theme
  static const Color lightBgPrimary = Color(0xFFF8FAFC);
  static const Color lightBgSecondary = Color(0xFFE2E8F0);
  static const Color lightSurface = Color(0xFFCBD5E1);
  static const Color lightGlass = Color(0x66FFFFFF);
  static const Color lightGlassBorder = Color(0x40000000);
  
  // Text
  static const Color textDarkPrimary = Color(0xFFF1F5F9);
  static const Color textDarkSecondary = Color(0xFF94A3B8);
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF64748B);
  
  // Gradients Dinâmicos
  static const List<Color> gradientSunny = [
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
  ];
  static const List<Color> gradientCloudy = [
    Color(0xFF64748B),
    Color(0xFF475569),
  ];
  static const List<Color> gradientRainy = [
    Color(0xFF3B82F6),
    Color(0xFF1E40AF),
  ];
  static const List<Color> gradientNight = [
    Color(0xFF1E1B4B),
    Color(0xFF312E81),
  ];
  
  // Accents
  static const Color accentPrimary = Color(0xFF3B82F6);
  static const Color accentSecondary = Color(0xFF06B6D4);
  static const Color accentSuccess = Color(0xFF10B981);
  static const Color accentWarning = Color(0xFFF59E0B);
  static const Color accentError = Color(0xFFEF4444);
}