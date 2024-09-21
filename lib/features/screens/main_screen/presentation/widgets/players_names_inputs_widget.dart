import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text_field/text_field_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/controller/players_controller.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/features/screens/main_screen/presentation/widgets/select_player_color_modal.dart';

class PlayersNamesInputsWidget extends StatefulWidget {
  const PlayersNamesInputsWidget({super.key});

  @override
  State<PlayersNamesInputsWidget> createState() => _PlayersNamesInputsWidgetState();
}

class _PlayersNamesInputsWidgetState extends State<PlayersNamesInputsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PlayersController>().addPlayer(const PlayerEntity(name: ''));
    });
  }

  void _onTextChanged(String text, int index) {
    final lowercaseText = text.toLowerCase();
    context.read<PlayersController>().updatePlayerName(context.read<PlayersController>().players[index], lowercaseText);

    if (lowercaseText.isNotEmpty && index == context.read<PlayersController>().players.length - 1) {
      context.read<PlayersController>().addPlayer(const PlayerEntity(name: ''));
    }
  }

  void _removePlayer(int index) {
    if (context.read<PlayersController>().players.length > 1) {
      context.read<PlayersController>().removePlayer(context.read<PlayersController>().players[index]);
      setState(() {});
    }
  }

  void _selectColor(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SelectPlayerColorModal(
          availableColors: context.read<PlayersController>().availableColors,
          onColorSelected: (color) {
            context.read<PlayersController>().updatePlayerColor(
                  context.read<PlayersController>().players[index],
                  color,
                );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return ListView.builder(
      itemCount: context.watch<PlayersController>().players.length,
      itemBuilder: (_, index) {
        final player = context.watch<PlayersController>().players[index];
        final isLast = index == context.read<PlayersController>().players.length - 1;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.inline.xs,
            vertical: theme.spacing.inline.xxs,
          ),
          child: DSTextField(
            hintText: 'Digite seu nome',
            onChanged: (text) => _onTextChanged(text, index),
            leading: isLast
                ? null
                : GestureDetector(
                    onTap: () => _selectColor(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.inline.xxs,
                      ),
                      child: Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                          color: player.color ?? theme.colors.secondary,
                          borderRadius: BorderRadius.circular(
                            theme.borders.radius.medium,
                          ),
                        ),
                      ),
                    ),
                  ),
            trailing: isLast
                ? null
                : GestureDetector(
                    onTap: () => _removePlayer(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.inline.xxs,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        color: theme.colors.white,
                        size: 32,
                      ),
                    ),
                  ),
          ),
        )
            .animate(
              delay: 300.ms,
            )
            .fade(
              duration: 300.ms,
              delay: 300.ms,
            )
            .slide(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            );
      },
    );
  }
}
