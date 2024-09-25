import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';

class PlayerColorCard extends StatelessWidget {
  const PlayerColorCard({
    required this.color,
    required this.name,
    this.size = const Size(130, 200),
    super.key,
  });
  final Color color;
  final String name;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          theme.borders.radius.medium,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colors.grey.withOpacity(0.2),
            blurRadius: 0,
            offset: const Offset(4, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: theme.spacing.inline.xxs,
              bottom: theme.spacing.inline.xxxs,
            ),
            child: DSText(
              name,
              customStyle: TextStyle(
                fontSize: theme.font.size.xxxs,
                fontWeight: theme.font.weight.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
