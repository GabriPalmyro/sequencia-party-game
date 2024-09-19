import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colors.secondary,
        boxShadow: [
          BoxShadow(
            color: theme.colors.secondary.withOpacity(0.55),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(theme.borders.radius.medium),
      ),
      padding: EdgeInsets.symmetric(
        vertical: theme.spacing.inline.xxs,
        horizontal: theme.spacing.inline.xxs,
      ),
      child: Center(
        child: DSText(
          text,
          textAlign: TextAlign.center,
          customStyle: TextStyle(
            fontWeight: theme.font.weight.regular,
            fontSize: theme.font.size.xxs,
          ),
        ),
      ),
    );
  }
}
