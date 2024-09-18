import 'package:flutter/material.dart';

class DSThemeFont {
  DSThemeFont({
    required this.family,
    required this.weight,
    required this.size,
  });

  OwnThemeFontFamily family;
  DSFontWeight weight;
  DSFontSize size;
}

class OwnThemeFontFamily {
  OwnThemeFontFamily({required this.base});
  String base;
}

class DSFontWeight {
  DSFontWeight({
    required this.light,
    required this.regular,
    required this.medium,
    required this.semiBold,
    required this.bold,
  });

  FontWeight light;
  FontWeight regular;
  FontWeight medium;
  FontWeight semiBold;
  FontWeight bold;
}

class DSFontSize {
  DSFontSize({
    required this.us,
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.ul,
  });
  
  /// `12`
  double us;

  /// `14`
  double xxxs;

  /// `16`
  double xxs;

  /// `20`
  double xs;

  /// `24`
  double sm;

  /// `32`
  double md;

  /// `40`
  double lg;

  /// `48`
  double xl;

  /// `56`
  double xxl;

  /// `64`
  double xxxl;

  /// `80`
  double ul;
}
