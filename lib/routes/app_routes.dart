

import 'package:router/page_route.dart';
import 'package:sequencia/routes/routes.dart';
import 'package:sequencia/screens/main_screen/presentation/main_screen_page.dart';

final routes = [
  PageRoute(
    name: Routes.home.name,
    path: Routes.home.path,
    builder: (context, state) => const MainScreenPage(),
  ),
];
