import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/cards/player_color_card_widget.dart';
import 'package:sequencia/common/design_system/components/cards/theme_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/show_theme_card_modal.dart';

class OrderPlayersCardPage extends StatefulWidget {
  const OrderPlayersCardPage({super.key});

  @override
  State<OrderPlayersCardPage> createState() => _OrderPlayersCardPageState();
}

class _OrderPlayersCardPageState extends State<OrderPlayersCardPage> {
  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: theme.spacing.inline.md),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.inline.xs,
              ),
              child: DSText(
                'Ordene os jogadores',
                customStyle: TextStyle(
                  fontSize: theme.font.size.md,
                  fontWeight: theme.font.weight.semiBold,
                  color: theme.colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.inline.xs,
              ),
              child: DSText(
                'Do menor para o maior',
                customStyle: TextStyle(
                  fontSize: theme.font.size.xxs,
                  fontWeight: theme.font.weight.light,
                  color: theme.colors.white,
                ),
              ),
            ),
            SizedBox(height: theme.spacing.inline.xs),
            ReorderableWrap(
              spacing: theme.spacing.inline.sm,
              runSpacing: theme.spacing.inline.xxxl,
              padding: const EdgeInsets.all(8),
              children: context.watch<GameController>().players.map((player) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: -35,
                      left: 10,
                      child: PlayerColorCard(
                        size: const Size(80, 100),
                        color: player.color ?? theme.colors.tertiary,
                        name: player.name,
                      ),
                    ),
                    ThemeCard(
                      size: const Size(100, 150),
                      isHidden: true,
                      isEnableFlip: false,
                      label: DSText(
                        'Seu número é',
                        customStyle: TextStyle(
                          fontSize: theme.font.size.sm,
                          fontWeight: theme.font.weight.light,
                          color: theme.colors.white,
                        ),
                      ),
                      value: DSText(
                        player.orderNumber ?? '',
                        customStyle: TextStyle(
                          fontSize: theme.font.size.xxxl,
                          fontWeight: theme.font.weight.bold,
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
              needsLongPressDraggable: false,
              onReorder: (int oldIndex, int newIndex) {
                //this callback is required
                context.read<GameController>().onReorder(oldIndex, newIndex);
              },
              onNoReorder: (int index) {
                //this callback is optional
                debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
              },
              onReorderStarted: (int index) {
                //this callback is optional
                debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
              },
            ),
            const Spacer(),
            SizedBox(height: theme.spacing.inline.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                DSButtonWidget(
                  label: 'Finalizar',
                  onPressed: () {
                    log(context.read<GameController>().players.map((e) => e.name).toList().toString());
                  },
                ),
                SizedBox(width: theme.spacing.inline.xxs),
                DSIconButtonWidget(
                  label: Icons.remove_red_eye,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return ShowThemeCardModal();
                      },
                    );
                  },
                  size: const Size(80, 40),
                ),
                SizedBox(width: theme.spacing.inline.xxs),
              ],
            ),
            SizedBox(height: theme.spacing.inline.md),
          ],
        ),
      ),
    );
  }
}
