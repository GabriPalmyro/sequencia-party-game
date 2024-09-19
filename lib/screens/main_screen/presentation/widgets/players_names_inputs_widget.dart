import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sequencia/common/design_system/components/text_field/text_field_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class PlayersNamesInputsWidget extends StatefulWidget {
  const PlayersNamesInputsWidget({super.key});

  @override
  State<PlayersNamesInputsWidget> createState() => _PlayersNamesInputsWidgetState();
}

class _PlayersNamesInputsWidgetState extends State<PlayersNamesInputsWidget> {
  // Lista que armazena os controladores dos TextFields
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Inicialmente adiciona um TextField
    _adicionarCampo();
  }

  @override
  void dispose() {
    // Limpa os controladores ao finalizar o widget
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _adicionarCampo() {
    if (_controllers.length >= 7) {
      return;
    }

    final controller = TextEditingController();
    controller.addListener(() {
      _onTextChanged(controller);
    });
    setState(() {
      _controllers.add(controller);
    });
  }

  void _removerCampo(TextEditingController controller) {
    setState(() {
      controller.dispose();
      _controllers.remove(controller);
    });
  }

  void _onTextChanged(TextEditingController controller) {
    final text = controller.text.toLowerCase(); // Convert text to lowercase
    final index = _controllers.indexOf(controller);
    final isLast = index == _controllers.length - 1;

    // Update the controller's text to the lowercase version
    if (controller.text != text) {
      controller.value = controller.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    if (text.isNotEmpty) {
      if (isLast) {
        // Se o usuário começou a digitar no último campo, adicionamos um novo campo vazio
        _adicionarCampo();
      }
    } else {
      if (!isLast && _controllers.length > 1) {
        // Se o usuário apagou todo o texto de um campo que não é o último, removemos esse campo
        _removerCampo(controller);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Column(
      children: List.generate(
        _controllers.length,
        (index) {
          final controller = _controllers[index];
          final isLast = index == _controllers.length - 1;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: theme.spacing.inline.xs,
              vertical: theme.spacing.inline.xxs,
            ),
            child: DSTextField(
              controller: controller,
              hintText: 'Digite seu nome',
              leading: isLast
                  ? null
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: theme.spacing.inline.xxs,
                      ),
                      child: Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                          color: theme.colors.secondary,
                          borderRadius: BorderRadius.circular(
                            theme.borders.radius.medium,
                          ),
                        ),
                      ),
                    ),
              trailing: isLast
                  ? null // Não exibimos o botão de deletar no último campo vazio
                  : GestureDetector(
                      onTap: () {
                        _removerCampo(controller);
                      },
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
          );
        },
      )
          .animate(
            interval: 400.ms,
            delay: 300.ms,
          )
          .fade(
            duration: 300.ms,
            delay: 300.ms,
          )
          .slide(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ),
    );
  }
}
