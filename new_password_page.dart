import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import '../services/auth_service.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});
  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _pwd = TextEditingController(text: 'HJ@#9783kja');
  final _confirm = TextEditingController(text: 'HJ@#9783kja');
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('New Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field('Password', _pwd, obscure: true),
            const SizedBox(height: 12),
            _field('Confirm Password', _confirm, obscure: true),
            const Spacer(),
            const Text('Please write your new password.', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        label: 'Reset Password',
        onPressed: () async {
          // In real flow, verify code and update password via Firebase
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset')));
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {bool obscure = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      TextField(controller: ctrl, obscureText: obscure),
    ]);
  }

  Widget _back() => Container(margin: const EdgeInsets.only(left: 12), decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle), child: const BackButton());
}