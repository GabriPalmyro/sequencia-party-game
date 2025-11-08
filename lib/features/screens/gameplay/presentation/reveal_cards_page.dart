import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/design_system/core/tokens/design.dart';
import 'package:sequencia/common/widgets/ads/banner_ad_slot.dart';
import 'package:sequencia/core/ads/ads_service.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/domain/game/game_type_enum.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/exit_game_dialog_widget.dart';
import 'package:sequencia/features/screens/gameplay/widgets/player_page_view.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';
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
        context
            .read<GameController>()
            .changeGameType(GameTypeEnum.SHOW_PLAYERS_NUMBER);
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (currentPage + 1 == players.length) {
        context
            .read<GameController>()
            .changeGameType(GameTypeEnum.ORDER_PLAYERS);
      }

      setState(() {
        currentPage++;
      });
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.discussionTime);
    }
  }

  void _backPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (currentPage == players.length) {
        context
            .read<GameController>()
            .changeGameType(GameTypeEnum.SHOW_PLAYERS_NUMBER);
      } else if (currentPage - 1 == 0) {
        context
            .read<GameController>()
            .changeGameType(GameTypeEnum.SHOW_THEME_CARD);
      }

      setState(() {
        currentPage--;
      });
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        showDialog(
          context: context,
          builder: (_) => const ExitGameDialogWidget(),
        );
      },
      child: Scaffold(
        backgroundColor: theme.colors.background,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: theme.spacing.inline.sm),
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ExitGameDialogWidget(),
                      );
                    },
                    child: DSText(
                      context.l10n.backLabel,
                      textAlign: TextAlign.start,
                      customStyle: TextStyle(
                        fontSize: theme.font.size.sm,
                        fontWeight: theme.font.weight.bold,
                        color: theme.colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: theme.spacing.inline.md),
              const BannerAdSlot(
                placement: AdBannerPlacement.playerSorting,
                size: AdSize.largeBanner,
              ),
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
                  if (currentPage > 0) ...[
                    const Spacer(),
                    DSIconButtonWidget(
                      label: Icons.keyboard_arrow_left_rounded,
                      size: const Size(70, 40),
                      onPressed: _backPage,
                    ),
                  ],
                  const Spacer(),
                  DSButtonWidget(
                    label: gameType == GameTypeEnum.ORDER_PLAYERS
                        ? context.l10n.orderLabel
                        : context.l10n.nextLabel,
                    onPressed: _nextPage,
                  ),
                  const Spacer(),
                  if (gameType == GameTypeEnum.SHOW_THEME_CARD) ...[
                    SizedBox(width: theme.spacing.inline.sm),
                    DSIconButtonWidget(
                      label: Icons.restart_alt,
                      size: const Size(70, 40),
                      onPressed: sortAnotherTheme,
                    ),
                    const Spacer(),
                  ],
                ],
              ),
              SizedBox(height: theme.spacing.inline.sm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemePage(
      DSTokens theme, String selectedTheme, String selectedDescription) {
    return Center(
      child: ThemeCard(
        size: Size(
          MediaQuery.of(context).size.width * 0.6,
          MediaQuery.of(context).size.height * 0.5,
        ),
        label: DSText(
          context.l10n.themeIsLabel,
          textAlign: TextAlign.center,
          customStyle: TextStyle(
            fontSize: theme.font.size.xs,
            fontWeight: theme.font.weight.light,
            color: theme.colors.white,
          ),
        ),
        value: DSText(
          selectedTheme,
          textAlign: TextAlign.center,
          customStyle: TextStyle(
            fontSize: theme.font.size.ul,
            fontWeight: theme.font.weight.bold,
            color: theme.colors.white,
          ),
        ),
        description: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.inline.sm),
          child: DSText(
            selectedDescription,
            textAlign: TextAlign.center,
            customStyle: TextStyle(
              fontSize: theme.font.size.xxs,
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
