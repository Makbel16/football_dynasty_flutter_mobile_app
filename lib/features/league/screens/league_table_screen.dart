import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/league_engine_service.dart';

class LeagueTableScreen extends ConsumerWidget {
  const LeagueTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final league = game.userLeague;
    final userClubId = game.userClubId;

    if (league == null) {
      return const Scaffold(body: Center(child: Text('No league data')));
    }

    final standings = game.standings
        .where((s) => s.leagueId == league.id && s.season == game.season)
        .toList();
    final sorted = LeagueEngineService.instance.sortedStandings(standings);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(league.name),
            Text(
              'Season ${game.season}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.cardBackground,
            child: const Row(
              children: [
                SizedBox(width: 32, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 3, child: Text('Club', style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('W', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('D', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('L', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('GD', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(child: Text('Pts', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final standing = sorted[index];
                final club = game.clubs.firstWhere((c) => c.id == standing.clubId);
                final isUser = standing.clubId == userClubId;
                final isPromotion = index < 3;
                final isRelegation = index >= sorted.length - 3;

                Color? rowColor;
                if (isPromotion) rowColor = AppTheme.successGreen.withValues(alpha: 0.1);
                if (isRelegation) rowColor = AppTheme.dangerRed.withValues(alpha: 0.1);
                if (isUser) rowColor = AppTheme.accentGold.withValues(alpha: 0.15);

                return Container(
                  color: rowColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                            color: isUser ? AppTheme.accentGold : null,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          club.name,
                          style: TextStyle(
                            fontWeight: isUser ? FontWeight.bold : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(child: Text('${standing.played}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${standing.won}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${standing.drawn}', textAlign: TextAlign.center)),
                      Expanded(child: Text('${standing.lost}', textAlign: TextAlign.center)),
                      Expanded(
                        child: Text(
                          '${standing.goalDifference > 0 ? '+' : ''}${standing.goalDifference}',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${standing.points}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _Legend(color: AppTheme.successGreen, label: 'Promotion'),
                const SizedBox(width: 16),
                _Legend(color: AppTheme.dangerRed, label: 'Relegation'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
