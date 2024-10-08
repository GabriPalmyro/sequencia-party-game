import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/button/button_widget.dart';
import 'package:sequencia/common/design_system/components/button/icon_button_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/screens/game_guide/presentation/widgets/name_step_page.dart';
import 'package:sequencia/features/screens/game_guide/presentation/widgets/sort_step_page.dart';

class GameGuidePage extends StatefulWidget {
  const GameGuidePage({super.key});

  @override
  State<GameGuidePage> createState() => _GameGuidePageState();
}

class _GameGuidePageState extends State<GameGuidePage> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                const NameStepPage(),
                const SortStepPage(),
                Container(
                  color: Colors.green,
                  child: Center(
                    child: Text('Settings Page 3'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.spacing.inline.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DSIconButtonWidget(
                size: Size(50, 40),
                label: Icons.chevron_left,
                onPressed: () {
                  if (_pageController.page!.toInt() == 0) {
                    Navigator.of(context).pop();
                  }
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              DSButtonWidget(
                label: 'Próximo',
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              SizedBox(width: theme.spacing.inline.md),
            ],
          ),
          SizedBox(height: theme.spacing.inline.sm),
        ],
      ),
    );
  }
}
