
import 'package:flutter/material.dart';

import '../../tokens/design/borders.dart';

class BaseDSThemeBorder implements DSBorder {
  BaseDSThemeBorder({
    DSBorderStyle? style,
    DSBorderRadius? radius,
    DSBorderWidth? width,
  }) {
    this.style = style ?? this.style;
    this.radius = radius ?? this.radius;
    this.width = width ?? this.width;
  }

  @override
  DSBorderRadius radius = BaseDSThemeBorderRadius();

  @override
  DSBorderStyle style = BaseDSThemeBorderStyle();

  @override
  DSBorderWidth width = BaseDSThemeBorderWidth();
}

class BaseDSThemeBorderRadius implements DSBorderRadius {
  BaseDSThemeBorderRadius({
    double? small,
    double? medium,
    double? large,
    double? pill,
    double? circular,
    double? radiusDefault,
  }) {
    this.small = small ?? this.small;
    this.medium = medium ?? this.medium;
    this.large = large ?? this.large;
    this.pill = pill ?? this.pill;
    this.circular = circular ?? this.circular;
    this.radiusDefault = radiusDefault ?? this.radiusDefault;
  }
  
  @override
  double radiusDefault = 0;

  @override
  double small = 4;

  @override
  double medium = 8;

  @override
  double large = 16;
  
  @override
  double circular = 500;
  
  @override
  double pill = 500;
}

class BaseDSThemeBorderStyle implements DSBorderStyle {
  BaseDSThemeBorderStyle({
    BorderStyle? styleDefault,
  }) {
    this.styleDefault = styleDefault ?? this.styleDefault;
  }
  
  @override
  BorderStyle styleDefault = BorderStyle.solid;
}

class BaseDSThemeBorderWidth implements DSBorderWidth {
  BaseDSThemeBorderWidth({
    double? thin,
    double? thick,
    double? thicker,
    double? widthDefault,
  }) {
    this.thin = thin ?? this.thin;
    this.thick = thick ?? this.thick;
    this.thicker = thicker ?? this.thicker;
    this.widthDefault = widthDefault ?? this.widthDefault;
  }
  
  @override
  double widthDefault = 0;

  @override
  double thin = 1;

  @override
  double thick = 2;

  @override
  double thicker = 4;
}