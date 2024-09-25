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
    this.isInitHidden = false,
    Key? key,
  }) : super(key: key);
  final Widget? label;
  final Widget value;
  final Widget? description;
  final bool isEnableFlip;
  final bool isInitHidden;

  @override
  _ThemeCardState createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> with TickerProviderStateMixin {
  bool isRevealed = false;
  late AnimationController _flipController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    isRevealed = widget.isInitHidden;
    // Controlador de Virada
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);

    _flipCard();
  }

  void _flipCard() {
    if (!widget.isEnableFlip) {
      return;
    }

    if (isRevealed) {
      _flipController.forward();
      setState(() {
        isRevealed = !isRevealed;
      });
    } else {
      _flipController.reverse();
      setState(() {
        isRevealed = !isRevealed;
      });
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
      animation: Listenable.merge([_flipController]),
      builder: (context, child) {
        final double rotationValue = _rotationAnimation.value;
        final double angle = rotationValue * pi;
        final bool showBack = rotationValue >= 0.5;

        return GestureDetector(
          onTap: _flipCard,
          child: Transform(
            transform: Matrix4.rotationY(angle),
            alignment: Alignment.center,
            child: showBack
                ? Transform(
                    transform: Matrix4.rotationY(pi),
                    alignment: Alignment.center,
                    child: CardContent(
                      value: Padding(
                        padding: EdgeInsets.all(
                          theme.spacing.inline.xs,
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                        ),
                      ),
                    ),
                  )
                : CardContent(
                    label: widget.label,
                    value: widget.value,
                    description: widget.description,
                  ),
          ),
        );
      },
    );
  }
}

class PlayerColorCard extends StatelessWidget {
  const PlayerColorCard({
    required this.color,
    required this.name,
    super.key,
  });
  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Container(
      width: 130,
      height: 200,
      decoration: BoxDecoration(
        color: color,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(
              left: theme.spacing.inline.xxs,
              bottom: theme.spacing.inline.xxxs,
            ),
            child: DSText(
              name,
              customStyle: TextStyle(
                fontSize: theme.font.size.xxxs,
                fontWeight: theme.font.weight.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    required this.value,
    this.label,
    this.description,
    Key? key,
  }) : super(key: key);
  final Widget? label;
  final Widget value;
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Container(
      width: 200,
      height: 300,
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
