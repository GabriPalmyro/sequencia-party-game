import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/features/screens/gameplay/widgets/player_page_view.dart';

class ShowPlayerCardModal extends StatelessWidget {
  const ShowPlayerCardModal({
    required this.player,
    Key? key,
  }) : super(key: key);

  final PlayerEntity player;

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
          PlayerPageView(player: player),
          SizedBox(height: theme.spacing.inline.xxxl),
          SizedBox(height: theme.spacing.inline.xxxl),
          DSButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            label: 'Fechar',
          ),
          SizedBox(height: theme.spacing.inline.md),
        ],
      ),
    );
  }
}
