import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

import '../../common/design_system/components/cards/theme_card_widget.dart';

class GameplayScreen extends StatefulWidget {
  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> with SingleTickerProviderStateMixin {
  bool moveCard = false;
  late AnimationController _moveController;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _moveController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.5, 2.5), // Ajuste esses valores conforme necessário
    ).animate(
      CurvedAnimation(
        parent: _moveController,
        curve: Curves.easeInOut,
      ),
    );

    // Iniciar a animação de movimento após a revelação
    Future.delayed(Duration(seconds: 3), () {
      _moveController.forward();
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Outros widgets do gameplay
          // ...

          // Carta do Tema
          AnimatedBuilder(
            animation: _moveController,
            builder: (context, child) {
              return FractionalTranslation(
                translation: _positionAnimation.value,
                child: child,
              );
            },
            child: ThemeCard(
              themeNumber: '5',
              themeText: 'Animais',
            ),
          ),
        ],
      ),
    );
  }
}
