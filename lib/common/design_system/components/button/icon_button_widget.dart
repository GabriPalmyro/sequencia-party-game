import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class DSIconButtonWidget extends StatefulWidget {
  const DSIconButtonWidget({
    required this.label,
    required this.onPressed,
    this.size = const Size(100, 50),
    this.isEnabled = true,
    super.key,
  });
  final IconData label;
  final void Function() onPressed;
  final Size size;
  final bool isEnabled;
  @override
  _DSIconButtonWidgetState createState() => _DSIconButtonWidgetState();
}

class _DSIconButtonWidgetState extends State<DSIconButtonWidget> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      child: AnimatedContainer(
        width: widget.size.width,
        height: widget.size.height,
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: widget.isEnabled ? theme.colors.tertiary : theme.colors.grey,
          boxShadow: [
            BoxShadow(
              color: widget.isEnabled ? theme.colors.tertiary.withOpacity(0.55) : theme.colors.grey.withOpacity(0.55),
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(0, _isPressed ? 0 : 5),
            ),
          ],
          borderRadius: BorderRadius.circular(theme.borders.radius.medium),
        ),
        padding: EdgeInsets.symmetric(
          vertical: theme.spacing.inline.xxs,
          horizontal: theme.spacing.inline.xxs,
        ),
        child: Center(
          child: Icon(
            widget.label,
            color: theme.colors.white,
          ),
        ),
      ),
    );
  }
}
