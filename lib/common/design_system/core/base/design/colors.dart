import 'dart:ui';

import '../../tokens/design/colors.dart';

class BaseDSThemeColor implements DSThemeColor {
  BaseDSThemeColor({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? white,
    Color? grey,
    Color? error,
    Color? card,
    Color? background,
  }) {
    this.primary = primary ?? this.primary;
    this.secondary = secondary ?? this.secondary;
    this.tertiary = tertiary ?? this.tertiary;
    this.white = white ?? this.white;
    this.grey = grey ?? this.grey;
    this.error = error ?? this.error;
    this.card = card ?? this.card;
    this.background = background ?? this.background;
  }

  @override
  Color error = const Color(0xFFE03140);

  @override
  Color white = const Color(0xFFFEFEFE);

  @override
  Color grey = const Color(0xFF042534);

  @override
  Color primary = const Color(0xFF4B6FAD);

  @override
  Color secondary = const Color(0xFF50538A);

  @override
  Color tertiary = const Color(0xFF6DB176);

  @override
  Color card = const Color(0xFF484848);

  @override
  Color background = const Color(0xFF38474D);
}
