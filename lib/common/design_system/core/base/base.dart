

import '../theme/ds_theme.dart';
import '../tokens/design.dart';
import '../tokens/design/borders.dart';
import '../tokens/design/colors.dart';
import '../tokens/design/font.dart';
import '../tokens/design/spacing.dart';
import 'design/borders.dart';
import 'design/colors.dart';
import 'design/font.dart';
import 'design/spacing.dart';

class BaseDSDesignToken implements DSTokens {
  @override
  final DSThemeColor colors = BaseDSThemeColor();

  @override
  final DSThemeFont font = BaseDSThemeFont();

  @override
  DSBorderWidth get borderWidth => BaseDSThemeBorderWidth();

  @override
  DSBorder get borders => BaseDSThemeBorder();

  @override
  DSThemeSpacing get spacing => BaseDSThemeSpacing();
}

class BaseOwnThemeData implements DSThemeData {
  @override
  DSTokens get designTokens => BaseDSDesignToken();

  @override
  String get name => 'base';
  
}