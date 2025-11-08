import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';

class GameRulesPage extends StatelessWidget {
  const GameRulesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        title: DSText(l10n.gameManualTitle),
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
              l10n.guideStep1Title,
              l10n.guideStep1Description,
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              l10n.guideStep2Title,
              l10n.guideStep2Description,
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              l10n.guideStep3Title,
              l10n.guideStep3Description,
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              l10n.guideStep4Title,
              l10n.guideStep4Description,
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              l10n.guideStep5Title,
              l10n.guideStep5Description,
            ),
            const SizedBox(height: 10),
            _buildStep(
              context,
              l10n.guideStep6Title,
              l10n.guideStep6Description,
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
