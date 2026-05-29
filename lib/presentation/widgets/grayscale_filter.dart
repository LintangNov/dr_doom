import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/intervention_provider.dart';

/// Helper function to build a 4x5 grayscale matrix.
/// Linearly interpolates between Identity (normal colors) and Grayscale based on intensity (0.0 - 1.0).
List<double> buildGrayscaleMatrix(double intensity) {
  // Standard luminance weights
  const double rWeight = 0.2126;
  const double gWeight = 0.7152;
  const double bWeight = 0.0722;

  final double r = rWeight * intensity;
  final double g = gWeight * intensity;
  final double b = bWeight * intensity;

  final double invIntensity = 1.0 - intensity;

  return [
    r + invIntensity, g,                b,                0.0, 0.0,
    r,                g + invIntensity, b,                0.0, 0.0,
    r,                g,                b + invIntensity, 0.0, 0.0,
    0.0,              0.0,              0.0,              1.0, 0.0,
  ];
}

class GrayscaleFilter extends ConsumerWidget {
  final Widget child;

  const GrayscaleFilter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intensity = ref.watch(grayscaleIntensityProvider);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: intensity),
      duration: const Duration(seconds: 60),
      curve: Curves.easeInOut,
      builder: (context, animatedIntensity, child) {
        // Apply the interpolated grayscale matrix filter
        return ColorFiltered(
          colorFilter: ColorFilter.matrix(
            buildGrayscaleMatrix(animatedIntensity),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
