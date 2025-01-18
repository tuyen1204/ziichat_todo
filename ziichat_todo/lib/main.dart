import 'package:flutter/material.dart';
import 'package:ziichat_todo/screens/onboarding/onboarding_scrreen.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZiiChat TodoList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
          fontFamily: 'FilsonPro'),
      home: const OnboardingScreen(),
    );
  }
}
