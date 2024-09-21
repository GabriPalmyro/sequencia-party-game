import 'package:sequencia/common/router/page_route.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/common/router/transition.dart';
import 'package:sequencia/features/screens/gameplay/gameplay_page.dart';
import 'package:sequencia/features/screens/main_screen/presentation/main_screen_page.dart';

final routes = [
  PageRoute(
    route: Routes.home,
    builder: (_, __) => const MainScreenPage( ),
  ),
  PageRoute(
    route: Routes.gameplay,
    transition: PageTransition.slideFromRight,
    builder: (context, state) => GameplayScreen(),
  ),
];
