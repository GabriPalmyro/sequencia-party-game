import 'package:flutter/material.dart';

class PageTransition {
  PageTransition._();
  static SlideTransition slideUp(_, anim, __, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideDown(_, anim, __, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideRight(_, anim, __, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    );
  }

  static SlideTransition slideLeft(_, anim, __, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    );
  }
}
