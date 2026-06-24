import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/player_card.dart';
import '../../../widgets/section_header.dart';

class AcademyScreen extends ConsumerWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final youth = game.userClubId != null
        ? game.youthForClub(game.userClubId!)
        : [];

    youth.sort((a, b) => b.potential.compareTo(a.potential));

    return Scaffold(
      appBar: AppBar(title: const Text('Youth Academy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.school, color: AppTheme.accentGold, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Youth Intake', style: Theme.of(context).textTheme.titleMedium),
                          Text(
                            '${youth.length} players in academy',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'New intake each season (ages 15-18)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SectionHeader(title: 'Top Prospects'),
            if (youth.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No youth players yet. A new intake arrives at the start of each season.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...youth.map((player) => PlayerCard(
                    player: player,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'POT ${player.potential}',
                          style: TextStyle(
                            color: player.potential >= 85
                                ? AppTheme.accentGold
                                : AppTheme.accentBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (player.potential >= 85)
                          const Text(
                            '⭐ Star',
                            style: TextStyle(color: AppTheme.accentGold, fontSize: 11),
                          ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
