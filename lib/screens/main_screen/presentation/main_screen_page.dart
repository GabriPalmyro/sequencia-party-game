import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends State<MainScreenPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                top: _logoAnimation.value * size.height,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    SizedBox(height: theme.spacing.inline.md),
                    Image.asset(
                      'assets/images/logo.png',
                      width: size.width * 0.75,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: _buttonAnimation.value * (size.height * -0.15),
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    DSButtonWidget(
                      label: 'Começar',
                      onPressed: () {
                        HapticFeedback.selectionClick();
                      },
                    ),
                    SizedBox(height: theme.spacing.inline.sm),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
