import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:alarp/core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'General'),
          _buildSettingsTile(
            context,
            icon: SolarIconsOutline.bell,
            title: 'Notifications',
            subtitle: 'Daily reminders',
            trailing: Switch(
              value: true, // TODO: Connect to state
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
          _buildSettingsTile(
            context,
            icon: SolarIconsOutline.moon,
            title: 'Dark Mode',
            subtitle: 'Adjust app appearance',
            trailing: Switch(
              value: false, // TODO: Connect to state
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Account'),
          _buildSettingsTile(
            context,
            icon: SolarIconsOutline.user,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Navigate to Edit Profile
            },
          ),
          _buildSettingsTile(
            context,
            icon: SolarIconsOutline.lockPassword,
            title: 'Change Password',
            onTap: () {
              // TODO: Navigate to Change Password
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Support'),
          _buildSettingsTile(
            context,
            icon: SolarIconsOutline.infoCircle,
            title: 'About',
            onTap: () {
              // TODO: Show About dialog
            },
          ),
          _buildSettingsTile(
            context,
            icon: SolarIconsOutline.chatLine,
            title: 'Send Feedback',
            onTap: () {
              // TODO: Open feedback form
            },
          ),
          const SizedBox(height: 48),
          Center(
            child: Text(
              'Version 1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                )
                : null,
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
