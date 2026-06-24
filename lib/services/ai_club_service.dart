import 'package:uuid/uuid.dart';
import '../../core/utils/random_utils.dart';
import '../../models/achievement.dart';
import '../../models/board_objective.dart';
import '../../models/club.dart';
import '../../models/enums/game_enums.dart';
import '../../models/game_state.dart';
import '../../models/league.dart';
import '../../models/player.dart';
import '../../models/tactics.dart';
import '../../models/transfer_offer.dart';
import 'transfer_engine_service.dart';

class AiClubService {
  AiClubService._();
  static final AiClubService instance = AiClubService._();
  static const _uuid = Uuid();

  List<Club> updateAiClubs({
    required List<Club> clubs,
    required List<Player> players,
    required List<Tactics> tactics,
    required List<TransferOffer> existingTransfers,
  }) {
    final updatedClubs = <Club>[];
    final newTransfers = <TransferOffer>[];

    for (final club in clubs.where((c) => !c.isUserClub)) {
      var updatedClub = club;
      final squad = players.where((p) => p.clubId == club.id).toList();
      final avgRating = squad.isEmpty
          ? 50.0
          : squad.map((p) => p.overall).reduce((a, b) => a + b) / squad.length;

      // AI buys if squad is weak and has budget
      if (avgRating < 70 && club.budget > 2000000) {
        final targets = players
            .where((p) =>
                p.clubId != club.id &&
                !p.isYouth &&
                p.overall > avgRating &&
                p.marketValue < club.budget * 0.3)
            .toList();
        if (targets.isNotEmpty) {
          final target = RandomUtils.pick(targets);
          final seller = clubs.firstWhere((c) => c.id == target.clubId);
          newTransfers.add(TransferEngineService.instance.createOffer(
            player: target,
            fromClub: seller,
            toClub: club,
          ));
        }
      }

      // AI sells old expensive players
      final oldPlayers = squad
          .where((p) => p.age > 32 && p.salary > 50000)
          .toList();
      if (oldPlayers.isNotEmpty && RandomUtils.chance(0.3)) {
        final toSell = RandomUtils.pick(oldPlayers);
        final buyer = RandomUtils.pick(
          clubs.where((c) => c.id != club.id && !c.isUserClub).toList(),
        );
        newTransfers.add(TransferEngineService.instance.createOffer(
          player: toSell,
          fromClub: club,
          toClub: buyer,
        ));
      }

      updatedClubs.add(updatedClub);
    }

    return updatedClubs;
  }

  List<Tactics> updateAiTactics(List<Tactics> tactics, List<Club> clubs) {
    return tactics.map((t) {
      final club = clubs.firstWhere((c) => c.id == t.clubId);
      if (club.isUserClub) return t;

      if (RandomUtils.chance(0.2)) {
        final formations = ['4-4-2', '4-3-3', '3-5-2', '4-2-3-1'];
        return t.copyWith(formation: RandomUtils.pick(formations));
      }
      return t;
    }).toList();
  }
}

class AchievementService {
  AchievementService._();
  static final AchievementService instance = AchievementService._();

  static List<Achievement> defaultAchievements() => [
        const Achievement(
          id: 'first_win',
          type: AchievementType.firstWin,
          title: 'First Victory',
          description: 'Win your first match as manager',
        ),
        const Achievement(
          id: 'league_champion',
          type: AchievementType.leagueChampion,
          title: 'League Champion',
          description: 'Win the league title',
        ),
        const Achievement(
          id: 'domestic_double',
          type: AchievementType.domesticDouble,
          title: 'Domestic Double',
          description: 'Win league and cup in same season',
        ),
        const Achievement(
          id: 'undefeated',
          type: AchievementType.undefeatedSeason,
          title: 'Invincibles',
          description: 'Complete a season undefeated',
        ),
        const Achievement(
          id: 'youth_star',
          type: AchievementType.youthStarDeveloped,
          title: 'Youth Star',
          description: 'Develop a youth player to 80+ overall',
        ),
        const Achievement(
          id: 'promotion',
          type: AchievementType.promotion,
          title: 'Promotion',
          description: 'Earn promotion to a higher league',
        ),
      ];

  List<Achievement> checkAchievements({
    required GameState state,
    required List<Achievement> current,
  }) {
    final updated = List<Achievement>.from(current);
    final userId = state.userClubId;
    if (userId == null) return updated;

    final standing = state.userStanding;
    if (standing != null && standing.won >= 1) {
      _unlock(updated, AchievementType.firstWin, userId);
    }

    if (standing != null && standing.played >= 10) {
      final league = state.userLeague;
      if (league != null) {
        final position = state.standings
            .where((s) => s.leagueId == league.id && s.season == state.season)
            .toList();
        // Check league win at end of season
      }
    }

    final youthStars = state.playersForClub(userId)
        .where((p) => p.isYouth && p.overall >= 80);
    if (youthStars.isNotEmpty) {
      _unlock(updated, AchievementType.youthStarDeveloped, userId);
    }

    return updated;
  }

  void _unlock(List<Achievement> achievements, AchievementType type, String clubId) {
    final index = achievements.indexWhere((a) => a.type == type);
    if (index >= 0 && achievements[index].unlockedAt == null) {
      achievements[index] = achievements[index].copyWith(
        unlockedAt: DateTime.now(),
        clubId: clubId,
      );
    }
  }
}

class BoardService {
  BoardService._();
  static final BoardService instance = BoardService._();
  static const _uuid = Uuid();

  List<BoardObjective> generateObjectives(String clubId, int season) => [
        BoardObjective(
          id: '${_uuid.v4()}_pos',
          clubId: clubId,
          type: BoardObjectiveType.leaguePosition,
          description: 'Finish in Top 4',
          targetValue: 4,
          season: season,
        ),
        BoardObjective(
          id: '${_uuid.v4()}_rev',
          clubId: clubId,
          type: BoardObjectiveType.increaseRevenue,
          description: 'Increase club revenue by 10%',
          targetValue: 10,
          season: season,
        ),
        BoardObjective(
          id: '${_uuid.v4()}_youth',
          clubId: clubId,
          type: BoardObjectiveType.developYouth,
          description: 'Promote 2 youth players',
          targetValue: 2,
          season: season,
        ),
      ];

  double updateBoardConfidence({
    required Club club,
    required List<BoardObjective> objectives,
    required int leaguePosition,
    required int totalTeams,
  }) {
    var confidence = club.boardConfidence;
    final completed = objectives.where((o) => o.isCompleted).length;
    confidence += completed * 5;

    if (leaguePosition <= 4) confidence += 10;
    if (leaguePosition > totalTeams - 3) confidence -= 15;

    return confidence.clamp(0, 100);
  }

  bool shouldSackManager(double boardConfidence) => boardConfidence < 15;
}
