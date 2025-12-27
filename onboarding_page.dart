import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import 'get_started_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFBBA5FF), AppColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Replaced Image.asset with an Icon
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 80),
              child: Icon(
                Icons.shopping_bag,
                size: 300,
                color: Colors.white,
              ),
            ),
          ),
          // Bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Look Good, Feel Good',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your individual & unique style and look amazing everyday.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      PillButton(label: 'Men', onPressed: () {}),
                      const SizedBox(width: 12),
                      const PillButton(label: 'Women', primary: true),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => const GetStartedPage())),
                    child: const Text('Skip',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
