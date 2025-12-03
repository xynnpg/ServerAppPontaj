import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pontaj_admin/l10n/app_localizations.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/error_overlay.dart';
import 'providers/language_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LanguageProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Pontaj Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: languageProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ro'), // Romanian
        Locale('en'), // English
        Locale('fr'), // French
        Locale('de'), // German
        Locale('es'), // Spanish
        Locale('it'), // Italian
      ],
      builder: (context, child) {
        return ErrorOverlay(child: child!);
      },
      home: const LoginScreen(),
    );
  }
}
