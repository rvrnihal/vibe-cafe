import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkModeEnabled,
            onChanged: (value) => setState(() => _darkModeEnabled = value),
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            textColor: Colors.red,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
