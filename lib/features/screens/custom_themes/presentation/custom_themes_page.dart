import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/features/controller/game_controller.dart';
import 'package:sequencia/features/purchases/purchase_service.dart';

class CustomThemesPage extends StatefulWidget {
  const CustomThemesPage({super.key});

  @override
  State<CustomThemesPage> createState() => _CustomThemesPageState();
}

class _CustomThemesPageState extends State<CustomThemesPage> {
  final TextEditingController _themeController = TextEditingController();

  void _showAddThemeDialog() {
    final purchaseService = context.read<PurchaseService>();
    final gameController = context.read<GameController>();

    if (purchaseService.isPremium) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Custom Theme'),
            content: TextField(
              controller: _themeController,
              decoration: const InputDecoration(hintText: 'Enter your theme'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  gameController.addCustomTheme(_themeController.text);
                  _themeController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    } else {
      purchaseService.presentPaywall();
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final customThemes = gameController.customThemes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Themes'),
      ),
      body: customThemes.isEmpty
          ? const Center(
              child: Text('No custom themes yet. Add one!'),
            )
          : ListView.builder(
              itemCount: customThemes.length,
              itemBuilder: (context, index) {
                final theme = customThemes[index];
                return ListTile(
                  title: Text(theme),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => gameController.deleteCustomTheme(theme),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddThemeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}