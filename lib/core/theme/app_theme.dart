import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.lime,
      onSecondary: AppColors.ink,
      error: AppColors.danger,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceContainerHighest: AppColors.surfaceAlt,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
      shadow: Color(0x1A0A1224),
      scrim: Color(0x990A1224),
      inverseSurface: AppColors.ink,
      onInverseSurface: Colors.white,
      inversePrimary: AppColors.lime,
      primaryContainer: AppColors.primarySoft,
      onPrimaryContainer: AppColors.primaryDeep,
      secondaryContainer: AppColors.lime,
      onSecondaryContainer: AppColors.ink,
      tertiary: AppColors.violet,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.violetSoft,
      onTertiaryContainer: AppColors.violet,
      errorContainer: AppColors.dangerSoft,
      onErrorContainer: AppColors.danger,
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      fontFamily: 'Jakarta',
    );

    return base.copyWith(
      textTheme: base.textTheme
          .apply(
            fontFamily: 'Jakarta',
            bodyColor: AppColors.ink,
            displayColor: AppColors.ink,
          )
          .copyWith(
            displayLarge: AppText.display,
            headlineLarge: AppText.h1,
            headlineMedium: AppText.h2,
            titleMedium: AppText.title,
            bodyMedium: AppText.body,
            bodySmall: AppText.caption,
            labelLarge: AppText.button,
          ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SlideFadePageTransitionsBuilder(),
          TargetPlatform.iOS: SlideFadePageTransitionsBuilder(),
          TargetPlatform.macOS: SlideFadePageTransitionsBuilder(),
          TargetPlatform.windows: SlideFadePageTransitionsBuilder(),
          TargetPlatform.linux: SlideFadePageTransitionsBuilder(),
        },
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.ink, size: 22),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: jk(13, 600, color: Colors.white),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}


class SlideFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const SlideFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.isFirst) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(curved),
      child: FadeTransition(opacity: curved, child: child),
    );
  }
}
