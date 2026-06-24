import '../../core/constants/app_constants.dart';
import '../../core/utils/random_utils.dart';
import '../../models/club.dart';
import '../../models/enums/game_enums.dart';
import '../../models/match_result.dart';
import '../../models/player.dart';
import '../../models/tactics.dart';

class MatchEngineService {
  MatchEngineService._();
  static final MatchEngineService instance = MatchEngineService._();

  MatchResult simulateMatch({
    required MatchResult match,
    required Club homeClub,
    required Club awayClub,
    required List<Player> homePlayers,
    required List<Player> awayPlayers,
    required Tactics homeTactics,
    required Tactics awayTactics,
  }) {
    final homeStrength = _calculateTeamStrength(
      homePlayers,
      homeTactics,
      isHome: true,
    );
    final awayStrength = _calculateTeamStrength(
      awayPlayers,
      awayTactics,
      isHome: false,
    );

    final totalStrength = homeStrength + awayStrength;
    final homeWinProb = homeStrength / totalStrength;
    final awayWinProb = awayStrength / totalStrength;

    var homeGoals = 0;
    var awayGoals = 0;
    final events = <MatchEvent>[];

    // Simulate ~8-15 key moments
    final moments = RandomUtils.nextInt(8, 15);
    for (var i = 0; i < moments; i++) {
      final minute = RandomUtils.nextInt(1, 90);
      final roll = RandomUtils.nextDouble(0, 1);

      if (roll < homeWinProb * 0.35) {
        final scorer = _pickScorer(homePlayers);
        final assister = RandomUtils.chance(0.6) ? _pickScorer(homePlayers, exclude: scorer) : null;
        homeGoals++;
        events.add(MatchEvent(
          minute: minute,
          type: MatchEventType.goal,
          playerName: scorer.name,
          clubId: homeClub.id,
          assistPlayerName: assister?.name,
        ));
      } else if (roll < (homeWinProb + awayWinProb) * 0.35) {
        final scorer = _pickScorer(awayPlayers);
        final assister = RandomUtils.chance(0.6) ? _pickScorer(awayPlayers, exclude: scorer) : null;
        awayGoals++;
        events.add(MatchEvent(
          minute: minute,
          type: MatchEventType.goal,
          playerName: scorer.name,
          clubId: awayClub.id,
          assistPlayerName: assister?.name,
        ));
      } else if (RandomUtils.chance(0.15)) {
        final isHome = RandomUtils.chance(homeWinProb);
        final team = isHome ? homePlayers : awayPlayers;
        final clubId = isHome ? homeClub.id : awayClub.id;
        if (team.isNotEmpty) {
          final player = RandomUtils.pick(team);
          events.add(MatchEvent(
            minute: minute,
            type: MatchEventType.yellowCard,
            playerName: player.name,
            clubId: clubId,
          ));
        }
      } else if (RandomUtils.chance(0.03)) {
        final isHome = RandomUtils.chance(homeWinProb);
        final team = isHome ? homePlayers : awayPlayers;
        final clubId = isHome ? homeClub.id : awayClub.id;
        if (team.isNotEmpty) {
          final player = RandomUtils.pick(team);
          events.add(MatchEvent(
            minute: minute,
            type: MatchEventType.redCard,
            playerName: player.name,
            clubId: clubId,
          ));
        }
      } else if (RandomUtils.chance(0.05)) {
        final isHome = RandomUtils.chance(0.5);
        final team = isHome ? homePlayers : awayPlayers;
        final clubId = isHome ? homeClub.id : awayClub.id;
        if (team.isNotEmpty) {
          final player = RandomUtils.pick(team);
          events.add(MatchEvent(
            minute: minute,
            type: MatchEventType.injury,
            playerName: player.name,
            clubId: clubId,
          ));
        }
      }
    }

    // Ensure at least some goals based on strength
    if (homeGoals == 0 && awayGoals == 0) {
      if (RandomUtils.chance(homeWinProb)) {
        homeGoals = RandomUtils.nextInt(1, 2);
      } else {
        awayGoals = RandomUtils.nextInt(0, 2);
      }
    }

    events.sort((a, b) => a.minute.compareTo(b.minute));

    return match.copyWith(
      homeGoals: homeGoals,
      awayGoals: awayGoals,
      events: events,
      isPlayed: true,
    );
  }

  double _calculateTeamStrength(
    List<Player> players,
    Tactics tactics, {
    required bool isHome,
  }) {
    if (players.isEmpty) return 50;

    final xi = tactics.startingXi.isNotEmpty
        ? players.where((p) => tactics.startingXi.contains(p.id)).toList()
        : players.take(11).toList();

    if (xi.isEmpty) return 50;

    var strength = xi.map((p) {
      var rating = p.overall.toDouble();
      rating *= p.morale / 100;
      rating *= p.fitness / 100;
      rating *= 1 + (p.form - 50) / 200;
      return rating;
    }).reduce((a, b) => a + b) / xi.length;

    strength *= tactics.attackModifier;
    strength *= tactics.defenseModifier;
    if (isHome) strength *= 1 + AppConstants.homeAdvantageBonus;

    return strength;
  }

  Player _pickScorer(List<Player> players, {Player? exclude}) {
    final attackers = players
        .where((p) => !p.position.isGoalkeeper && p.id != exclude?.id)
        .toList();
    if (attackers.isEmpty) return RandomUtils.pick(players);
    attackers.sort((a, b) => b.shooting.compareTo(a.shooting));
    final top = attackers.take(5).toList();
    return RandomUtils.pick(top);
  }
}
