import 'package:flutter/widgets.dart';

import '../ds_theme.dart';
import '../unique_theme_manager.dart';

class UniqueThemeBuilder extends StatelessWidget {
  const UniqueThemeBuilder(
      {required this.uniqueThemeManager, required this.child, super.key});
  final UniqueThemeManager uniqueThemeManager;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DSThemeData>(
      future: uniqueThemeManager.getAppTheme(),
      builder: (context, theme) => DSTheme(
        data: theme.data!,
        child: child,
      ),
    );
  }
}
