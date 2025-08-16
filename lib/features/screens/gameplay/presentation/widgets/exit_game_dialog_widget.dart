import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
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
    return CupertinoAlertDialog(
      title: DSText(
        'Sair do jogo',
        customStyle: TextStyle(
          color: theme.colors.background,
          fontSize: theme.font.size.sm,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      content: DSText(
        'Tem certeza que deseja sair do jogo?',
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
            'Cancelar',
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
            'Sair',
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
    return AlertDialog(
      title: DSText(
        'Sair do jogo',
        customStyle: TextStyle(
          color: theme.colors.background,
          fontSize: theme.font.size.sm,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      content: DSText(
        'Tem certeza que deseja sair do jogo?',
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
            'Cancelar',
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
            'Sair',
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
