import 'package:flutter/material.dart';
import '../../../app/theme/app_spacing.dart';

/// Screen for app settings and user profile.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        children: [
          const SizedBox(height: AppSpacing.s24),
          _buildProfileSection(context),
          const SizedBox(height: AppSpacing.s32),
          _buildSocialSection(context),
          const SizedBox(height: AppSpacing.s32),
          _buildAppInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 50,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          'Joshua de Guzman',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Habit Tracker Enthusiast',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social Links',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _SocialLinkTile(
                icon: Icons.camera_alt_outlined,
                label: 'Instagram',
                onTap: () {
                  // TODO: Implement navigation to Instagram
                },
              ),
              const Divider(height: 1, indent: AppSpacing.s16),
              _SocialLinkTile(
                icon: Icons.alternate_email_outlined,
                label: 'Threads',
                onTap: () {
                  // TODO: Implement navigation to Threads
                },
              ),
              const Divider(height: 1, indent: AppSpacing.s16),
              _SocialLinkTile(
                icon: Icons.link_outlined,
                label: 'Twitter (X)',
                onTap: () {
                  // TODO: Implement navigation to Twitter
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App Info',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Version'),
                trailing: Text('0.1.0'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SocialLinkTile extends StatelessWidget {
  const _SocialLinkTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
