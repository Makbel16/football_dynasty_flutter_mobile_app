import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/player.dart';
import '../../../services/transfer_engine_service.dart';
import '../../../widgets/player_card.dart';

class TransferMarketScreen extends ConsumerWidget {
  const TransferMarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final userClub = game.userClub;
    final marketPlayers = TransferEngineService.instance
        .getTransferListedPlayers(game.players, excludeClubId: game.userClubId)
        .take(50)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Market'),
        actions: [
          if (userClub != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  'Budget: ${Formatters.currency(userClub.budget)}',
                  style: const TextStyle(color: AppTheme.accentGold),
                ),
              ),
            ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Buy Players'),
                Tab(text: 'Sell Players'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _BuyTab(players: marketPlayers, budget: userClub?.budget ?? 0),
                  _SellTab(
                    players: game.userClubId != null
                        ? game.playersForClub(game.userClubId!)
                        : [],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyTab extends ConsumerWidget {
  const _BuyTab({required this.players, required this.budget});
  final List<Player> players;
  final double budget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final value = TransferEngineService.instance.calculateTransferValue(player);
        final canAfford = budget >= value;

        return PlayerCard(
          player: player,
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(value),
                style: TextStyle(
                  color: canAfford ? AppTheme.accentGold : AppTheme.dangerRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 30,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: canAfford
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Offer sent for ${player.name}!'),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Offer'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SellTab extends StatelessWidget {
  const _SellTab({required this.players});
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final value = TransferEngineService.instance.calculateTransferValue(player);

        return PlayerCard(
          player: player,
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(value),
                style: const TextStyle(color: AppTheme.accentGold),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 30,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${player.name} listed for transfer')),
                    );
                  },
                  child: const Text('List'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
