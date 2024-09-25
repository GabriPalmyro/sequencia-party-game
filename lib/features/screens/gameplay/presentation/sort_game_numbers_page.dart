import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/common/router/app_navigator.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/controller/players_controller.dart';

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

      final players = context.read<PlayersController>().players;

      for (var i = 0; i < players.length; i++) {
        final newSortNumber = context.read<GameController>().getRandomAvailableNumber();
        context.read<GameController>().updatePlayer(players[i], newNumber: newSortNumber);
      }

      await Future.delayed(const Duration(seconds: 3));

      GetIt.I<AppNavigator>().pushNamed(Routes.gameplay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DSText(
              'Sorteando números...',
              textAlign: TextAlign.center,
              customStyle: TextStyle(
                fontWeight: theme.font.weight.light,
                color: theme.colors.white,
                fontSize: theme.font.size.sm,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Lottie.asset('assets/animations/clock-animation.json'),
            ),
          ],
        ),
      ),
    );
  }
}
