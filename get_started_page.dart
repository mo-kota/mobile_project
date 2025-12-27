import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import 'signup_page.dart';
import 'login_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _back(),
        title: const Text("Let's Get Started", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            _social('Facebook', const Color(0xFF3B5998), Icons.facebook),
            const SizedBox(height: 12),
            _social('Twitter', const Color(0xFF1DA1F2), Icons.alternate_email),
            const SizedBox(height: 12),
            _social('Google', const Color(0xFFDB4437), Icons.g_mobiledata),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                  child: const Text('Signin', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        label: 'Create an Account',
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())),
      ),
    );
  }

  Widget _social(String label, Color color, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {},
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon), const SizedBox(width: 8), Text(label)]),
      ),
    );
  }

  Widget _back() => Container(
    margin: const EdgeInsets.only(left: 12),
    decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
    child: const BackButton(),
  );
}