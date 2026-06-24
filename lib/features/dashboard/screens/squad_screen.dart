import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/enums/game_enums.dart';
import '../../../widgets/player_card.dart';
import '../../../widgets/section_header.dart';
import '../../players/screens/player_detail_screen.dart';

class SquadScreen extends ConsumerStatefulWidget {
  const SquadScreen({super.key});

  @override
  ConsumerState<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends ConsumerState<SquadScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final clubId = game.userClubId;
    if (clubId == null) return const Center(child: Text('No squad'));

    var players = game.playersForClub(clubId);
    if (_filter != 'All') {
      players = players.where((p) => p.position.code == _filter).toList();
    }
    players.sort((a, b) => b.overall.compareTo(a.overall));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Squad'),
        actions: [
          PopupMenuButton<TrainingType>(
            icon: const Icon(Icons.fitness_center),
            tooltip: 'Training',
            onSelected: (type) {
              ref.read(gameProvider.notifier).applyTraining(type, 70);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${type.name} training applied!')),
              );
            },
            itemBuilder: (context) => TrainingType.values
                .map((t) => PopupMenuItem(value: t, child: Text(_trainingLabel(t))))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                'All', 'GK', 'CB', 'LB', 'RB', 'CM', 'CDM', 'CAM', 'LW', 'RW', 'ST'
              ].map((pos) {
                final selected = _filter == pos;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(pos),
                    selected: selected,
                    onSelected: (_) => setState(() => _filter = pos),
                    selectedColor: AppTheme.accentGold.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return PlayerCard(
                  player: player,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerDetailScreen(player: player),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _trainingLabel(TrainingType type) => switch (type) {
        TrainingType.attacking => 'Attacking Training',
        TrainingType.defensive => 'Defensive Training',
        TrainingType.physical => 'Physical Training',
        TrainingType.tactical => 'Tactical Training',
      };
}
