import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/info_card/info_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/features/screens/main_screen/presentation/widgets/players_names_inputs_widget.dart';
import 'package:sequencia/router/routes.dart';
import 'package:sequencia/utils/app_consts.dart';
import 'package:sequencia/utils/app_strings.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoAnimation;

  late AnimationController _fieldsController;

  late AnimationController _buttonController;
  late Animation<Offset> _buttonAnimation;

  late AnimationController _infoCardController;
  late Animation<Offset> _infoCardAnimation;

  DateTime? _lastBackPress;

  @override
  void initState() {
    super.initState();

    // Logo Animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOut,
      ),
    );

    // Fields Animation
    _fieldsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Button Animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _buttonAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeOut,
      ),
    );

    // Info Card Animation
    _infoCardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _infoCardAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _infoCardController,
        curve: Curves.easeOut,
      ),
    );

    // Start Animations with delay
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _fieldsController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _infoCardController.forward();
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fieldsController.dispose();
    _buttonController.dispose();
    _infoCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        // Check if back was pressed twice within 2 seconds
        final now = DateTime.now();
        const backPressThreshold = Duration(seconds: 2);

        if (_lastBackPress == null || now.difference(_lastBackPress!) > backPressThreshold) {
          _lastBackPress = now;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: theme.colors.secondary,
              content: DSText(
                AppStrings.closeAppMessage,
                customStyle: TextStyle(
                  fontSize: theme.font.size.xxs,
                ),
              ),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.colors.background,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: theme.spacing.inline.md),
              SlideTransition(
                position: _logoAnimation,
                child: Image.asset(
                  AppImages.logo,
                  width: 250,
                ),
              ),
              SizedBox(height: theme.spacing.inline.xxxs),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.purple, Colors.transparent, Colors.transparent, Colors.purple],
                      stops: [0.0, 0.03, 0.97, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: const PlayersNamesInputsWidget(),
                ),
              ),
              SizedBox(height: theme.spacing.inline.xxs),
              if (context.watch<PlayersController>().players.length <= 4) ...[
                SlideTransition(
                  position: _infoCardAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: theme.spacing.inline.xs,
                    ),
                    child: const InfoCardWidget(
                      AppStrings.playersInfoLabelLabel,
                    ),
                  ),
                ),
              ],
              SizedBox(height: theme.spacing.inline.sm),
              SlideTransition(
                position: _buttonAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Spacer(),
                    DSButtonWidget(
                      label: AppStrings.startLabel,
                      isEnabled: context.watch<PlayersController>().players.length >= AppConsts.minPlayersToStart,
                      onPressed: () async {
                        if (context.read<PlayersController>().playersCount >= AppConsts.minPlayersToStart) {
                          context.read<PlayersController>().savePlayers();
                          context.read<GameController>().resetGame();
                          context.read<GameController>().setPlayers = context.read<PlayersController>().removeEmptyPlayers();
                          Navigator.of(context).pushNamed(Routes.gamePrepare);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.colors.secondary,
                              content: DSText(
                                AppStrings.playersInfoErrorMessage,
                                customStyle: TextStyle(
                                  fontSize: theme.font.size.xxs,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(width: theme.spacing.inline.sm),
                    DSIconButtonWidget(
                      label: Icons.help_rounded,
                      size: const Size(50, 40),
                      onPressed: () => Navigator.of(context).pushNamed(Routes.guide),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              SizedBox(height: theme.spacing.inline.sm),
            ],
          ),
        ),
      ),
    );
  }
}
