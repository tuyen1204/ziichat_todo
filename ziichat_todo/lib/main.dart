import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ziichat_todo/i18n/app_localizations_delegate.dart';
import 'package:ziichat_todo/screens/onboarding/onboarding_scrreen.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('vi');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZiiChat TodoList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
          fontFamily: 'Barlow'),
      home: OnboardingScreen(
        onLanguageChanged: _changeLanguage,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        const AppLocalizationsDelegate(),
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      locale: _locale,
    );
  }
}
