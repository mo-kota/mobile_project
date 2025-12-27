import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: _back(context),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: user != null ? authService.getUserData(user.uid) : Future.value(null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;
          final name = userData?['name'] ?? user?.displayName ?? 'No Name';
          final email = userData?['email'] ?? user?.email ?? 'No Email';

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.divider,
                  child: Icon(Icons.person, size: 50, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                _infoTile('Full Name', name),
                _infoTile('Email', email),
                const Spacer(),
                const Text(
                  'Account verified since 2023',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _back(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 12),
        decoration: const BoxDecoration(color: Color(0xFFF4F5F7), shape: BoxShape.circle),
        child: const BackButton(),
      );
}
