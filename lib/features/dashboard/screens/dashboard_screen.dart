import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../services/league_engine_service.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/stat_card.dart';
import '../../matches/screens/match_detail_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final club = game.userClub;
    final standing = game.userStanding;
    final league = game.userLeague;

    if (club == null) {
      return const Center(child: Text('No club found'));
    }

    final position = league != null && standing != null
        ? LeagueEngineService.instance.getPosition(
            game.standings.where((s) => s.leagueId == league.id).toList(),
            club.id,
          )
        : 0;

    final recent = game.recentMatches();
    final upcoming = game.upcomingMatches();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(club.name),
            Text(
              'Season ${game.season} • Week ${game.week}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () async {
              final user = ref.read(currentUserProvider);
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
          IconButton(
            icon: const Icon(Icons.skip_next),
            tooltip: 'Advance Week',
            onPressed: () async {
              await ref.read(gameProvider.notifier).advanceWeek();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club header
              Card(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        club.primaryColor.withValues(alpha: 0.3),
                        AppTheme.cardBackground,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: club.primaryColor,
                        child: Icon(Icons.shield, color: club.secondaryColor, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(club.name, style: Theme.of(context).textTheme.titleLarge),
                            Text('${club.league} • ${club.country}'),
                            Text(club.stadiumName, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallPhone = constraints.maxWidth < 360;
                  return GridView.count(
                    crossAxisCount: isSmallPhone ? 1 : 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: isSmallPhone ? 2.4 : 1.6,
                    children: [
                      StatCard(
                        title: 'League Position',
                        value: position > 0 ? '$position${_ordinal(position)}' : '-',
                        icon: Icons.leaderboard,
                        color: position <= 4 ? AppTheme.successGreen : null,
                      ),
                      StatCard(
                        title: 'Club Value',
                        value: Formatters.currency(club.clubValue),
                        icon: Icons.trending_up,
                      ),
                      StatCard(
                        title: 'Budget',
                        value: Formatters.currency(club.budget),
                        icon: Icons.account_balance_wallet,
                        color: AppTheme.accentGold,
                      ),
                      StatCard(
                        title: 'Points',
                        value: '${standing?.points ?? 0}',
                        icon: Icons.star,
                        subtitle: '${standing?.played ?? 0} played',
                      ),
                      StatCard(
                        title: 'Fan Happiness',
                        value: '${club.fanHappiness.toInt()}%',
                        icon: Icons.people,
                        color: club.fanHappiness > 70
                            ? AppTheme.successGreen
                            : AppTheme.dangerRed,
                      ),
                      StatCard(
                        title: 'Board Confidence',
                        value: '${club.boardConfidence.toInt()}%',
                        icon: Icons.business,
                        color: club.boardConfidence > 50
                            ? AppTheme.accentBlue
                            : AppTheme.dangerRed,
                      ),
                    ],
                  );
                },
              ),

              // Trophy cabinet
              if (game.trophies.isNotEmpty) ...[
                const SectionHeader(title: 'Trophy Cabinet'),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: game.trophies.length,
                    itemBuilder: (context, i) {
                      final trophy = game.trophies[i];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Chip(
                          avatar: const Icon(Icons.emoji_events, color: AppTheme.accentGold),
                          label: Text('${trophy.name} (${trophy.season})'),
                        ),
                      );
                    },
                  ),
                ),
              ],

              // Recent matches
              const SectionHeader(title: 'Recent Matches'),
              if (recent.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No matches played yet. Advance the week to play!'),
                  ),
                )
              else
                ...recent.map((match) {
                  final isHome = match.homeClubId == club.id;
                  final opponent = game.clubs.firstWhere(
                    (c) => c.id == (isHome ? match.awayClubId : match.homeClubId),
                  );
                  final goalsFor = isHome ? match.homeGoals : match.awayGoals;
                  final goalsAgainst = isHome ? match.awayGoals : match.homeGoals;
                  final result = goalsFor > goalsAgainst
                      ? 'W'
                      : goalsFor < goalsAgainst
                          ? 'L'
                          : 'D';

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: result == 'W'
                            ? AppTheme.successGreen
                            : result == 'L'
                                ? AppTheme.dangerRed
                                : AppTheme.textSecondary,
                        child: Text(result, style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text('${isHome ? '' : '@ '}${opponent.name}'),
                      subtitle: Text('Week ${match.week} • $goalsFor - $goalsAgainst'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MatchDetailScreen(match: match),
                        ),
                      ),
                    ),
                  );
                }),

              // Upcoming matches
              const SectionHeader(title: 'Upcoming Fixtures'),
              if (upcoming.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Season complete or no fixtures remaining.'),
                  ),
                )
              else
                ...upcoming.map((match) {
                  final isHome = match.homeClubId == club.id;
                  final opponent = game.clubs.firstWhere(
                    (c) => c.id == (isHome ? match.awayClubId : match.homeClubId),
                  );
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        isHome ? Icons.home : Icons.flight_takeoff,
                        color: AppTheme.accentGold,
                      ),
                      title: Text(opponent.name),
                      subtitle: Text('Week ${match.week} • ${isHome ? 'Home' : 'Away'}'),
                    ),
                  );
                }),

              // Board objectives
              if (game.objectives.isNotEmpty) ...[
                const SectionHeader(title: 'Board Objectives'),
                ...game.objectives.map((obj) => Card(
                      child: ListTile(
                        title: Text(obj.description),
                        subtitle: LinearProgressIndicator(
                          value: obj.progress,
                          backgroundColor: AppTheme.darkBackground,
                          color: AppTheme.accentGold,
                        ),
                        trailing: Text('${(obj.progress * 100).toInt()}%'),
                      ),
                    )),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  String _ordinal(int n) {
    if (n >= 11 && n <= 13) return 'th';
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
