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
  late ScrollController _scrollController;

  final List<TextEditingController> _controllers = [];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (context.read<PlayersController>().players.isNotEmpty) {
      for (final player in context.read<PlayersController>().players) {
        _addNewController(player.name);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayersController>().addPlayer(
            PlayerEntity(
              name: '',
              color: context.read<PlayersController>().getRandomAvailableColor(),
            ),
          );
      _addNewController();
      setState(() {});
    });
  }

  void _addNewController([String? initialText]) {
    final newController = TextEditingController(text: initialText);
    newController.addListener(
      () {
        final index = _controllers.indexOf(newController);
        _onTextChanged(newController.text, index);
      },
    );
    _controllers.add(newController);
  }

  void _removeController(int index) {
    _controllers.removeAt(index);
  }

  void _onTextChanged(String text, int index) {
    final lowercaseText = text.toLowerCase();
    context.read<PlayersController>().updatePlayer(
          context.read<PlayersController>().players[index],
          newName: lowercaseText,
        );

    final playersLength = context.read<PlayersController>().players.length;

    if (lowercaseText.isNotEmpty && index == playersLength - 1 && playersLength < 8) {
      context.read<PlayersController>().addPlayer(
            PlayerEntity(
              name: '',
              color: context.read<PlayersController>().getRandomAvailableColor(),
            ),
          );
      _addNewController();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: 150.ms,
        curve: Curves.easeOut,
      );
    }
  }

  void _removePlayer(int index) {
    if (context.read<PlayersController>().players.length > 1) {
      context.read<PlayersController>().removePlayer(context.read<PlayersController>().players[index]);
      _removeController(index);
      setState(() {});
    }
  }

  void _selectColor(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SelectPlayerColorModal(
          availableColors: context.read<PlayersController>().getAvailableColors(),
          onColorSelected: (color) {
            context.read<PlayersController>().updatePlayer(
                  context.read<PlayersController>().players[index],
                  newColor: color,
                );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      interactive: true,
      thumbColor: theme.colors.primary,
      thickness: 4.0,
      radius: Radius.circular(theme.borders.radius.medium),
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: context.watch<PlayersController>().players.length,
        itemBuilder: (_, index) {
          final player = context.watch<PlayersController>().players[index];
          final isLast = index == context.read<PlayersController>().players.length - 1;
          final showDeleteAndColorChange = isLast && context.read<PlayersController>().players.length < 8;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.inline.xs,
              vertical: theme.spacing.inline.xxs,
            ).copyWith(
              bottom: isLast ? theme.spacing.inline.sm : theme.spacing.inline.xxs,
            ),
            child: DSTextField(
              hintText: 'digite seu nome',
              controller: _controllers[index],
              leading: showDeleteAndColorChange
                  ? null
                  : GestureDetector(
                      onTap: () => _selectColor(index),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: theme.spacing.inline.xxs,
                          vertical: theme.spacing.inline.xxxs,
                        ),
                        child: Container(
                          width: 40,
                          height: 30,
                          decoration: BoxDecoration(
                            color: player.color ?? theme.colors.secondary,
                            borderRadius: BorderRadius.circular(
                              theme.borders.radius.medium,
                            ),
                          ),
                        ),
                      ),
                    ),
              trailing: showDeleteAndColorChange
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
      ),
    );
  }
}
