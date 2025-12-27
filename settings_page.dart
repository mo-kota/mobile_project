import 'package:flutter/material.dart';
import '../theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool promotionalEmails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: _back(context),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Push Notifications'),
            value: notifications,
            onChanged: (v) => setState(() => notifications = v),
            activeColor: AppColors.purple,
          ),
          SwitchListTile(
            title: const Text('Promotional Emails'),
            value: promotionalEmails,
            onChanged: (v) => setState(() => promotionalEmails = v),
            activeColor: AppColors.purple,
          ),
          const Divider(),
          const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
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
