import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/info_card/info_card_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/router/app_navigator.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/screens/main_screen/presentation/widgets/players_names_inputs_widget.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<Offset> _logoAnimation;

  late AnimationController _fieldsController;
  late Animation<Offset> _fieldsAnimation;

  late AnimationController _buttonController;
  late Animation<Offset> _buttonAnimation;

  late AnimationController _infoCardController;
  late Animation<Offset> _infoCardAnimation;

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
    _fieldsAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fieldsController,
        curve: Curves.easeOut,
      ),
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: theme.spacing.inline.sm),
            SlideTransition(
              position: _logoAnimation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 325,
              ),
            ),
            SizedBox(height: theme.spacing.inline.md),
            const PlayersNamesInputsWidget(),
            const Spacer(),
            SlideTransition(
              position: _infoCardAnimation,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacing.inline.xs,
                ),
                child: const InfoCardWidget(
                  'Para começar um novo jogo, registre pelo menos 4 participantes.',
                ),
              ),
            ),
            SizedBox(height: theme.spacing.inline.sm),
            SlideTransition(
              position: _buttonAnimation,
              child: DSButtonWidget(
                label: 'Começar',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  GetIt.I.get<AppNavigator>().pushNamed(Routes.gameplay);
                },
              ),
            ),
            SizedBox(height: theme.spacing.inline.sm),
          ],
        ),
      ),
    );
  }
}
