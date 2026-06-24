import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'squad_screen.dart';
import '../../league/screens/league_table_screen.dart';
import '../../transfers/screens/transfer_market_screen.dart';
import '../../tactics/screens/tactics_screen.dart';
import '../../finances/screens/finances_screen.dart';
import '../../academy/screens/academy_screen.dart';
import '../../facilities/screens/facilities_screen.dart';
import '../../achievements/screens/achievements_screen.dart';
import '../../../core/theme/app_theme.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _index = 0;

  static const _screens = [
    DashboardScreen(),
    SquadScreen(),
    LeagueTableScreen(),
    TransferMarketScreen(),
    TacticsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Squad'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'League'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Transfers'),
          NavigationDestination(icon: Icon(Icons.sports), label: 'Tactics'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.pitchGreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.sports_soccer, color: AppTheme.accentGold, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Football Dynasty',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Finances'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FinancesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Youth Academy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AcademyScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.construction),
              title: const Text('Facilities'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FacilitiesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('Achievements'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
