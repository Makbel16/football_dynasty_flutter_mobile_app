import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final game = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (user != null)
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(user.displayName ?? 'Manager'),
              subtitle: Text(user.email),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save Game'),
            subtitle: const Text('Save current progress locally'),
            onTap: () async {
              if (user != null) {
                await ref.read(gameProvider.notifier).saveGame(user.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Game saved!')),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Cloud Save'),
            subtitle: const Text('Sync save to Firebase'),
            onTap: () async {
              if (user != null) {
                await ref.read(gameProvider.notifier).saveGame(user.id, cloud: true);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cloud save complete!')),
                  );
                }
              }
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.autorenew),
            title: const Text('Auto Save'),
            subtitle: const Text('Automatically save after each week'),
            value: true,
            onChanged: (_) {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Game Info'),
            subtitle: Text(
              game.isInitialized
                  ? 'Season ${game.season} • Week ${game.week} • ${game.yearsManaged} years managed'
                  : 'No active game',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.dangerRed),
            title: const Text('Sign Out', style: TextStyle(color: AppTheme.dangerRed)),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go(AppRouter.login);
            },
          ),
        ],
      ),
    );
  }
}
