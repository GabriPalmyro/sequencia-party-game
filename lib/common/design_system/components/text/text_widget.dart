import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class DSText extends StatelessWidget {
  const DSText(
    this.label, {
    this.customStyle,
    this.textAlign = TextAlign.left,
  });
  final String label;
  final TextStyle? customStyle;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);

    final style = TextStyle(
      color: theme.colors.white,
      fontSize: theme.font.size.sm,
      fontWeight: theme.font.weight.regular,
      fontFamily: theme.font.family.base,
    ).merge(customStyle);

    return Text(
      label,
      style: style,
      textAlign: textAlign,
    );
  }
}
