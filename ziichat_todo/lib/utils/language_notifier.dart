import 'package:flutter/material.dart';
import 'package:ziichat_todo/i18n/app_localizations.dart';

class LanguageNotifier extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void changeLanguage(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
