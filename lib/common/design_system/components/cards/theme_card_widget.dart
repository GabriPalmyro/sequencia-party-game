import 'dart:math';

import 'package:flutter/material.dart';

class ThemeCard extends StatefulWidget {

  const ThemeCard({
    required this.themeNumber,
    required this.themeText,
    Key? key,
  }) : super(key: key);
  final String themeNumber;
  final String themeText;

  @override
  _ThemeCardState createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> with TickerProviderStateMixin {
  bool isRevealed = false;
  late AnimationController _flipController;
  late AnimationController _moveController;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador de Virada
    _flipController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(_flipController);

    // Controlador de Movimento
    _moveController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 2.0), // Ajuste conforme necessário
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));

    // Animação de Escala
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));

    // Iniciar a animação de virada após um pequeno delay
    Future.delayed(Duration(seconds: 1), () {
      _flipController.forward();
      setState(() {
        isRevealed = true;
      });
    });

    // Iniciar a animação de movimento após a virada
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _moveController.forward();
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_flipController, _moveController]),
      builder: (context, child) {
        double rotationValue = _rotationAnimation.value;
        double angle = rotationValue * pi;
        bool showBack = rotationValue >= 0.5;

        return Transform.translate(
          offset: _positionAnimation.value * MediaQuery.of(context).size.width / 2,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform(
              transform: Matrix4.rotationY(angle),
              alignment: Alignment.center,
              child: showBack
                  ? CardContent(
                      text: '${widget.themeNumber}\n${widget.themeText}',
                    )
                  : CardContent(
                      text: 'Carta\nVirada',
                    ),
            ),
          ),
        );
      },
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({required this.text, Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Estilize sua carta conforme necessário
      child: Container(
        width: 200,
        height: 300,
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
