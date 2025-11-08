import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sequencia/common/design_system/core/theme/ds_theme.dart';
import 'package:sequencia/features/controller/locale_controller.dart';
import 'package:sequencia/helpers/extension/context_extension.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  static const List<_LanguageOption> _options = [
    _LanguageOption(flag: '🇧🇷', label: 'PT-BR', locale: Locale('pt', 'BR')),
    _LanguageOption(flag: '🇵🇹', label: 'PT', locale: Locale('pt')),
    _LanguageOption(flag: '🇺🇸', label: 'EN', locale: Locale('en')),
    _LanguageOption(flag: '🇪🇸', label: 'ES', locale: Locale('es')),
    _LanguageOption(flag: '🇫🇷', label: 'FR', locale: Locale('fr')),
    _LanguageOption(flag: '🇮🇹', label: 'IT', locale: Locale('it')),
    _LanguageOption(flag: '🇯🇵', label: 'JA', locale: Locale('ja')),
    _LanguageOption(flag: '🇳🇱', label: 'NL', locale: Locale('nl')),
    _LanguageOption(flag: '🇷🇺', label: 'RU', locale: Locale('ru')),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = DSTheme.getDesignTokensOf(context);
    final localeController = context.watch<LocaleController>();
    final selectedOption = _options.firstWhere(
      (option) => option.locale == localeController.locale,
      orElse: () => _options.first,
    );

    return Tooltip(
      message: context.l10n.languageSelectorTooltip,
      child: PopupMenuButton<_LanguageOption>(
        initialValue: selectedOption,
        onSelected: (option) =>
            context.read<LocaleController>().setLocale(option.locale),
        color: theme.colors.background,
        itemBuilder: (context) => _options
            .map(
              (option) => PopupMenuItem<_LanguageOption>(
                value: option,
                child: Row(
                  children: [
                    Text(
                      option.flag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: theme.spacing.inline.xs),
                    Text(
                      option.label,
                      style: TextStyle(
                        color: theme.colors.white,
                        fontWeight: theme.font.weight.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.inline.xxxs,
            vertical: theme.spacing.inline.xxs,
          ),
          decoration: BoxDecoration(
            color: theme.colors.secondary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(theme.borders.radius.small),
            boxShadow: [
              BoxShadow(
                color: theme.colors.secondary.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedOption.flag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.expand_more,
                size: 18,
                color: theme.colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.locale,
  });

  final String flag;
  final String label;
  final Locale locale;
}
