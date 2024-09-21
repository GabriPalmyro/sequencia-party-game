import 'package:flutter/widgets.dart' hide PageRoute;
import 'package:go_router/go_router.dart';
import 'package:sequencia/common/router/page_route.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/common/router/widgets/not_found_page.dart';

class AppRouterConfig extends GoRouter {
  AppRouterConfig({
    required this.routes,
  }) : 
        super(
          initialLocation: Routes.home.path,
          routes: routes
            .map<GoRoute>((PageRoute route) => route.toGoRoute())
            .toList(),
          errorBuilder: (context, state) => NotFoundPage(),
          redirect: (BuildContext context, GoRouterState state) => null,
        );

  final List<PageRoute> routes;
}
