import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/player.dart';
import '../../../widgets/section_header.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(player.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: _ratingColor(player.overall),
                      child: Text(
                        '${player.overall}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(player.name, style: Theme.of(context).textTheme.headlineSmall),
                          Text('${player.position.label} • ${player.age} years old'),
                          Text(player.nationality),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _Badge(label: 'POT ${player.potential}'),
                              const SizedBox(width: 8),
                              _Badge(label: 'Form ${player.form.toInt()}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SectionHeader(title: 'Attributes'),
            _AttributeBar(label: 'Pace', value: player.pace),
            _AttributeBar(label: 'Shooting', value: player.shooting),
            _AttributeBar(label: 'Passing', value: player.passing),
            _AttributeBar(label: 'Dribbling', value: player.dribbling),
            _AttributeBar(label: 'Defending', value: player.defending),
            _AttributeBar(label: 'Physical', value: player.physical),
            const SectionHeader(title: 'Contract & Value'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InfoRow('Market Value', '€${(player.marketValue / 1000000).toStringAsFixed(2)}M'),
                    _InfoRow('Weekly Salary', '€${player.salary.toStringAsFixed(0)}'),
                    _InfoRow('Contract', '${player.contractYears} years'),
                    _InfoRow('Morale', '${player.morale.toInt()}%'),
                    _InfoRow('Fitness', '${player.fitness.toInt()}%'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _ratingColor(int rating) {
    if (rating >= 80) return AppTheme.successGreen;
    if (rating >= 70) return AppTheme.accentGold;
    return AppTheme.accentBlue;
  }
}

class _AttributeBar extends StatelessWidget {
  const _AttributeBar({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 99,
              backgroundColor: AppTheme.darkBackground,
              color: value >= 80
                  ? AppTheme.successGreen
                  : value >= 70
                      ? AppTheme.accentGold
                      : AppTheme.accentBlue,
            ),
          ),
          const SizedBox(width: 8),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: const TextStyle(color: AppTheme.accentGold, fontSize: 12)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
      ),
    );
  }
}
