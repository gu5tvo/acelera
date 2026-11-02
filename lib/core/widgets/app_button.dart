import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum AppButtonVariant { primary, lime, outline, danger, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expand = false,
    this.compact = false,
    this.trailingIcon,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expand;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 38.0 : 50.0;
    final (background, foreground, border, gradient) = switch (variant) {
      AppButtonVariant.primary => (
        AppColors.primary,
        Colors.white,
        null,
        AppColors.heroGradient,
      ),
      AppButtonVariant.lime => (
        AppColors.lime,
        AppColors.ink,
        null,
        AppColors.limeGradient,
      ),
      AppButtonVariant.outline => (
        AppColors.surface,
        AppColors.ink,
        AppColors.border,
        null,
      ),
      AppButtonVariant.danger => (
        AppColors.dangerSoft,
        AppColors.danger,
        null,
        null,
      ),
      AppButtonVariant.ghost => (
        Colors.transparent,
        AppColors.inkSoft,
        null,
        null,
      ),
    };

    final borderRadius = BorderRadius.circular(compact ? 13 : 16);
    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: compact ? 17 : 19, color: foreground),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.button.copyWith(
              color: foreground,
              fontSize: compact ? 12.5 : 13.5,
            ),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: compact ? 16 : 18, color: foreground),
        ],
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Ink(
        height: height,
        decoration: BoxDecoration(
          color: gradient == null ? background : null,
          gradient: gradient,
          borderRadius: borderRadius,
          border: border == null ? null : Border.all(color: border),
          boxShadow: variant == AppButtonVariant.primary
              ? const [
                  BoxShadow(
                    color: Color(0x331B63FF),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: onPressed,
          borderRadius: borderRadius,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
            child: content,
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.badge = false,
    this.dark = false,
    this.size = 44,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool badge;
  final bool dark;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: dark
              ? Colors.white.withValues(alpha: 0.14)
              : AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size * 0.34),
            side: BorderSide(
              color: dark
                  ? Colors.white.withValues(alpha: 0.16)
                  : AppColors.border,
            ),
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(size * 0.34),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                icon,
                size: size * 0.48,
                color: dark ? Colors.white : AppColors.ink,
              ),
            ),
          ),
        ),
        if (badge)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: AppColors.lime,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.ink, width: 2),
              ),
            ),
          ),
      ],
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}
