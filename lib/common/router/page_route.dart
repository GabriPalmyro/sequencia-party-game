import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sequencia/common/router/routes.dart';
import 'package:sequencia/common/router/transition.dart';

class PageRoute {
  PageRoute({
    required this.route,
    required this.builder,
    this.routes,
    this.redirect,
    this.transition,
  });

  final Routes route;
  final Widget Function(BuildContext, GoRouterState) builder;
  final List<PageRoute>? routes;
  final FutureOr<String?> Function(BuildContext, GoRouterState)? redirect;
  final PageTransition? transition;

  GoRoute toGoRoute({bool isSubRoute = false}) => GoRoute(
        name: route.name,
        path: (isSubRoute && route.path.startsWith('/')) ? route.path.substring(1) : route.path,
        routes: routes?.map<GoRoute>((route) => route.toGoRoute(isSubRoute: true)).toList() ?? [],
        builder: builder,
        pageBuilder: (transition != null)
            ? (context, state) {
                final page = builder(context, state);
                return transition!.builder(page);
              }
            : null,
        redirect: (context, state) async {
          return await redirect?.call(context, state);
        },
      );
}
