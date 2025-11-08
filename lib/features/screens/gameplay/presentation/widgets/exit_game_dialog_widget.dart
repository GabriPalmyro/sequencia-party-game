import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';
import 'package:sequencia/router/routes.dart';

class ExitGameDialogWidget extends StatelessWidget {
  const ExitGameDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);

    if (Platform.isIOS) {
      return _buildCupertinoDialog(context, theme);
    }
    return _buildMaterialDialog(context, theme);
  }

  Widget _buildCupertinoDialog(BuildContext context, dynamic theme) {
    final l10n = context.l10n;
    return CupertinoAlertDialog(
      title: DSText(
        l10n.exitGameTitle,
        customStyle: TextStyle(
          color: theme.colors.background,
          fontSize: theme.font.size.sm,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      content: DSText(
        l10n.exitGameDescription,
        customStyle: TextStyle(
          color: theme.colors.primary,
          fontSize: theme.font.size.xs,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: DSText(
            l10n.cancelLabel,
            customStyle: TextStyle(
              color: theme.colors.tertiary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.home);
          },
          child: DSText(
            l10n.exitLabel,
            customStyle: TextStyle(
              color: theme.colors.tertiary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context, dynamic theme) {
    final l10n = context.l10n;
    return AlertDialog(
      title: DSText(
        l10n.exitGameTitle,
        customStyle: TextStyle(
          color: theme.colors.background,
          fontSize: theme.font.size.sm,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      content: DSText(
        l10n.exitGameDescription,
        customStyle: TextStyle(
          color: theme.colors.primary,
          fontSize: theme.font.size.xs,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: DSText(
            l10n.cancelLabel,
            customStyle: TextStyle(
              color: theme.colors.tertiary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, Routes.home);
          },
          child: DSText(
            l10n.exitLabel,
            customStyle: TextStyle(
              color: theme.colors.tertiary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
