import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('ro');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguagePreference();
  }

  Future<void> _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('language_code');
    if (savedLanguageCode != null) {
      _currentLocale = Locale(savedLanguageCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (_currentLocale == newLocale) return;

    _currentLocale = newLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', newLocale.languageCode);
  }
}
