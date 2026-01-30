import 'package:finance_app/core/widgets/feature_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureScaffold(
      title: 'Settings',
      child: ListView(
        children: [
          ListTile(
            title: const Text('App Settings'),
            subtitle: const Text('Configure app behavior'),
            onTap: () {
              // TODO: Navigate to app settings
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Manage notifications'),
            onTap: () {
              // TODO: Navigate to notification settings
            },
          ),
          ListTile(
            title: const Text('Privacy & Security'),
            subtitle: const Text('Security settings'),
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('About this app'),
            onTap: () {
              // TODO: Navigate to about page
            },
          ),
        ],
      ),
    );
  }
}
