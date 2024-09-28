import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/cards/player_color_card_widget.dart';
import 'package:sequencia/common/design_system/components/cards/theme_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/router/app_navigator.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/domain/game/game_type_enum.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/show_player_card_modal.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/show_theme_card_modal.dart';

class OrderPlayersCardPage extends StatefulWidget {
  const OrderPlayersCardPage({super.key});

  @override
  State<OrderPlayersCardPage> createState() => _OrderPlayersCardPageState();
}

class _OrderPlayersCardPageState extends State<OrderPlayersCardPage> {
  late List<bool> revealedCards;

  @override
  void initState() {
    super.initState();
    revealedCards = List.filled(context.read<GameController>().players.length, false);
  }

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
            )
                .animate(
                  delay: 250.ms,
                )
                .fade(
                  duration: 300.ms,
                  delay: 300.ms,
                )
                .slide(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
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
            )
                .animate(
                  delay: 250.ms,
                )
                .fade(
                  duration: 300.ms,
                  delay: 300.ms,
                )
                .slide(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ),
            SizedBox(height: theme.spacing.inline.xs),
            ReorderableWrap(
              spacing: theme.spacing.inline.sm,
              runSpacing: theme.spacing.inline.xxxl,
              padding: const EdgeInsets.all(8),
              children: context.watch<GameController>().players.map((player) {
                return GestureDetector(
                  onLongPress: () {
                    if (context.read<GameController>().isGameFinished()) {
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return ShowPlayerCardModal(
                          player: player,
                        );
                      },
                    );
                  },
                  child: Stack(
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
                        isHidden: !revealedCards[context.read<GameController>().players.indexOf(player)],
                        isEnableFlip: true,
                        shoudShowFlipLabel: false,
                        value: DSText(
                          player.orderNumber ?? '',
                          customStyle: TextStyle(
                            fontSize: theme.font.size.md,
                            fontWeight: theme.font.weight.bold,
                            color: theme.colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              needsLongPressDraggable: false,
              enableReorder: !context.watch<GameController>().isGameFinished(),
              onReorder: (int oldIndex, int newIndex) {
                //this callback is required
                context.read<GameController>().onReorder(oldIndex, newIndex);
              },
            )
                .animate(
                  delay: 250.ms,
                )
                .fade(
                  duration: 300.ms,
                  delay: 300.ms,
                )
                .slide(
                  begin: const Offset(0, 1),
                  end: const Offset(0, 0),
                ),
            const Spacer(),
            SizedBox(height: theme.spacing.inline.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                DSButtonWidget(
                  label: context.watch<GameController>().isGameFinished() ? 'Finalizar' : 'Revelar',
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    if (context.read<GameController>().isGameFinished()) {
                      GetIt.I.get<AppNavigator>().pushReplacementNamed(Routes.home);
                    } else {
                      context.read<GameController>().changeGameType(GameTypeEnum.REVEAL_PLAYERS);
                    }

                    for (int i = 0; i < revealedCards.length; i++) {
                      await Future.delayed(const Duration(seconds: 1));
                      Future.delayed(Duration(seconds: i * 2), () {
                        setState(() {
                          revealedCards[i] = true;
                        });
                      });

                      if (i == revealedCards.length - 1) {
                        context.read<GameController>().changeGameType(GameTypeEnum.GAME_FINISHED);
                      }
                    }
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
                        return const ShowThemeCardModal();
                      },
                    );
                  },
                  size: const Size(70, 40),
                ),
                SizedBox(width: theme.spacing.inline.xxs),
              ]
                  .animate(
                    delay: 250.ms,
                  )
                  .fade(
                    duration: 300.ms,
                    delay: 300.ms,
                  )
                  .slide(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ),
            ),
            SizedBox(height: theme.spacing.inline.md),
          ],
        ),
      ),
    );
  }
}
