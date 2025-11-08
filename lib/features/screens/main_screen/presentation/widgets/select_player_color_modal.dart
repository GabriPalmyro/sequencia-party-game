import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';

class SelectPlayerColorModal extends StatelessWidget {
  const SelectPlayerColorModal({
    required this.onColorSelected,
    required this.availableColors,
    Key? key,
  }) : super(key: key);

  final Function(Color) onColorSelected;
  final List<Color> availableColors;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);

    return Container(
      width: double.infinity,
      padding: theme.spacing.inset.sm,
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.borders.radius.large),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: theme.spacing.inline.sm),
            decoration: BoxDecoration(
              color: theme.colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(theme.borders.radius.small),
            ),
          ),
          DSText(
            context.l10n.selectColorTitle,
            customStyle: TextStyle(
              fontWeight: theme.font.weight.medium,
              fontSize: 20,
              color: theme.colors.white,
            ),
          ),
          SizedBox(height: theme.spacing.inline.sm),
          Wrap(
            spacing: theme.spacing.inline.xs,
            runSpacing: theme.spacing.inline.xxs,
            children: availableColors.map((color) {
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colors.white,
                      width: 1,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: theme.spacing.inline.xxl),
          DSButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            label: context.l10n.cancelLabel,
          ),
          SizedBox(height: theme.spacing.inline.md),
        ],
      ),
    );
  }
}
