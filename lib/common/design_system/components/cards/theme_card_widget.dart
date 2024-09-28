import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class ThemeCard extends StatefulWidget {
  const ThemeCard({
    required this.value,
    this.label,
    this.description,
    this.isEnableFlip = true,
    this.isHidden = false,
    this.onTap,
    this.shoudShowFlipLabel = true,
    this.size = const Size(200, 300),
    Key? key,
  }) : super(key: key);

  final Widget? label;
  final Widget value;
  final Widget? description;
  final bool isEnableFlip;
  final bool isHidden;
  final VoidCallback? onTap;
  final Size size;
  final bool shoudShowFlipLabel;

  @override
  _ThemeCardState createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador de Virada
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);

    // Verifica o estado inicial de isHidden
    if (widget.isHidden) {
      _flipController.value = 1; // Começa virado para mostrar a logo
    }
  }

  @override
  void didUpdateWidget(covariant ThemeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Só executa a animação se o valor de isHidden mudar
    if (oldWidget.isHidden != widget.isHidden) {
      _flipCard(widget.isHidden);
    }
  }

  void _flipCard(bool hide) {
    if (!widget.isEnableFlip) {
      return;
    }

    if (hide) {
      _flipController.forward(); // Anima para "virar" e esconder o conteúdo
    } else {
      _flipController.reverse(); // Anima para "desvirar" e mostrar o conteúdo
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);

    return AnimatedBuilder(
      animation: _flipController,
      builder: (context, child) {
        final double rotationValue = _rotationAnimation.value;
        final double angle = rotationValue * pi;
        final bool showBack = rotationValue >= 0.5;

        return Transform(
          transform: Matrix4.rotationY(angle),
          alignment: Alignment.center,
          child: showBack
              ? Transform(
                  transform: Matrix4.rotationY(pi),
                  alignment: Alignment.center,
                  child: CardContent(
                    size: widget.size,
                    label: widget.isEnableFlip && widget.shoudShowFlipLabel
                        ? SizedBox(
                            height: theme.spacing.inline.sm,
                          )
                        : null,
                    value: Padding(
                      padding: EdgeInsets.all(
                        theme.spacing.inline.xs,
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    description: widget.isEnableFlip && widget.shoudShowFlipLabel
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: theme.spacing.inline.xxs),
                            child: DSText(
                              'Toque na carta para virar',
                              textAlign: TextAlign.center,
                              customStyle: TextStyle(
                                fontSize: theme.font.size.xxxs,
                                fontWeight: theme.font.weight.light,
                                color: theme.colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
                )
              : CardContent(
                  size: widget.size,
                  label: widget.label,
                  value: widget.value,
                  description: widget.description,
                ),
        );
      },
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    required this.value,
    this.label,
    this.description,
    this.size = const Size(200, 300),
    Key? key,
  }) : super(key: key);
  final Widget? label;
  final Widget value;
  final Widget? description;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: theme.colors.card,
        borderRadius: BorderRadius.circular(
          theme.borders.radius.medium,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colors.grey.withOpacity(0.2),
            blurRadius: 0,
            offset: const Offset(4, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (label != null) ...{
              label!,
            },
            value,
            if (description != null) ...{
              description!,
            },
          ],
        ),
      ),
    );
  }
}
