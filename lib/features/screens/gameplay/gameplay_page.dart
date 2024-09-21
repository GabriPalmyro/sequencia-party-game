import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/design_system/core/tokens/design.dart';
import 'package:sequencia/core/game_themes.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';

import '../../../common/design_system/components/button/button_widget.dart';
import '../../../common/design_system/components/cards/theme_card_widget.dart';

class GameplayScreen extends StatefulWidget {
  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late PageController _pageController;
  String selectedTheme = '';
  String selectedDescription = '';
  List<PlayerEntity> players = [];
  int currentPage = 0;
  List<int> playerCards = [];

  @override
  void initState() {
    super.initState();
    _selectRandomTheme();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectRandomTheme() {
    final random = Random().nextInt(gameThemes.length);
    selectedTheme = random.toString();
    selectedDescription = gameThemes[random];
  }

  void _generatePlayerCards() {
    final random = Random();
    playerCards = List.generate(players.length, (_) => random.nextInt(90) + 10);
    playerCards.sort();
  }

  void _nextPage() {
    if (currentPage == 0) {
      _generatePlayerCards();
    }
    if (currentPage <= players.length) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        currentPage++;
      });
    } else {
      // Navigate to ordering screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => OrderingScreen(
                  players: players,
                  theme: selectedTheme,
                  playerCards: playerCards,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final playersController = Provider.of<PlayersController>(context);
    players = playersController.players;

    return Scaffold(
      backgroundColor: theme.colors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildThemePage(theme),
                  ...players.asMap().entries.map((entry) => _buildPlayerPage(theme, entry.value, entry.key)),
                ],
              ),
            ),
            SizedBox(height: 20),
            DSButtonWidget(
              label: currentPage == 0
                  ? 'Revelar Tema'
                  : currentPage <= players.length
                      ? 'Próximo Jogador'
                      : 'Iniciar Ordenação',
              onPressed: _nextPage,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePage(DSTokens theme) {
    return Center(
      child: ThemeCard(
        label: DSText(
          'O tema é',
          textAlign: TextAlign.center,
          customStyle: TextStyle(
            fontSize: theme.font.size.xxs,
            fontWeight: theme.font.weight.light,
            color: theme.colors.white,
          ),
        ),
        value: DSText(
          selectedTheme,
          textAlign: TextAlign.center,
          customStyle: TextStyle(
            fontSize: theme.font.size.xxxl,
            fontWeight: theme.font.weight.bold,
            color: theme.colors.white,
          ),
        ),
        description: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.inline.xxs),
          child: DSText(
            selectedDescription,
            textAlign: TextAlign.center,
            customStyle: TextStyle(
              fontSize: theme.font.size.xxxs,
              fontWeight: theme.font.weight.regular,
              color: theme.colors.white,
            ),
          ),
        ),
        isEnableFlip: false,
        isInitReveal: true,
      ),
    );
  }

  Widget _buildPlayerPage(DSTokens theme, PlayerEntity player, int index) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -35,
                left: 10,
                child: PlayerColorCard(
                  color: player.color ?? theme.colors.tertiary,
                  name: player.name,
                ),
              ),
              ThemeCard(
                isEnableFlip: true,
                isInitReveal: false,
                label: DSText(
                  'Seu número é',
                  customStyle: TextStyle(
                    fontSize: theme.font.size.sm,
                    fontWeight: theme.font.weight.light,
                    color: theme.colors.white,
                  ),
                ),
                value: DSText(
                  selectedTheme,
                  customStyle: TextStyle(
                    fontSize: theme.font.size.xxxl,
                    fontWeight: theme.font.weight.bold,
                    color: theme.colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder for the OrderingScreen
class OrderingScreen extends StatelessWidget {
  final List<PlayerEntity> players;
  final String theme;
  final List<int> playerCards;

  const OrderingScreen({
    Key? key,
    required this.players,
    required this.theme,
    required this.playerCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement the ordering screen here
    return Scaffold(
      body: Center(
        child: Text('Ordering Screen - Implement me!'),
      ),
    );
  }
}
