import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF1E293B); // Deep slate indigo
  static const Color primaryAccent = Color(0xFF4F46E5); // Rich Royal Purple/Indigo
  static const Color secondaryAccent = Color(0xFF0D9488); // Deep Teal
  
  // Backgrounds
  static const Color background = Color(0xFFF8FAFC); // Clean off-white
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  
  // Status & Messaging
  static const Color errorBackground = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFCA5A5);
  static const Color errorText = Color(0xFF991B1B);
  
  static const Color successBackground = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFF6EE7B7);
  static const Color successText = Color(0xFF065F46);

  static const Color infoBackground = Color(0xFFEFF6FF);
  static const Color infoText = Color(0xFF1E40AF);
  
  // Neutral Text & Borders
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  
  // Card Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF312E81), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
