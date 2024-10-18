import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class GameRulesPage extends StatelessWidget {
  const GameRulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        title: const DSText('Manual do Jogo'),
        backgroundColor: theme.colors.background,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DSIconButtonWidget(
            label: Icons.chevron_left,
            onPressed: () => Navigator.pop(
              context,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.inline.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildStep(
              context,
              '1. Início do Jogo',
              'Cada jogador começa comprando uma carta da pilha e a mantém em segredo.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              '2. Seleção do Tema',
              'Um tema aleatório é selecionado e revelado para todos os jogadores. O tema guiará as dicas que os jogadores darão.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              '3. Distribuição das Cartas',
              'Cada jogador recebe uma carta, visível apenas para ele. As cartas contêm números que precisam ser ordenados de forma crescente.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              '4. Dicas',
              'Os jogadores devem dar dicas baseadas no tema escolhido, sem revelar diretamente o número da sua carta. As dicas são subjetivas e relacionadas ao tema.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              '5. Ordenação das Cartas',
              'Após todos darem suas dicas, os jogadores devem organizar as cartas de todos em uma ordem crescente de números, de acordo com as dicas dadas.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              '6. Revelação',
              'As cartas são reveladas. Se todas estiverem na ordem correta, os jogadores vencem. Caso contrário, eles perdem e podem tentar novamente.',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String title, String description) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSText(
          title,
          customStyle: TextStyle(
            fontSize: theme.font.size.sm,
            fontWeight: theme.font.weight.bold,
          ),
        ),
        SizedBox(height: theme.spacing.inline.xxxs),
        DSText(
          description,
          customStyle: TextStyle(
            fontSize: theme.font.size.xxs,
          ),
        ),
      ],
    );
  }
}
