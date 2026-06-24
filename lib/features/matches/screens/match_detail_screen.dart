import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/enums/game_enums.dart';
import '../../../models/match_result.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key, required this.match});

  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Week ${match.week} Match')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            color: AppTheme.pitchGreen.withValues(alpha: 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${match.homeGoals}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '-',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  '${match.awayGoals}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: match.events.isEmpty
                ? const Center(child: Text('No events recorded'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: match.events.length,
                    itemBuilder: (context, index) {
                      final event = match.events[index];
                      return Card(
                        child: ListTile(
                          leading: _eventIcon(event.type),
                          title: Text(event.commentary),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _eventIcon(MatchEventType type) {
    return switch (type) {
      MatchEventType.goal => const Icon(Icons.sports_soccer, color: AppTheme.successGreen),
      MatchEventType.yellowCard => const Icon(Icons.square, color: Colors.yellow),
      MatchEventType.redCard => const Icon(Icons.square, color: AppTheme.dangerRed),
      MatchEventType.injury => const Icon(Icons.healing, color: AppTheme.dangerRed),
      _ => const Icon(Icons.info_outline),
    };
  }
}
