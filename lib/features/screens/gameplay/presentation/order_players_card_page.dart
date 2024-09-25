import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sequencia/common/design_system/components/cards/player_color_card_widget.dart';
import 'package:sequencia/common/design_system/components/cards/theme_card_widget.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/controller/players_controller.dart';

class OrderPlayersCardPage extends StatefulWidget {
  const OrderPlayersCardPage({super.key});

  @override
  State<OrderPlayersCardPage> createState() => _OrderPlayersCardPageState();
}

class _OrderPlayersCardPageState extends State<OrderPlayersCardPage> {
  // void _onReorder(int oldIndex, int newIndex) {
  //   setState(() {
  //     Widget row = _tiles.removeAt(oldIndex);
  //     _tiles.insert(newIndex, row);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: Column(
        children: [
          SizedBox(height: theme.spacing.inline.md),
          ReorderableWrap(
            spacing: theme.spacing.inline.sm,
            runSpacing: theme.spacing.inline.xxxl,
            padding: const EdgeInsets.all(8),
            children: context.read<PlayersController>().players.map((player) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -35,
                    left: 10,
                    child: PlayerColorCard(
                      size: const Size(80, 100),
                      color: player.color ?? theme.colors.tertiary,
                      name: player.name,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   isHidden = !isHidden;
                      // });
                    },
                    child: ThemeCard(
                      size: const Size(100, 150),
                      isHidden: true,
                      label: DSText(
                        'Seu número é',
                        customStyle: TextStyle(
                          fontSize: theme.font.size.sm,
                          fontWeight: theme.font.weight.light,
                          color: theme.colors.white,
                        ),
                      ),
                      value: DSText(
                        player.orderNumber ?? '',
                        customStyle: TextStyle(
                          fontSize: theme.font.size.xxxl,
                          fontWeight: theme.font.weight.bold,
                          color: theme.colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            onReorder: (int oldIndex, int newIndex) {
              //this callback is required
              // context.read<PlayersController>().reorderPlayers(oldIndex, newIndex);
            },
            onNoReorder: (int index) {
              //this callback is optional
              debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
            },
            onReorderStarted: (int index) {
              //this callback is optional
              debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
            },
          ),
        ],
      ),
    );
  }
}
