import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  Future<void> load() async {
    String jsonString = await rootBundle
        .loadString('languages/app_${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) => _localizedStrings[key] ?? key;

  static AppLocalizations? of(context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}
