import 'package:flutter/material.dart';
import 'package:sequencia/features/screens/game_guide/presentation/game_guide_page.dart';
import 'package:sequencia/features/screens/gameplay/presentation/discussion_time_page.dart';
import 'package:sequencia/features/screens/gameplay/presentation/order_players_card_page.dart';
import 'package:sequencia/features/screens/gameplay/presentation/reveal_cards_page.dart';
import 'package:sequencia/features/screens/gameplay/presentation/sort_game_numbers_page.dart';
import 'package:sequencia/features/screens/main_screen/presentation/main_screen_page.dart';
import 'package:sequencia/features/screens/settings/presentation/settings_page.dart';
import 'package:sequencia/features/screens/splash/presentation/splash_page.dart';
import 'package:sequencia/router/page_transition.dart';
import 'package:sequencia/router/routes.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SplashPage(),
          transitionsBuilder: PageTransition.slideUp,
        );
      case Routes.home:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreenPage(),
          transitionsBuilder: PageTransition.slideUp,
        );
      case Routes.gamePrepare:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SortGameNumbersPage(),
          transitionsBuilder: PageTransition.slideUp,
        );
      case Routes.gameplay:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RevealCardsPage(),
          transitionsBuilder: PageTransition.slideUp,
        );
      case Routes.discussionTime:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DiscussionTimePage(),
          transitionsBuilder: PageTransition.slideUp,
        );
      case Routes.gameOrderPlayers:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OrderPlayersCardPage(),
          transitionsBuilder: PageTransition.slideUp,
        );
      case Routes.settings:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SettingsPage(),
          transitionsBuilder: PageTransition.slideLeft,
        );
      case Routes.guide:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const GameGuidePage(),
          transitionsBuilder: PageTransition.slideLeft,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const MainScreenPage(),
        );
    }
  }
}
