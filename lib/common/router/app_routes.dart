import 'package:sequencia/common/router/page_route.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/common/router/transition.dart';
import 'package:sequencia/features/screens/gameplay/presentation/order_players_card_page.dart';
import 'package:sequencia/features/screens/gameplay/presentation/review_cards_page.dart';
import 'package:sequencia/features/screens/gameplay/presentation/sort_game_numbers_page.dart';
import 'package:sequencia/features/screens/main_screen/presentation/main_screen_page.dart';

final routes = [
  PageRoute(
    route: Routes.home,
    builder: (_, __) => const MainScreenPage( ),
  ),
  PageRoute(
    route: Routes.gamePrepare,
    transition: PageTransition.slideFromBottom,
    builder: (context, state) => const SortGameNumbersPage(),
  ),
  PageRoute(
    route: Routes.gameplay,
    transition: PageTransition.slideFromRight,
    builder: (context, state) => const GameplayScreen(),
  ),
  PageRoute(
    route: Routes.gameOrderPlayers,
    transition: PageTransition.slideFromRight,
    builder: (context, state) => const OrderPlayersCardPage(),
  ),
];
