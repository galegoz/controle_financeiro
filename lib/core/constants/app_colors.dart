import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Primária
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF8B85FF);

  // Acento
  static const Color accent = Color(0xFF00D4AA);
  static const Color accentDark = Color(0xFF00B894);

  // Receita
  static const Color income = Color(0xFF00C896);
  static const Color incomeLight = Color(0xFFE6FAF5);
  static const Color incomeDark = Color(0xFF00A37A);

  // Despesa
  static const Color expense = Color(0xFFFF5B79);
  static const Color expenseLight = Color(0xFFFFEEF1);
  static const Color expenseDark = Color(0xFFE04060);

  // Orçamento - Indicadores
  static const Color budgetGreen = Color(0xFF00C896);
  static const Color budgetYellow = Color(0xFFFFB703);
  static const Color budgetOrange = Color(0xFFFF7A2F);
  static const Color budgetRed = Color(0xFFFF3B55);

  // Neutros - Light Mode
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1D2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Neutros - Dark Mode
  static const Color backgroundDark = Color(0xFF0F1020);
  static const Color surfaceDark = Color(0xFF1A1D2E);
  static const Color cardDark = Color(0xFF232640);
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color dividerDark = Color(0xFF2D3048);
  static const Color borderDark = Color(0xFF2D3048);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF8B85FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF00C896), Color(0xFF00D4AA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFF5B79), Color(0xFFFF8C9E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkHeaderGradient = LinearGradient(
    colors: [Color(0xFF1A1D2E), Color(0xFF232640)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
