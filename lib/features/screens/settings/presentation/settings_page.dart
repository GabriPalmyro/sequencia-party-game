import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/components/text/text_widget.dart';
import 'package:sequencia/features/purchases/purchase_service.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';
import 'package:sequencia/router/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsTitle),
      ),
      body: Consumer<PurchaseService>(
        builder: (context, purchaseService, child) {
          return ListView(
            children: [
              ListTile(
                title: const DSText('Custom Themes'),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.customThemes);
                },
              ),
              if (!purchaseService.isPremium)
                ListTile(
                  title: const DSText('Go Premium'),
                  onTap: () {
                    purchaseService.presentPaywall();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
