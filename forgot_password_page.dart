import 'package:flutter/material.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import '../services/auth_service.dart';
import 'verfication_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController(text: 'bill.sanders@example.com');
  final _auth = AuthService();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: _back(), title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.lock_reset_outlined, size: 150, color: AppColors.purple),
            const SizedBox(height: 24),
            _field('Email Address', _email),
            const Spacer(),
            const Text(
              'Please write your email to receive a confirmation link to set a new password.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        label: loading ? 'Sending...' : 'Confirm Mail',
        onPressed: loading ? null : () async {
          if (_email.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter your email')),
            );
            return;
          }
          setState(() => loading = true);
          try {
            await _auth.resetPassword(_email.text.trim());
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset email sent! Check your inbox.')),
            );

            // Passing a dummy verificationId to fix the constructor error, 
            // though Firebase email reset typically uses a link in the email.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VerificationCodePage(verificationId: 'email_reset')),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          } finally {
            if (mounted) setState(() => loading = false);
          }
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      TextField(
        controller: ctrl,
        keyboardType: TextInputType.emailAddress,
      ),
    ]);
  }

  Widget _back() => Container(
        margin: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF4F5F7),
          shape: BoxShape.circle,
        ),
        child: const BackButton(),
      );
}
