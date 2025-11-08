import 'design/borders.dart';
import 'design/colors.dart';
import 'design/font.dart';
import 'design/spacing.dart';

abstract class DSTokens {
  DSTokens({
    required this.colors,
    required this.font,
    required this.spacing,
    required this.borderWidth,
    required this.borders,
  });

  final DSBorder borders;
  final DSThemeColor colors;
  final DSThemeFont font;
  final DSThemeSpacing spacing;
  final DSBorderWidth borderWidth;
}
