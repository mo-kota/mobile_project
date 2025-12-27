import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../ui/widgets.dart';
import '../services/auth_service.dart';
import 'home_catalog_page.dart';
import 'forgot_password_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();
  final _emailController = TextEditingController(text: 'bill.sanders@example.com');
  final _passwordController = TextEditingController(text: 'HJ@#9783kja');
  bool remember = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _back(),
        title: const Text('Welcome'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(24),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Please enter your data to continue',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _field('Email Address', _emailController),
            const SizedBox(height: 8),
            _field('Password', _passwordController, obscure: true, suffix: const Text('Strong', style: TextStyle(color: AppColors.green))),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
                child: const Text('Forgot password?', style: TextStyle(color: AppColors.red)),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('Remember me')),
                Switch(
                    value: remember,
                    onChanged: (v) => setState(() => remember = v),
                    activeColor: AppColors.green),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Don\'t have an account? '),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const SignupPage())),
                  child: const Text('Sign Up',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.purple)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('By connecting your account confirm that you agree with our Term and Condition',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      bottomNavigationBar: PrimaryButton(
        label: loading ? 'Please wait...' : 'Login',
        onPressed: loading
            ? null
            : () async {
                setState(() => loading = true);
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                try {
                  await _auth.login(email, password);
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (_) => const HomeCatalogPage()), (_) => false);
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;
                  String message = e.message ?? 'An error occurred';
                  if (e.code == 'too-many-requests') {
                    message = "Too many attempts. Try again later.";
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                } finally {
                  if (mounted) setState(() => loading = false);
                }
              },
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {bool obscure = false, Widget? suffix}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      const SizedBox(height: 6),
      TextField(controller: ctrl, obscureText: obscure, decoration: InputDecoration(suffixIcon: suffix)),
    ]);
  }

  Widget _back() => Container(
      margin: const EdgeInsets.only(left: 12),
      decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
      child: const BackButton());
}
