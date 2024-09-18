import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class DSButtonWidget extends StatefulWidget {
  const DSButtonWidget({
    required this.label,
    required this.onPressed,
    this.size = const Size(200, 50),
    super.key,
  });
  final String label;
  final void Function() onPressed;
  final Size size;

  @override
  _DSButtonWidgetState createState() => _DSButtonWidgetState();
}

class _DSButtonWidgetState extends State<DSButtonWidget> {
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
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        width: widget.size.width,
        height: widget.size.height,
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          boxShadow: [
            BoxShadow(
              color: theme.colors.primary.withOpacity(0.55),
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
          child: Text(
            widget.label,
            style: TextStyle(
              color: theme.colors.white,
              fontSize: theme.font.size.sm,
              fontWeight: theme.font.weight.medium,
              fontFamily: theme.font.family.base,
            ),
          ),
        ),
      ),
    );
  }
}
