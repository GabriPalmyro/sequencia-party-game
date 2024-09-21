import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/core/game_themes.dart';

import '../../../common/design_system/components/cards/theme_card_widget.dart';

class GameplayScreen extends StatefulWidget {
  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> with SingleTickerProviderStateMixin {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
              child: Stack(
                clipBehavior: Clip.none, // Permite overflow
                alignment: Alignment.topCenter, // Alinha os filhos ao topo
                children: [
                  // Carta vermelha posicionada abaixo da ThemeCard
                  Positioned(
                    top: 100, // Ajuste para controlar a parte visível
                    left: 70,
                    child: Container(
                      width: 150,
                      height: 250, // Altura total da carta vermelha
                      decoration: BoxDecoration(
                        color: theme.colors.error,
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
                            padding: EdgeInsets.only(
                              left: theme.spacing.inline.xxs,
                              bottom: theme.spacing.inline.xxxs,
                            ),
                            child: DSText(
                              'gabriel',
                              textAlign: TextAlign.center,
                              customStyle: TextStyle(
                                fontSize: theme.font.size.xxs,
                                fontWeight: theme.font.weight.medium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ThemeCard
                  ThemeCard(
                    themeNumber: 'O seu tema é',
                    themeText: gameThemes[15],
                    isHidden: isHidden,
                  ),
                ],
              ),
            )
                .animate(
                  delay: 300.ms,
                )
                .moveY(
                  begin: MediaQuery.of(context).size.height,
                  end: 0,
                  duration: 500.ms,
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}
