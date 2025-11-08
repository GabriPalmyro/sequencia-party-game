import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/cards/theme_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';

class ShowThemeCardModal extends StatelessWidget {
  const ShowThemeCardModal({
    Key? key,
  }) : super(key: key);

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
          SizedBox(height: theme.spacing.inline.sm),
          ThemeCard(
            label: DSText(
              context.l10n.themeIsLabel,
              textAlign: TextAlign.center,
              customStyle: TextStyle(
                fontSize: theme.font.size.xxs,
                fontWeight: theme.font.weight.light,
                color: theme.colors.white,
              ),
            ),
            value: DSText(
              context.read<GameController>().gameThemeNumber,
              textAlign: TextAlign.center,
              customStyle: TextStyle(
                fontSize: theme.font.size.xxxl,
                fontWeight: theme.font.weight.bold,
                color: theme.colors.white,
              ),
            ),
            description: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: theme.spacing.inline.xxs),
              child: DSText(
                context.read<GameController>().gameThemeDescription,
                textAlign: TextAlign.center,
                customStyle: TextStyle(
                  fontSize: theme.font.size.xxxs,
                  fontWeight: theme.font.weight.regular,
                  color: theme.colors.white,
                ),
              ),
            ),
            isEnableFlip: false,
          ),
          SizedBox(height: theme.spacing.inline.xxl),
          DSButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            label: context.l10n.closeLabel,
          ),
          SizedBox(height: theme.spacing.inline.md),
        ],
      ),
    );
  }
}
