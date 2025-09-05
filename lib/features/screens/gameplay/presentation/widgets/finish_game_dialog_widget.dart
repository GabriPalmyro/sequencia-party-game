// ignore_for_file: avoid-returning-widgets

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/design_system/core/tokens/design.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/router/routes.dart';

class FinishGameDialogWidget extends StatelessWidget {
  const FinishGameDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);

    if (Platform.isIOS) {
      return _buildCupertinoDialog(context, theme);
    }
    return _buildMaterialDialog(context, theme);
  }

  void _goToMainPage(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  void _restartGame(BuildContext context) {
    context.read<GameController>().resetGame();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(Routes.gamePrepare);
  }

  Widget _buildCupertinoDialog(BuildContext context, DSTokens theme) {
    return CupertinoAlertDialog(
      title: DSText(
        'Finalizar o jogo',
        customStyle: TextStyle(
          color: theme.colors.background,
          fontSize: theme.font.size.sm,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      content: DSText(
        'Deseja começar outra rodada ou sair para a tela inicial?',
        customStyle: TextStyle(
          color: theme.colors.primary,
          fontSize: theme.font.size.xs,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          onPressed: () => _goToMainPage(context),
          child: DSText(
            'Retornar ao início',
            customStyle: TextStyle(
              color: theme.colors.tertiary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => _restartGame(context),
          child: DSText(
            'Jogar novamente',
            customStyle: TextStyle(
              color: theme.colors.primary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialDialog(BuildContext context, DSTokens theme) {
    return AlertDialog(
      title: DSText(
        'Finalizar o jogo',
        customStyle: TextStyle(
          color: theme.colors.background,
          fontSize: theme.font.size.sm,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      content: DSText(
        'Deseja começar outra rodada ou sair para a tela inicial?',
        customStyle: TextStyle(
          color: theme.colors.primary,
          fontSize: theme.font.size.xs,
          fontWeight: theme.font.weight.regular,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => _goToMainPage(context),
          child: DSText(
            'Retornar ao início',
            customStyle: TextStyle(
              color: theme.colors.tertiary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => _restartGame(context),
          child: DSText(
            'Jogar novamente',
            customStyle: TextStyle(
              color: theme.colors.primary,
              fontSize: theme.font.size.xs,
              fontWeight: theme.font.weight.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
