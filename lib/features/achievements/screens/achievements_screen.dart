import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(gameProvider).achievements;

    final unlocked = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$unlocked/${achievements.length}',
                style: const TextStyle(color: AppTheme.accentGold),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: achievement.isUnlocked
                    ? AppTheme.accentGold.withValues(alpha: 0.2)
                    : AppTheme.darkBackground,
                child: Icon(
                  achievement.isUnlocked
                      ? Icons.emoji_events
                      : Icons.lock_outline,
                  color: achievement.isUnlocked
                      ? AppTheme.accentGold
                      : AppTheme.textSecondary,
                ),
              ),
              title: Text(
                achievement.title,
                style: TextStyle(
                  color: achievement.isUnlocked
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                ),
              ),
              subtitle: Text(achievement.description),
              trailing: achievement.isUnlocked
                  ? const Icon(Icons.check_circle, color: AppTheme.successGreen)
                  : null,
            ),
          );
        },
      ),
    );
  }
}
