import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/design_system/core/tokens/design.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/domain/game/game_type_enum.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/features/screens/gameplay/widgets/player_page_view.dart';
import 'package:sequencia/router/routes.dart';

import '../../../../common/design_system/components/button/button_widget.dart';
import '../../../../common/design_system/components/cards/theme_card_widget.dart';

class RevealCardsPage extends StatefulWidget {
  const RevealCardsPage({Key? key}) : super(key: key);
  @override
  _RevealCardsPageState createState() => _RevealCardsPageState();
}

class _RevealCardsPageState extends State<RevealCardsPage> {
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
      Navigator.of(context).pushReplacementNamed(Routes.discussionTime);
    }
  }

  void sortAnotherTheme() {
    context.read<GameController>().selectRandomTheme();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final gameController = Provider.of<GameController>(context);
    final gameType = context.watch<GameController>().gameType;
    players = gameController.players;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: theme.spacing.inline.xxs),
                DSButtonWidget(
                  label: gameType == GameTypeEnum.ORDER_PLAYERS ? 'Ordenar Cartas' : 'Próximo',
                  onPressed: _nextPage,
                ),
                if (gameType == GameTypeEnum.SHOW_THEME_CARD) ...[
                  SizedBox(width: theme.spacing.inline.sm),
                  DSIconButtonWidget(
                    label: Icons.restart_alt,
                    size: const Size(70, 40),
                    onPressed: sortAnotherTheme,
                  ),
                  SizedBox(width: theme.spacing.inline.xxs),
                ],
              ],
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
        size: Size(
          MediaQuery.of(context).size.width * 0.6,
          MediaQuery.of(context).size.height * 0.5,
        ),
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
