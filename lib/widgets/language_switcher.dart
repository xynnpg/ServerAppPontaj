import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import 'package:pontaj_admin/l10n/app_localizations.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language, color: Colors.white),
      tooltip: l10n?.selectLanguage ?? 'Select Language',
      onSelected: (Locale locale) {
        languageProvider.changeLanguage(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        const PopupMenuItem<Locale>(
          value: Locale('ro'),
          child: Row(children: [Text('🇷🇴 '), Text('Română')]),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Row(children: [Text('🇺🇸 '), Text('English')]),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('fr'),
          child: Row(children: [Text('🇫🇷 '), Text('Français')]),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('de'),
          child: Row(children: [Text('🇩🇪 '), Text('Deutsch')]),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('es'),
          child: Row(children: [Text('🇪🇸 '), Text('Español')]),
        ),
        const PopupMenuItem<Locale>(
          value: Locale('it'),
          child: Row(children: [Text('🇮🇹 '), Text('Italiano')]),
        ),
      ],
    );
  }
}
