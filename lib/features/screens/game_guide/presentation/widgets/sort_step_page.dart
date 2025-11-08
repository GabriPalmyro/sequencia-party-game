import 'package:flutter/material.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/core/app_images.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';

class SortStepPage extends StatelessWidget {
  const SortStepPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.inline.xs,
      ),
      child: Column(
        children: [
          SizedBox(height: theme.spacing.inline.lg),
          DSText(
            context.l10n.guideSortStepDescription,
            textAlign: TextAlign.center,
            customStyle: TextStyle(
              fontSize: theme.font.size.xxs,
              fontWeight: theme.font.weight.light,
            ),
          ),
          SizedBox(height: theme.spacing.inline.xs),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AppImages.sortThemePage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.inline.sm),
        ],
      ),
    );
  }
}
