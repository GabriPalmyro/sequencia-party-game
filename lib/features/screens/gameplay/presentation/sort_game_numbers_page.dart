import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/widgets/ads/banner_ad_slot.dart';
import 'package:sequencia/core/ads/ads_service.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/features/screens/gameplay/presentation/widgets/exit_game_dialog_widget.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';
import 'package:sequencia/router/routes.dart';

class SortGameNumbersPage extends StatefulWidget {
  const SortGameNumbersPage({super.key});

  @override
  State<SortGameNumbersPage> createState() => _SortGameNumbersPageState();
}

class _SortGameNumbersPageState extends State<SortGameNumbersPage> {
  @override
  void initState() {
    super.initState();
    _sortNumbers();
  }

  Future<void> _sortNumbers() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<GameController>().selectRandomTheme();

      context.read<PlayersController>().players.shuffle();
      final players = context.read<PlayersController>().players;

      for (var i = 0; i < players.length; i++) {
        final newSortNumber =
            context.read<GameController>().getRandomAvailableNumber();
        context
            .read<GameController>()
            .updatePlayer(players[i], newNumber: newSortNumber);
      }

      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacementNamed(Routes.gameplay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DSText(
                context.l10n.sortingNumbers,
                textAlign: TextAlign.center,
                customStyle: TextStyle(
                  fontWeight: theme.font.weight.light,
                  color: theme.colors.white,
                  fontSize: theme.font.size.sm,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Lottie.asset(AppAnimations.clock),
              ),
              SizedBox(height: theme.spacing.inline.xxs),
              const BannerAdSlot(
                placement: AdBannerPlacement.playerSorting,
                size: AdSize.largeBanner,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
