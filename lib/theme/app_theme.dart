import 'package:flutter/material.dart';

/// Core palette pulled from DESIGN.md and the Stitch screen exports.
abstract final class AppColors {
  static const background = Color(0xFF0F131C);
  static const surfaceLowest = Color(0xFF0A0E17);
  static const surfaceLow = Color(0xFF181B25);
  static const surface = Color(0xFF1C1F29);
  static const surfaceHigh = Color(0xFF262A34);
  static const surfaceHighest = Color(0xFF31353F);
  static const surfaceBright = Color(0xFF353943);

  static const onSurface = Color(0xFFDFE2EF);
  static const onSurfaceVariant = Color(0xFFBBCABF);
  static const muted = Color(0xFF86948A);
  static const outlineVariant = Color(0xFF3C4A42);

  static const primary = Color(0xFF4EDEA3);
  static const primaryContainer = Color(0xFF10B981);
  static const onPrimary = Color(0xFF003824);
  static const primaryFixed = Color(0xFF6FFBBE);

  static const secondary = Color(0xFFFFB2B7);
  static const secondaryContainer = Color(0xFFB50036);
  static const onSecondaryContainer = Color(0xFFFFC2C4);

  static const tertiary = Color(0xFFC0C1FF);
  static const tertiaryContainer = Color(0xFF9699FF);
  static const onTertiary = Color(0xFF1000A9);

  static const error = Color(0xFFFFB4AB);

  static const border = Color(0x14FFFFFF); // rgba(255,255,255,.08)
  static const borderSoft = Color(0x0FFFFFFF); // rgba(255,255,255,.06)
  static const divider = Color(0x0AFFFFFF); // rgba(255,255,255,.04)
}

/// Typography tokens from DESIGN.md. Numeric styles enable tabular figures.
abstract final class AppText {
  static const manrope = 'Manrope';
  static const hanken = 'Hanken Grotesk';
  static const mono = 'JetBrains Mono';

  static const tabular = [FontFeature.tabularFigures()];

  static const displayLgMobile = TextStyle(
    fontFamily: manrope,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    color: AppColors.onSurface,
    fontFeatures: tabular,
  );

  static const headlineLg = TextStyle(
    fontFamily: manrope,
    fontSize: 28,
    height: 36 / 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.56,
    color: AppColors.onSurface,
  );

  static const headlineMd = TextStyle(
    fontFamily: manrope,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.33,
    color: AppColors.onSurface,
  );

  static const headlineSm = TextStyle(
    fontFamily: manrope,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.18,
    color: AppColors.onSurface,
  );

  static const bodyLg = TextStyle(
    fontFamily: hanken,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    color: AppColors.onSurface,
  );

  static const bodyMd = TextStyle(
    fontFamily: hanken,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  static const bodySm = TextStyle(
    fontFamily: hanken,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.12,
    color: AppColors.onSurfaceVariant,
  );

  static const labelLg = TextStyle(
    fontFamily: mono,
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.14,
    color: AppColors.onSurface,
    fontFeatures: tabular,
  );

  static const labelMd = TextStyle(
    fontFamily: mono,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.24,
    color: AppColors.onSurface,
    fontFeatures: tabular,
  );

  static const labelSm = TextStyle(
    fontFamily: mono,
    fontSize: 10,
    height: 14 / 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
    fontFeatures: tabular,
  );
}

abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: Color(0xFF00422B),
      secondary: AppColors.secondary,
      onSecondary: Color(0xFF67001B),
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: Color(0xFF1D17B2),
      error: AppColors.error,
      onError: Color(0xFF690005),
      surface: AppColors.background,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surfaceLowest,
      surfaceContainerLow: AppColors.surfaceLow,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceHigh,
      surfaceContainerHighest: AppColors.surfaceHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.muted,
      outlineVariant: AppColors.outlineVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.surfaceLow,
      fontFamily: AppText.hanken,
      splashFactory: InkRipple.splashFactory,
      textTheme: const TextTheme(
        displayLarge: AppText.displayLgMobile,
        headlineLarge: AppText.headlineLg,
        headlineMedium: AppText.headlineMd,
        headlineSmall: AppText.headlineSm,
        titleMedium: AppText.headlineSm,
        bodyLarge: AppText.bodyLg,
        bodyMedium: AppText.bodyMd,
        bodySmall: AppText.bodySm,
        labelLarge: AppText.labelLg,
        labelMedium: AppText.labelMd,
        labelSmall: AppText.labelSm,
      ),
      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
      dividerColor: AppColors.divider,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        modalBarrierColor: Color(0xCC05080E),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: AppText.bodyMd.copyWith(color: AppColors.onSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        textStyle: AppText.bodyMd,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: AppColors.primary.withValues(alpha: 0.04),
    );
  }
}
