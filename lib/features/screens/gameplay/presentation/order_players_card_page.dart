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
import 'package:sequencia/helpers/extension/context_extension.dart';
import 'package:sequencia/utils/app_animations.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class OrderPlayersCardPage extends StatefulWidget {
  const OrderPlayersCardPage({super.key});

  @override
  State<OrderPlayersCardPage> createState() => _OrderPlayersCardPageState();
}

class _OrderPlayersCardPageState extends State<OrderPlayersCardPage>
    with TickerProviderStateMixin {
  late List<bool> revealedCards;
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    revealedCards =
        List.filled(context.read<GameController>().players.length, false);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    WakelockPlus.enable();
  }

  void _animateSuccessReveal() {
    if (mounted) {
      print('Starting success animation');
      _animationController.reset();
      _animationController.forward().then((_) {
        print('Success animation completed');
        // Automatically hide animation after completion
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  void _showReorderLockedMessage() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.reorderLockedMessage),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final gameController = context.watch<GameController>();
    final players = gameController.players;
    final bool isResultsPhase = gameController.isGameFinished();
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
        appBar: AppBar(
          backgroundColor: theme.colors.background,
          title: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.inline.xs,
                ),
                child: DSText(
                  context.l10n.orderPlayersTitle,
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
                  context.l10n.orderPlayersSubtitle,
                  customStyle: TextStyle(
                    fontSize: theme.font.size.xxs,
                    fontWeight: theme.font.weight.light,
                    color: theme.colors.white,
                  ),
                ),
              ).animateIn(),
            ],
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: theme.colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const ExitGameDialogWidget(),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.colors.background,
            border: Border(
              top: BorderSide(
                color: theme.colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedOpacity(
                  opacity: isResultsPhase ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: theme.spacing.inline.xxs,
                      bottom: theme.spacing.inline.xxs,
                    ),
                    child: DSText(
                      context.l10n.orderPlayersHint,
                      textAlign: TextAlign.center,
                      customStyle: TextStyle(
                        fontSize: theme.font.size.us,
                        fontWeight: theme.font.weight.light,
                        color: theme.colors.white,
                      ),
                    ).animateIn(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    DSButtonWidget(
                      label: isResultsPhase
                          ? context.l10n.finishLabel
                          : context.l10n.revealLabel,
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
                          controller
                              .changeGameType(GameTypeEnum.REVEAL_PLAYERS);
                        }

                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );

                        for (int i = 0; i < revealedCards.length; i++) {
                          await Future.delayed(const Duration(seconds: 1));
                          Future.delayed(Duration(seconds: (i * 1.5).toInt()),
                              () {
                            if (!_scrollController.hasClients) {
                              return;
                            }

                            setState(() {
                              revealedCards[i] = true;
                            });
                          });

                          if (i == revealedCards.length - 1) {
                            controller
                                .changeGameType(GameTypeEnum.GAME_FINISHED);
                            // Mark theme as used when game is completed
                            controller.completeGame();
                            // Trigger success animation after the last card is revealed
                            Future.delayed(
                                Duration(seconds: (i * 1.5).toInt() + 2), () {
                              if (mounted) {
                                print(
                                    'Checking game success: ${controller.isGameSuccess()}');
                                if (controller.isGameSuccess()) {
                                  print('Triggering success animation');
                                  _animateSuccessReveal();
                                } else {
                                  print(
                                      'Game was not successful, no animation');
                                }
                              }
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(width: theme.spacing.inline.xs),
                    DSButtonWidget(
                      label: context.l10n.themeLabel,
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
              ],
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedReorderableGridView(
                        controller: _scrollController,
                        items: players,
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacing.inline.xs,
                        ),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        sliverGridDelegate:
                            SliverReorderableGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.5,
                          mainAxisSpacing: theme.spacing.inline.xxs,
                          crossAxisSpacing: theme.spacing.inline.xxs,
                        ),
                        enterTransition: [FadeIn(), ScaleIn()],
                        exitTransition: [FadeIn(), ScaleIn()],
                        insertDuration: const Duration(milliseconds: 400),
                        removeDuration: const Duration(milliseconds: 400),
                        longPressDraggable: false,
                        itemBuilder: (_, index) {
                          final player = players[index];
                          return GestureDetector(
                            key: ValueKey(
                                player.orderNumber ?? '$index-${player.name}'),
                            onLongPress: () {
                              if (context
                                  .read<GameController>()
                                  .isGameFinished()) {
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
                                    color:
                                        player.color ?? theme.colors.tertiary,
                                    name: player.name,
                                  ),
                                ),
                                ThemeCard(
                                  size: const Size(100, 150),
                                  isHidden: index >= revealedCards.length ||
                                      !revealedCards[index],
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
                        onReorderStart: (_) {
                          if (context.read<GameController>().isGameFinished()) {
                            _showReorderLockedMessage();
                          }
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          final controller = context.read<GameController>();
                          if (controller.isGameFinished()) {
                            _showReorderLockedMessage();
                            return;
                          }
                          controller.onReorder(oldIndex, newIndex);
                        },
                      ),
                    ).animateIn(),
                  ],
                ),
              ),
            ),
            // Lottie animation for celebration - only shows when animating
            if (_animationController.isAnimating)
              Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    color: Colors.transparent,
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Lottie.asset(
                          AppAnimations.party,
                          controller: _animationController,
                          fit: BoxFit.contain,
                        ),
                      ),
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
