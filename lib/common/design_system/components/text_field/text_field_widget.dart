import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class DSTextField extends StatefulWidget {
  const DSTextField({
     this.controller,
    Key? key,
    this.leading,
    this.trailing,
    this.hintText = '',
    this.onChanged,
    this.onTapOutside,
     this.focusNode,
    this.isEnabled = true,
  }) : super(key: key);

  final TextEditingController? controller;
  final Widget? leading;
  final Widget? trailing;
  final String hintText;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;
  final FocusNode? focusNode;
  final bool isEnabled;

  @override
  State<DSTextField> createState() => _DSTextFieldState();
}

class _DSTextFieldState extends State<DSTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borders.radius.medium),
        color: theme.colors.tertiary,
        boxShadow: [
          BoxShadow(
            color: theme.colors.tertiary.withOpacity(0.55),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(-2, 5),
          ),
        ],
      ),
      child: TextField(
        enabled: widget.isEnabled,
        controller: widget.controller,
        textAlign: TextAlign.center, // Centralize the input text
        style: TextStyle(
          color: theme.colors.white,
          fontSize: theme.font.size.xxs,
          fontWeight: theme.font.weight.semiBold,
          fontFamily: theme.font.family.base,
        ),
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onTapOutside: widget.onTapOutside,
        cursorColor: theme.colors.primary, // Set cursor color to white
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: theme.colors.white.withOpacity(0.7)), // Set hint text color to white
          prefixIcon: widget.leading,
          suffixIcon: widget.trailing,
          labelStyle: TextStyle(
            color: theme.colors.white,
            fontSize: theme.font.size.sm,
            fontWeight: theme.font.weight.regular,
            fontFamily: theme.font.family.base,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.borders.radius.medium),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colors.tertiary,
        ),
      ),
    );
  }
}
