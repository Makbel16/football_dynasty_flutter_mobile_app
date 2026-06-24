import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/player.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.player,
    this.onTap,
    this.trailing,
  });

  final Player player;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _ratingColor(player.overall),
          child: Text(
            '${player.overall}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(player.name),
        subtitle: Text(
          '${player.position.code} • ${player.age}y • ${player.nationality}',
        ),
        trailing: trailing ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'POT ${player.potential}',
                  style: const TextStyle(
                    color: AppTheme.accentGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '€${(player.marketValue / 1000000).toStringAsFixed(1)}M',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
      ),
    );
  }

  Color _ratingColor(int rating) {
    if (rating >= 80) return AppTheme.successGreen;
    if (rating >= 70) return AppTheme.accentGold;
    if (rating >= 60) return AppTheme.accentBlue;
    return AppTheme.textSecondary;
  }
}
