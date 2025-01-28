import 'package:flutter/material.dart';
import 'package:ziichat_todo/component/dot_indicators.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/screens/home/home_screen.dart';
import 'components/onboard_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onLanguageChanged});
  final Function(Locale) onLanguageChanged;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: onboardingData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  image: onboardingData[index]["image"],
                  title: onboardingData[index]["title"],
                  text: onboardingData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        onLanguageChanged: widget.onLanguageChanged,
                      ),
                    ),
                  );
                },
                child: Text("Get Started".toUpperCase()),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> onboardingData = [
  {
    "image": "assets/images/onboarding-01.png",
    "title": "Manage Folders Efficiently",
    "text":
        "Create, edit, and organize folders to group your tasks effectively. Always have a default folder ready for uncategorized tasks.",
  },
  {
    "image": "assets/images/onboarding-02.png",
    "title": "Track Your Tasks",
    "text":
        "Add, edit, and track tasks with timestamps and notes. Easily update their status or move them to different folders.",
  },
  {
    "image": "assets/images/onboarding-03.png",
    "title": "Advanced Features",
    "text":
        "Sort tasks, paginate for better focus, and export/import your data. Fully responsive, works on desktop too!",
  },
];
