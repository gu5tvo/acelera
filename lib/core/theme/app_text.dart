import 'package:flutter/material.dart';

import 'app_colors.dart';

TextStyle jk(
  double size,
  double weight, {
  Color? color,
  double height = 1.25,
  double? letterSpacing,
  FontStyle? fontStyle,
  TextDecoration? decoration,
}) {
  return TextStyle(
    fontFamily: 'Jakarta',
    fontSize: size,
    height: height,
    color: color ?? AppColors.ink,
    letterSpacing: letterSpacing,
    fontStyle: fontStyle,
    decoration: decoration,
    fontWeight: _weight(weight),
    fontVariations: [FontVariation('wght', weight)],
  );
}

FontWeight _weight(double weight) {
  if (weight >= 800) return FontWeight.w800;
  if (weight >= 700) return FontWeight.w700;
  if (weight >= 600) return FontWeight.w600;
  if (weight >= 500) return FontWeight.w500;
  if (weight >= 400) return FontWeight.w400;
  return FontWeight.w300;
}

abstract final class AppText {
  static final display = jk(30, 800, height: 1.08, letterSpacing: -1);
  static final h1 = jk(25, 800, height: 1.1, letterSpacing: -0.7);
  static final h2 = jk(19, 700, height: 1.2, letterSpacing: -0.35);
  static final h3 = jk(16, 700, height: 1.25, letterSpacing: -0.2);
  static final title = jk(14.5, 700, height: 1.25);
  static final body = jk(13.5, 500, height: 1.45, color: AppColors.inkSoft);
  static final bodyStrong = jk(13.5, 600, height: 1.4, color: AppColors.ink);
  static final label = jk(12.5, 600, height: 1.2);
  static final caption = jk(11.5, 600, height: 1.2, color: AppColors.inkMuted);
  static final overline = jk(
    10,
    700,
    height: 1.1,
    letterSpacing: 0.9,
    color: AppColors.inkMuted,
  );
  static final button = jk(13.5, 700, height: 1.1, letterSpacing: -0.1);
  static final money = jk(21, 800, height: 1.1, letterSpacing: -0.6);
  static final moneySmall = jk(15, 800, height: 1.15, letterSpacing: -0.3);
}
