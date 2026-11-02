import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class BikeImage extends StatelessWidget {
  const BikeImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.cacheWidth,
    this.alignment = Alignment.center,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final int? cacheWidth;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      filterQuality: FilterQuality.medium,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stack) => Container(
        width: width,
        height: height,
        color: AppColors.surfaceAlt,
        alignment: Alignment.center,
        child: const Icon(
          Icons.two_wheeler_rounded,
          size: 32,
          color: AppColors.inkMuted,
        ),
      ),
    );

    if (radius == 0) return RepaintBoundary(child: image);
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: image,
      ),
    );
  }
}
