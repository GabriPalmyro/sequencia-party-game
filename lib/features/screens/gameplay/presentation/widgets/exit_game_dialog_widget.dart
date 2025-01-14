import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/router/routes.dart';

class ExitGameDialogWidget extends StatelessWidget {
  const ExitGameDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
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
