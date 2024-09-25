import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/design_system/core/tokens/design.dart';
import 'package:sequencia/common/router/app_navigator.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/features/domain/game/game_type_enum%20.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/features/screens/gameplay/widgets/player_page_view.dart';

import '../../../../common/design_system/components/button/button_widget.dart';
import '../../../../common/design_system/components/cards/theme_card_widget.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({Key? key}) : super(key: key);
  @override
  _GameplayScreenState createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late PageController _pageController;
  List<PlayerEntity> players = [];
  int currentPage = 0;
  List<int> playerCards = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < players.length) {
      if (currentPage == 0) {
        context.read<GameController>().changeGameType(GameTypeEnum.SHOW_PLAYERS_NUMBER);
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (currentPage + 1 == players.length) {
        context.read<GameController>().changeGameType(GameTypeEnum.ORDER_PLAYERS);
      }

      setState(() {
        currentPage++;
      });
    } else {
      GetIt.I<AppNavigator>().pushNamed(Routes.gameOrderPlayers);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final playersController = Provider.of<PlayersController>(context);
    players = playersController.players;
    final gameType = context.watch<GameController>().gameType;
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildThemePage(
                    theme,
                    context.read<GameController>().gameThemeNumber,
                    context.read<GameController>().gameThemeDescription,
                  ),
                  ...players.asMap().entries.map(
                        (entry) => PlayerPageView(
                          player: entry.value,
                        ),
                      ),
                ],
              ),
            ),
            SizedBox(height: theme.spacing.inline.xs),
            DSButtonWidget(
              label: gameType == GameTypeEnum.SHOW_PLAYERS_NUMBER
                  ? 'Revelar Tema'
                  : gameType == GameTypeEnum.SHOW_PLAYERS_NUMBER
                      ? 'Próximo'
                      : 'Ordenar Cartas',
              onPressed: _nextPage,
            ),
            SizedBox(height: theme.spacing.inline.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePage(DSTokens theme, String selectedTheme, String selectedDescription) {
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
      ),
    );
  }
}
