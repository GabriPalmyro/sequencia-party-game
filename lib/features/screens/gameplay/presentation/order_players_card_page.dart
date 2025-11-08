import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/cards/player_color_card_widget.dart';
import 'package:sequencia/common/design_system/components/cards/theme_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/domain/game/game_type_enum.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/exit_game_dialog_widget.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/finish_game_dialog_widget.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/show_player_card_modal.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/show_theme_card_modal.dart';
import 'package:sequencia/utils/app_animations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class OrderPlayersCardPage extends StatefulWidget {
  const OrderPlayersCardPage({super.key});

  @override
  State<OrderPlayersCardPage> createState() => _OrderPlayersCardPageState();
}

class _OrderPlayersCardPageState extends State<OrderPlayersCardPage> with TickerProviderStateMixin {
  late List<bool> revealedCards;
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    revealedCards = List.filled(context.read<GameController>().players.length, false);
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    WakelockPlus.enable();
  }

  void _animateSuccessReveal() {
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder: (_) => const ExitGameDialogWidget(),
        );
      },
      child: Scaffold(
        backgroundColor: theme.colors.background,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
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
                    ).animateIn(),
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
                    ).animateIn(),
                    Expanded(
                      child: AnimatedReorderableGridView(
                        controller: _scrollController,
                        items: context.watch<GameController>().players,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacing.inline.xs,
                        ),
                        itemBuilder: (_, index) {
                          final player = context.read<GameController>().players[index];
                          return GestureDetector(
                            key: ValueKey(player.orderNumber),
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
                        },
                        sliverGridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.5,
                        ),
                        longPressDraggable: false,
                        enterTransition: [FadeIn(), ScaleIn()],
                        insertDuration: const Duration(milliseconds: 400),
                        removeDuration: const Duration(milliseconds: 400),
                        onReorder: (int oldIndex, int newIndex) {
                          context.read<GameController>().onReorder(oldIndex, newIndex);
                        },
                      ),
                    ).animateIn(),
                    SizedBox(height: theme.spacing.inline.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DSButtonWidget(
                          label: context.watch<GameController>().isGameFinished() ? 'Finalizar' : 'Revelar',
                          onPressed: () async {
                            final controller = context.read<GameController>();

                            if (controller.isGameFinished()) {
                              controller.completeGame();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const FinishGameDialogWidget();
                                },
                              );
                              return;
                            } else {
                              controller.changeGameType(GameTypeEnum.REVEAL_PLAYERS);
                            }

                            _scrollController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                            );

                            for (int i = 0; i < revealedCards.length; i++) {
                              await Future.delayed(const Duration(seconds: 1));
                              Future.delayed(Duration(seconds: (i * 1.5).toInt()), () {
                                if (!_scrollController.hasClients) {
                                  return;
                                }

                                setState(() {
                                  revealedCards[i] = true;
                                });
                              });

                              if (i == revealedCards.length - 1) {
                                controller.changeGameType(GameTypeEnum.GAME_FINISHED);
                                // Mark theme as used when game is completed
                                controller.completeGame();
                                // Move the success animation here, after the last card
                                Future.delayed(Duration(seconds: (i * 1.5).toInt() + 1), () {
                                  if (controller.isGameSuccess()) {
                                    _animateSuccessReveal();
                                  }
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(width: theme.spacing.inline.xs),
                        DSButtonWidget(
                          label: 'Tema',
                          isSecondary: true,
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
                          size: const Size(100, 50),
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
                    SizedBox(height: theme.spacing.inline.xxs),
                    AnimatedOpacity(
                      opacity: context.watch<GameController>().isGameFinished() ? 0 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacing.inline.xs,
                        ),
                        child: DSText(
                          'Segure em qualquer carta para ver mais detalhes',
                          textAlign: TextAlign.center,
                          customStyle: TextStyle(
                            fontSize: theme.font.size.us,
                            fontWeight: theme.font.weight.light,
                            color: theme.colors.white,
                          ),
                        ),
                      ).animateIn(),
                    ),
                    SizedBox(height: theme.spacing.inline.xs),
                  ],
                ),
              ),
            ),
            // Lottie animation at the bottom, behind the buttons
            IgnorePointer(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Lottie.asset(
                    AppAnimations.party,
                    controller: _animationController,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
