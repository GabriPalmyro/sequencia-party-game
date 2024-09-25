import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/cards/player_color_card_widget.dart';
import 'package:sequencia/common/design_system/components/cards/theme_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';

class PlayerPageView extends StatefulWidget {
  const PlayerPageView({required this.player, Key? key}) : super(key: key);
  final PlayerEntity player;

  @override
  State<PlayerPageView> createState() => _PlayerPageViewState();
}

class _PlayerPageViewState extends State<PlayerPageView> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -35,
                left: 10,
                child: PlayerColorCard(
                  color: widget.player.color ?? theme.colors.tertiary,
                  name: widget.player.name,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHidden = !isHidden;
                  });
                },
                child: ThemeCard(
                  isHidden: isHidden,
                  label: DSText(
                    'Seu número é',
                    customStyle: TextStyle(
                      fontSize: theme.font.size.sm,
                      fontWeight: theme.font.weight.light,
                      color: theme.colors.white,
                    ),
                  ),
                  value: DSText(
                    widget.player.orderNumber ?? '',
                    customStyle: TextStyle(
                      fontSize: theme.font.size.xxxl,
                      fontWeight: theme.font.weight.bold,
                      color: theme.colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}