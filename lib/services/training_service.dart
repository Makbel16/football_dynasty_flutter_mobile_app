import '../../core/utils/random_utils.dart';
import '../../models/enums/game_enums.dart';
import '../../models/player.dart';

class TrainingService {
  TrainingService._();
  static final TrainingService instance = TrainingService._();

  List<Player> applyTraining({
    required List<Player> players,
    required TrainingType type,
    required int intensity,
  }) {
    final factor = intensity / 100.0;

    return players.map((player) {
      var updated = player.copyWith(
        fitness: (player.fitness - intensity * 0.05).clamp(40, 100),
        morale: (player.morale + intensity * 0.02).clamp(0, 100),
      );

      switch (type) {
        case TrainingType.attacking:
          updated = updated.copyWith(
            shooting: _growAttr(player.shooting, factor, player.potential),
            dribbling: _growAttr(player.dribbling, factor * 0.5, player.potential),
          );
        case TrainingType.defensive:
          updated = updated.copyWith(
            defending: _growAttr(player.defending, factor, player.potential),
          );
        case TrainingType.physical:
          updated = updated.copyWith(
            physical: _growAttr(player.physical, factor, player.potential),
            pace: _growAttr(player.pace, factor * 0.5, player.potential),
            fitness: (updated.fitness + intensity * 0.03).clamp(40, 100),
          );
        case TrainingType.tactical:
          updated = updated.copyWith(
            passing: _growAttr(player.passing, factor, player.potential),
            morale: (updated.morale + 2).clamp(0, 100),
          );
      }

      if (player.isYouth && player.age < 21) {
        final growthChance = (player.potential - player.overall) / 100;
        if (RandomUtils.chance(growthChance * factor)) {
          updated = updated.copyWith(overall: (player.overall + 1).clamp(1, 99));
        }
      }

      return updated;
    }).toList();
  }

  int _growAttr(int current, double factor, int potential) {
    if (current >= potential) return current;
    final growth = RandomUtils.chance(factor * 0.3) ? 1 : 0;
    return (current + growth).clamp(1, 99);
  }

  void recoverFitness(List<Player> players) {
  }
}
