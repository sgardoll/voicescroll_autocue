import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the teleprompter application.
/// Implements Professional Minimalism design with High-Contrast Professional color scheme
/// optimized for various lighting conditions and extended reading sessions.
class AppTheme {
  AppTheme._();

  // High-Contrast Professional Color Palette
  // Deep, readable colors optimized for various lighting conditions
  static const Color primary = Color(0xFF1A1A1A); // Deep charcoal for maximum text contrast
  static const Color secondary = Color(0xFF2D2D30); // Subtle interface backgrounds
  static const Color accent = Color(0xFF007AFF); // iOS-inspired blue for interactive elements
  static const Color success = Color(0xFF34C759); // Clear positive feedback
  static const Color warning = Color(0xFFFF9500); // Attention-grabbing alerts
  static const Color error = Color(0xFFFF3B30); // Critical system alerts
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure white for maximum readability
  static const Color textSecondary = Color(0xFF8E8E93); // Muted text for supporting information
  static const Color surface = Color(0xFF000000); // True black for full-screen reading mode
  static const Color border = Color(0xFF48484A); // Minimal separation lines

  // Light theme variations (for settings and non-reading interfaces)
  static const Color primaryLight = Color(0xFFFFFFFF);
  static const Color secondaryLight = Color(0xFFF2F2F7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF8E8E93);

  // Shadow and divider colors with minimal opacity
  static const Color shadowDark = Color(0x1A000000); // 2-4dp shadows with 0.1 opacity
  static const Color shadowLight = Color(0x0A000000);
  static const Color dividerDark = Color(0x1A48484A);
  static const Color dividerLight = Color(0x1A8E8E93);

  /// Dark theme - Primary theme for teleprompter application
  /// Optimized for OLED displays and extended reading sessions
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: accent,
      onPrimary: textPrimary,
      primaryContainer: primary,
      onPrimaryContainer: textPrimary,
      secondary: secondary,
      onSecondary: textPrimary,
      secondaryContainer: secondary,
      onSecondaryContainer: textPrimary,
      tertiary: accent,
      onTertiary: textPrimary,
      tertiaryContainer: secondary,
      onTertiaryContainer: textPrimary,
      error: error,
      onError: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: border,
      outlineVariant: dividerDark,
      shadow: shadowDark,
      scrim: surface,
      inverseSurface: primaryLight,
      onInverseSurface: textPrimaryLight,
      inversePrimary: primary,
    ),
    scaffoldBackgroundColor: surface,
    cardColor: secondary,
    dividerColor: border,
    
    // AppBar theme for professional, distraction-free interface
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0, // Minimal elevation for clean appearance
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme with subtle elevation
    cardTheme: CardTheme(
      color: secondary,
      elevation: 2.0, // Minimal 2dp shadow
      shadowColor: shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),

    // Bottom navigation optimized for essential functions
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: secondary,
      selectedItemColor: accent,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    // Floating action button for contextual controls
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: textPrimary,
      elevation: 4.0,
      focusElevation: 6.0,
      hoverElevation: 6.0,
      highlightElevation: 8.0,
    ),

    // Button themes with professional styling
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: textPrimary,
        backgroundColor: accent,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: const BorderSide(color: accent, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
    ),

    // Typography optimized for teleprompter readability
    textTheme: _buildDarkTextTheme(),

    // Input decoration for settings and configuration
    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondary,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // Switch theme for settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent.withValues(alpha: 0.3);
        return border;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(textPrimary),
      side: const BorderSide(color: border, width: 1),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accent;
        return border;
      }),
    ),

    // Progress indicator for voice calibration
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: accent,
      linearTrackColor: border,
    ),

    // Slider theme for speed and volume controls
    sliderTheme: SliderThemeData(
      activeTrackColor: accent,
      thumbColor: accent,
      overlayColor: accent.withValues(alpha: 0.2),
      inactiveTrackColor: border,
      trackHeight: 4.0,
    ),

    // Tab bar theme for document sections
    tabBarTheme: TabBarTheme(
      labelColor: accent,
      unselectedLabelColor: textSecondary,
      indicatorColor: accent,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
    ),

    // Tooltip theme for help information
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme for system feedback
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primary,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
    ),

    // Dialog theme for modal interactions
    dialogTheme: DialogTheme(
      backgroundColor: secondary,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
    ),
  );

  /// Light theme - For settings and configuration interfaces
  /// Used when dark mode is not optimal for certain interactions
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: accent,
      onPrimary: textPrimary,
      primaryContainer: secondaryLight,
      onPrimaryContainer: textPrimaryLight,
      secondary: secondaryLight,
      onSecondary: textPrimaryLight,
      secondaryContainer: secondaryLight,
      onSecondaryContainer: textPrimaryLight,
      tertiary: accent,
      onTertiary: textPrimary,
      tertiaryContainer: secondaryLight,
      onTertiaryContainer: textPrimaryLight,
      error: error,
      onError: textPrimary,
      surface: surfaceLight,
      onSurface: textPrimaryLight,
      onSurfaceVariant: textSecondaryLight,
      outline: border,
      outlineVariant: dividerLight,
      shadow: shadowLight,
      scrim: textPrimaryLight,
      inverseSurface: surface,
      onInverseSurface: textPrimary,
      inversePrimary: accent,
    ),
    scaffoldBackgroundColor: surfaceLight,
    cardColor: surfaceLight,
    dividerColor: dividerLight,
    
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: textPrimaryLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimaryLight,
        size: 24,
      ),
    ),

    cardTheme: CardTheme(
      color: surfaceLight,
      elevation: 2.0,
      shadowColor: shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: accent,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
    ),

    textTheme: _buildLightTextTheme(),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: secondaryLight,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
    ),
  );

  /// Build dark theme text styles optimized for teleprompter readability
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
      // Display styles for large teleprompter text
      displayLarge: GoogleFonts.inter(
        fontSize: 96,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -1.5,
        height: 1.2,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 60,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.2,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.3,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.3,
      ),

      // Title styles for interface elements
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.4,
      ),

      // Body styles for readable content
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.5,
      ),

      // Label styles for interface elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.4,
      ),
      labelSmall: GoogleFonts.robotoMono(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 1.5,
      ),
    );
  }

  /// Build light theme text styles for settings interfaces
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 96,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: -1.5,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 60,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondaryLight,
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryLight,
        letterSpacing: 1.25,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryLight,
        letterSpacing: 0.4,
      ),
      labelSmall: GoogleFonts.robotoMono(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: textSecondaryLight,
        letterSpacing: 1.5,
      ),
    );
  }
}