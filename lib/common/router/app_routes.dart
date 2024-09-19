
import 'package:sequencia/common/router/page_route.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/screens/gameplay/gameplay_page.dart';
import 'package:sequencia/screens/main_screen/presentation/main_screen_page.dart';

final routes = [
  PageRoute(
    route: Routes.home,
    builder: (context, state) => const MainScreenPage(),
  ),
  PageRoute(
    route: Routes.gameplay,
    builder: (context, state) => GameplayScreen(),
  ),
];
