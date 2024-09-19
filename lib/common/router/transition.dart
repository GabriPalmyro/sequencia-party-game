import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum PageTransition {
  none(_noTransition);

  const PageTransition(this.builder);

  final CustomTransitionPage<dynamic> Function(Widget page) builder;
}

CustomTransitionPage<dynamic> _noTransition(Widget page) => NoTransitionPage(child: page);