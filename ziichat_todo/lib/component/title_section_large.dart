import 'package:flutter/material.dart';

class TitleSectionLarge extends StatelessWidget {
  const TitleSectionLarge({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}
