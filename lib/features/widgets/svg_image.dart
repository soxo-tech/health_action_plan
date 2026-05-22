import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays an SVG image.
///
/// This widget allows you to display an SVG image with configurable height, width, color, and fit.
class SvgImage extends StatelessWidget {
  /// Creates an [SvgImage] with the specified [svgPath], [svgHeight], [svgWidth], [color], [fit], and [isGiveColour].
  ///
  /// The [svgPath] is required and should be the path to the SVG file located in the `assets/svg/` directory.
  const SvgImage({
    super.key,
    required this.svgPath,
    this.svgHeight,
    this.svgWidth,
    this.color,
    this.fit,
    this.isGiveColour = false,
    this.packageName,
  });

  /// The path to the SVG image file located in the `assets/svg/` directory.
  final String svgPath;

  /// The height of the SVG image. If not provided, the image height is not constrained.
  final double? svgHeight;

  /// The width of the SVG image. If not provided, the image width is not constrained.
  final double? svgWidth;

  /// The color to apply to the SVG image. If not provided, the image is displayed in its original color.
  final Color? color;

  /// The BoxFit property to determine how the SVG image should fit within its allocated space.
  /// Defaults to [BoxFit.cover] if not provided.
  final BoxFit? fit;

  /// Whether to apply the color filter to the SVG image. Defaults to false.
  final bool isGiveColour;

  /// The package where the asset is located.
  /// Defaults to 'health_action_plan' in production/addon mode.
  final String? packageName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/svg/$svgPath.svg',
      height: svgHeight,
      width: svgWidth,
      fit: fit ?? BoxFit.cover,
      package: packageName,
      colorFilter: (isGiveColour && color != null)
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
