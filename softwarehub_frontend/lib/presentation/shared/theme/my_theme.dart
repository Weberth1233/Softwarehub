import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_typography.dart';

class MyTheme {
  static final TextTheme _textTheme = TextTheme(
    headlineLarge: ThemeTypography.heading1Text,
    headlineMedium: ThemeTypography.heading2Text,
    headlineSmall: ThemeTypography.heading3Text,
    bodyLarge: ThemeTypography.heading4Text,
    bodyMedium: ThemeTypography.paragraphText,
    bodySmall: ThemeTypography.smallText,
  );

  static ThemeData get defaultTheme => ThemeData(
    scaffoldBackgroundColor: ThemeColor.primaryColor,
    cardTheme: CardThemeData(color: ThemeColor.primaryColor, elevation: 2),
    colorScheme: const ColorScheme.light(
      primary: ThemeColor.primaryColor,
      secondary: ThemeColor.secondaryColor,
      onSecondary: ThemeColor.colorVariantWhite,
      tertiary: ThemeColor.colorVarianteBlack,
      onSurface: ThemeColor.greyColor,
    ),
    iconTheme: IconThemeData(color: ThemeColor.iconColor, size: 40),
    textTheme: _textTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColor.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(5),
            right: Radius.circular(5),
          ),
        ),
      ),
    ),

    scrollbarTheme: ScrollbarThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged)) {
          return ThemeColor.secondaryColor; // Destaque máximo ao arrastar
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.grey.withOpacity(0.9);
        }
        return Colors.grey.withOpacity(0.6);
      }),

      trackColor: WidgetStateProperty.all(Colors.black.withOpacity(0.06)),

      thickness: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.dragged)) {
          return 10.0;
        }
        return 6.0;
      }),

      trackBorderColor: WidgetStateProperty.all(Colors.transparent),

      radius: const Radius.circular(99),

      thumbVisibility: WidgetStateProperty.all(true),
      trackVisibility: WidgetStateProperty.all(true),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: const TextStyle(color: ThemeColor.secondaryColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.transparent, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: ThemeColor.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    ),
  );
}
