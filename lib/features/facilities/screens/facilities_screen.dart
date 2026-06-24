import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/enums/game_enums.dart';
import '../../../models/facility.dart';
import '../../../widgets/section_header.dart';

class FacilitiesScreen extends ConsumerWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final club = game.userClub;
    if (club == null) return const Scaffold(body: Center(child: Text('No club')));

    final facilities = FacilityType.values.map((type) {
      return Facility(clubId: club.id, type: type);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Facilities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.stadium, color: AppTheme.accentGold),
              title: Text(club.stadiumName),
              subtitle: Text('Capacity: ${club.stadiumCapacity.toString().replaceAllMapped(
                    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                    (m) => '${m[1]},',
                  )}'),
            ),
          ),
          const SectionHeader(title: 'Upgrades'),
          ...facilities.map((facility) {
            final canAfford = club.budget >= facility.upgradeCost;
            return Card(
              child: ListTile(
                leading: Icon(_facilityIcon(facility.type), color: AppTheme.accentGold),
                title: Text(facility.label),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${facility.level}/${facility.maxLevel}'),
                    Text('Bonus: +${(facility.bonus * 100).toInt()}%'),
                    LinearProgressIndicator(
                      value: facility.level / facility.maxLevel,
                      backgroundColor: AppTheme.darkBackground,
                      color: AppTheme.accentGold,
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: facility.level >= facility.maxLevel
                      ? null
                      : canAfford
                          ? () {
                              ref
                                  .read(gameProvider.notifier)
                                  .upgradeFacility(facility.type);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${facility.label} upgraded!'),
                                ),
                              );
                            }
                          : null,
                  child: Text(
                    facility.level >= facility.maxLevel
                        ? 'Max'
                        : Formatters.currency(facility.upgradeCost),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _facilityIcon(FacilityType type) => switch (type) {
        FacilityType.stadium => Icons.stadium,
        FacilityType.trainingGround => Icons.fitness_center,
        FacilityType.medicalCenter => Icons.local_hospital,
        FacilityType.youthFacilities => Icons.school,
      };
}
