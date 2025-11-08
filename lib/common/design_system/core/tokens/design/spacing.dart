import 'package:flutter/material.dart';

class DSThemeSpacing {
  DSThemeSpacing({
    required this.stack,
    required this.inset,
    required this.squish,
    required this.inline,
  });

  DSThemeSpacingStack stack;
  DSThemeSpacingInset inset;
  DSThemeSpacingSquish squish;
  DSThemeSpacingInline inline;
}

class DSThemeSpacingStack {
  DSThemeSpacingStack({
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// `4 px`
  double xxxs;

  /// `8 px`
  double xxs;

  /// `16 px`
  double xs;

  /// `24 px`
  double sm;

  /// `32 px`
  double md;

  /// `40 px`
  double lg;

  /// `64 px`
  double xl;

  /// `96 px`
  double xxl;

  /// `128 px`
  double xxxl;
}

class DSThemeSpacingInline {
  DSThemeSpacingInline({
    required this.xxxs,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
  });

  /// `4 px`
  double xxxs;

  /// `8 px`
  double xxs;

  /// `16 px`
  double xs;

  /// `24 px`
  double sm;

  /// `32 px`
  double md;

  /// `40 px`
  double lg;

  /// `48 px`
  double xl;

  /// `56 px`
  double xxl;

  /// `64 px`
  double xxxl;
}

class DSThemeSpacingInset {
  DSThemeSpacingInset({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  /// `EdgeInsets.all(4)`
  EdgeInsets xxs;

  /// `EdgeInsets.all(8)`
  EdgeInsets xs;

  /// `EdgeInsets.all(16)`
  EdgeInsets sm;

  /// `EdgeInsets.all(24)`
  EdgeInsets md;

  /// `EdgeInsets.all(32)`
  EdgeInsets lg;

  /// `EdgeInsets.all(48)`
  EdgeInsets xl;
}

class DSThemeSpacingSquish {
  DSThemeSpacingSquish({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
  });

  /// `EdgeInsets.symmetric(vertical: 8, horizontal: 16)`
  EdgeInsets xs;

  /// `EdgeInsets.symmetric(vertical: 16, horizontal: 24)`
  EdgeInsets sm;

  /// `EdgeInsets.symmetric(vertical: 16, horizontal: 32)`
  EdgeInsets md;

  /// `EdgeInsets.symmetric(vertical: 24, horizontal: 40)`
  EdgeInsets lg;
}
