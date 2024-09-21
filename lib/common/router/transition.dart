import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

enum PageTransition {
  none(_noTransition),
  fade(_fadeTransition),
  slideFromRight(_slideFromRightTransition),
  slideFromBottom(_slideFromBottomTransition);

  const PageTransition(this.builder);

  final CustomTransitionPage<dynamic> Function(Widget page) builder;
}

CustomTransitionPage<dynamic> _noTransition(Widget page) => NoTransitionPage(child: page);

CustomTransitionPage<dynamic> _fadeTransition(Widget page) => CustomTransitionPage(
  child: page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  },
);
CustomTransitionPage<dynamic> _slideFromRightTransition(Widget page) => CustomTransitionPage(
  child: page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInCirc, // You can choose any curve you prefer
    );

    final offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Starts off-screen to the right
      end: Offset.zero,
    ).animate(curvedAnimation);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  },
);

CustomTransitionPage<dynamic> _slideFromBottomTransition(Widget page) => CustomTransitionPage(
  child: page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Começa fora da tela embaixo
      end: Offset.zero,
    ).animate(animation);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  },
);
