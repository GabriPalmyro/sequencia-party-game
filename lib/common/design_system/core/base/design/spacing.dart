
import 'package:flutter/material.dart';

import '../../tokens/design/spacing.dart';

class BaseDSThemeSpacing implements DSThemeSpacing {
  BaseDSThemeSpacing({
    DSThemeSpacingInline? inline,
    DSThemeSpacingInset? inset,
    DSThemeSpacingSquish? squish,
    DSThemeSpacingStack? stack,
  }) {
    this.inline = inline ?? this.inline;
    this.inset = inset ?? this.inset;
    this.squish = squish ?? this.squish;
    this.stack = stack ?? this.stack;
  }

  @override
  DSThemeSpacingInline inline = BaseDSThemeSpacingInline();

  @override
  DSThemeSpacingInset inset = BaseDSThemeSpacingInset();

  @override
  DSThemeSpacingSquish squish = BaseDSThemeSpacingSquish();

  @override
  DSThemeSpacingStack stack = BaseDSThemeSpacingStack();
}

class BaseDSThemeSpacingInline implements DSThemeSpacingInline {
  BaseDSThemeSpacingInline({
    double? xxxs,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    this.xxxs = xxxs ?? this.xxxs;
    this.xxs = xxs ?? this.xxs;
    this.xs = xs ?? this.xs;
    this.sm = sm ?? this.sm;
    this.md = md ?? this.md;
    this.lg = lg ?? this.lg;
    this.xl = xl ?? this.xl;
    this.xxl = xxl ?? this.xxl;
    this.xxxl = xxxl ?? this.xxxl;
  }

  @override
  double xxxs = 4;

  @override
  double xxs = 8;

  @override
  double xs = 16;

  @override
  double sm = 24;

  @override
  double md = 32;

  @override
  double lg = 40;

  @override
  double xl = 48;

  @override
  double xxl = 56;

  @override
  double xxxl = 64;
}

class BaseDSThemeSpacingInset implements DSThemeSpacingInset {
  BaseDSThemeSpacingInset({
    EdgeInsets? xxs,
    EdgeInsets? xs,
    EdgeInsets? sm,
    EdgeInsets? md,
    EdgeInsets? lg,
    EdgeInsets? xl,
  }) {
    this.xxs = xxs ?? this.xxs;
    this.xs = xs ?? this.xs;
    this.sm = sm ?? this.sm;
    this.md = md ?? this.md;
    this.lg = lg ?? this.lg;
    this.xl = xl ?? this.xl;
  }

  @override
  EdgeInsets xxs = const EdgeInsets.all(4);

  @override
  EdgeInsets xs = const EdgeInsets.all(8);

  @override
  EdgeInsets sm = const EdgeInsets.all(16);

  @override
  EdgeInsets md = const EdgeInsets.all(24);

  @override
  EdgeInsets lg = const EdgeInsets.all(32);

  @override
  EdgeInsets xl = const EdgeInsets.all(48);
}

class BaseDSThemeSpacingSquish implements DSThemeSpacingSquish {

  BaseDSThemeSpacingSquish({
    EdgeInsets? xs,
    EdgeInsets? sm,
    EdgeInsets? md,
    EdgeInsets? lg,
  }) {
    this.xs = xs ?? this.xs;
    this.sm = sm ?? this.sm;
    this.md = md ?? this.md;
    this.lg = lg ?? this.lg;
  }

  @override
  EdgeInsets lg = const EdgeInsets.symmetric(horizontal: 8, vertical: 16);

  @override
  EdgeInsets md = const EdgeInsets.symmetric(horizontal: 16, vertical: 24);

  @override
  EdgeInsets sm = const EdgeInsets.symmetric(horizontal: 16, vertical: 32);

  @override
  EdgeInsets xs = const EdgeInsets.symmetric(horizontal: 24, vertical: 40);
}

class BaseDSThemeSpacingStack implements DSThemeSpacingStack {
  BaseDSThemeSpacingStack({
    double? xxxs,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
  }) {
    this.xxxs = xxxs ?? this.xxxs;
    this.xxs = xxs ?? this.xxs;
    this.xs = xs ?? this.xs;
    this.sm = sm ?? this.sm;
    this.md = md ?? this.md;
    this.lg = lg ?? this.lg;
    this.xl = xl ?? this.xl;
    this.xxl = xxl ?? this.xxl;
    this.xxxl = xxxl ?? this.xxxl;
  }

  @override
  double xxxs = 4;

  @override
  double xxs = 8;

  @override
  double xs = 16;

  @override
  double sm = 24;

  @override
  double md = 32;

  @override
  double lg = 48;

  @override
  double xl = 54;

  @override
  double xxl = 64;

  @override
  double xxxl = 82;
}
