import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerComponent extends StatelessWidget {
  const ShimmerComponent({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Shimmer.fromColors(
      baseColor: theme.colors.secondary,
      highlightColor: theme.colors.secondary.withOpacity(0.6),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            theme.borders.radius.medium,
          ),
          color: theme.colors.grey,
        ),
      ),
    );
  }
}
