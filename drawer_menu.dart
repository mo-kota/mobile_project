import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import 'favorites_page.dart';
import 'payment_page.dart';
import 'cart_checkout_page.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool dark = false;
  final _auth = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
              },
              child: Row(children: [
                const CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.divider,
                    child: Icon(Icons.person, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                Expanded(
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: user != null ? _auth.getUserData(user!.uid) : Future.value(null),
                    builder: (context, snapshot) {
                      final name = snapshot.data?['name'] ?? user?.displayName ?? 'Guest User';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const Text('Verified Profile',
                              style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      );
                    },
                  ),
                ),
                const Chip(label: Text('3 Orders')),
              ]),
            ),
            const SizedBox(height: 16),
            _toggleRow('Dark Mode', dark, (v) => setState(() => dark = v)),
            _item(Icons.info_outline, 'Account Information', () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
            }),
            _item(Icons.lock_outline, 'Password', () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
            }),
            _item(
                Icons.shopping_bag_outlined,
                'Order',
                () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const CartCheckoutPage()))),
            _item(
                Icons.credit_card,
                'My Cards',
                () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const PaymentPage()))),
            _item(
                Icons.favorite_border,
                'Wishlist',
                () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const FavoritesPage()))),
            _item(Icons.settings_outlined, 'Settings', () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const SettingsPage()));
            }),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.red),
              title: const Text('Logout', style: TextStyle(color: AppColors.red)),
              onTap: () async {
                Navigator.pop(context);
                await _auth.logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String label, VoidCallback onTap) =>
      ListTile(leading: Icon(icon), title: Text(label), onTap: onTap);
  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(children: [
      const Icon(Icons.wb_sunny_outlined),
      const SizedBox(width: 12),
      Expanded(child: Text(label)),
      Switch(value: value, onChanged: onChanged),
    ]);
  }
}
