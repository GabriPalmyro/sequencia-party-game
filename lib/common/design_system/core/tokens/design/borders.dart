import 'package:flutter/widgets.dart';

abstract class DSBorder {
  DSBorder({
    required this.style,
    required this.width,
    required this.radius,
  });

  DSBorderStyle style;
  DSBorderWidth width;
  DSBorderRadius radius;
}

abstract class DSBorderStyle {
  DSBorderStyle({
    required this.styleDefault,
  });

  BorderStyle styleDefault;
}

abstract class DSBorderWidth {
  DSBorderWidth({
    required this.widthDefault,
    required this.thin,
    required this.thick,
    required this.thicker,
  });

  double widthDefault;
  double thin;
  double thick;
  double thicker;
}

abstract class DSBorderRadius {
  DSBorderRadius({
    required this.radiusDefault,
    required this.small,
    required this.medium,
    required this.large,
    required this.pill,
    required this.circular,
  });

  double radiusDefault;
  double small;
  double medium;
  double large;
  double pill;
  double circular;
}
