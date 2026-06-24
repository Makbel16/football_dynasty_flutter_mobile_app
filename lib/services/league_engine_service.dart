import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/random_utils.dart';
import '../../models/club.dart';
import '../../models/league.dart';
import '../../models/match_result.dart';
import '../../models/player.dart';
import '../../models/tactics.dart';
import 'match_engine_service.dart';

class LeagueEngineService {
  LeagueEngineService._();
  static final LeagueEngineService instance = LeagueEngineService._();
  static const _uuid = Uuid();

  List<MatchResult> generateFixtures({
    required League league,
    required int season,
  }) {
    final clubIds = List<String>.from(league.clubIds);
    if (clubIds.length % 2 != 0) clubIds.add('bye');

    final rounds = <List<(String, String)>>[];
    final n = clubIds.length;
    final rotating = clubIds.sublist(1);

    for (var round = 0; round < n - 1; round++) {
      final pairs = <(String, String)>[];
      pairs.add((clubIds[0], rotating[round % rotating.length]));

      for (var i = 1; i < n ~/ 2; i++) {
        final home = rotating[(round + i) % rotating.length];
        final away = rotating[(round + n - 1 - i) % rotating.length];
        pairs.add((home, away));
      }
      rounds.add(pairs);
    }

    final matches = <MatchResult>[];
    var week = 1;

    for (final round in rounds) {
      for (final pair in round) {
        if (pair.$1 == 'bye' || pair.$2 == 'bye') continue;
        matches.add(MatchResult(
          id: _uuid.v4(),
          homeClubId: pair.$1,
          awayClubId: pair.$2,
          homeGoals: 0,
          awayGoals: 0,
          season: season,
          week: week,
          events: [],
          leagueId: league.id,
        ));
      }
      week++;
    }

    // Return fixtures (second half of season)
    final returnMatches = matches.map((m) => MatchResult(
          id: _uuid.v4(),
          homeClubId: m.awayClubId,
          awayClubId: m.homeClubId,
          homeGoals: 0,
          awayGoals: 0,
          season: season,
          week: m.week + (n - 1),
          events: [],
          leagueId: league.id,
        ));

    return [...matches, ...returnMatches];
  }

  List<LeagueStanding> createStandings(League league, int season) {
    return league.clubIds
        .map((clubId) => LeagueStanding(
              leagueId: league.id,
              clubId: clubId,
              season: season,
            ))
        .toList();
  }

  List<LeagueStanding> updateStandings({
    required List<LeagueStanding> standings,
    required MatchResult match,
  }) {
    if (!match.isPlayed || match.leagueId == null) return standings;

    return standings.map((s) {
      if (s.leagueId != match.leagueId || s.season != match.season) return s;

      if (s.clubId == match.homeClubId) {
        return _updateClubStanding(
          s,
          goalsFor: match.homeGoals,
          goalsAgainst: match.awayGoals,
        );
      }
      if (s.clubId == match.awayClubId) {
        return _updateClubStanding(
          s,
          goalsFor: match.awayGoals,
          goalsAgainst: match.homeGoals,
        );
      }
      return s;
    }).toList();
  }

  LeagueStanding _updateClubStanding(
    LeagueStanding standing, {
    required int goalsFor,
    required int goalsAgainst,
  }) {
    final won = goalsFor > goalsAgainst;
    final drawn = goalsFor == goalsAgainst;
    final lost = goalsFor < goalsAgainst;

    return standing.copyWith(
      played: standing.played + 1,
      won: standing.won + (won ? 1 : 0),
      drawn: standing.drawn + (drawn ? 1 : 0),
      lost: standing.lost + (lost ? 1 : 0),
      goalsFor: standing.goalsFor + goalsFor,
      goalsAgainst: standing.goalsAgainst + goalsAgainst,
      points: standing.points + (won ? 3 : (drawn ? 1 : 0)),
    );
  }

  List<LeagueStanding> sortedStandings(List<LeagueStanding> standings) {
    final sorted = List<LeagueStanding>.from(standings);
    sorted.sort((a, b) {
      if (b.points != a.points) return b.points.compareTo(a.points);
      final gdA = a.goalDifference;
      final gdB = b.goalDifference;
      if (gdB != gdA) return gdB.compareTo(gdA);
      return b.goalsFor.compareTo(a.goalsFor);
    });
    return sorted;
  }

  int getPosition(List<LeagueStanding> standings, String clubId) {
    final sorted = sortedStandings(standings);
    return sorted.indexWhere((s) => s.clubId == clubId) + 1;
  }

  List<MatchResult> simulateMatchweek({
    required List<MatchResult> matches,
    required int week,
    required List<Club> clubs,
    required List<Player> players,
    required List<Tactics> tactics,
  }) {
    final weekMatches = matches.where((m) => m.week == week && !m.isPlayed);

    return matches.map((match) {
      if (match.week != week || match.isPlayed) return match;

      final homeClub = clubs.firstWhere((c) => c.id == match.homeClubId);
      final awayClub = clubs.firstWhere((c) => c.id == match.awayClubId);
      final homePlayers = players.where((p) => p.clubId == homeClub.id).toList();
      final awayPlayers = players.where((p) => p.clubId == awayClub.id).toList();
      final homeTactics = tactics.firstWhere(
        (t) => t.clubId == homeClub.id,
        orElse: () => Tactics(clubId: homeClub.id),
      );
      final awayTactics = tactics.firstWhere(
        (t) => t.clubId == awayClub.id,
        orElse: () => Tactics(clubId: awayClub.id),
      );

      final result = MatchEngineService.instance.simulateMatch(
        match: match,
        homeClub: homeClub,
        awayClub: awayClub,
        homePlayers: homePlayers,
        awayPlayers: awayPlayers,
        homeTactics: homeTactics,
        awayTactics: awayTactics,
      );

      return result;
    }).toList();
  }

  ({List<String> promoted, List<String> relegated}) processPromotionRelegation({
    required List<LeagueStanding> standings,
    required int promotionSpots,
    required int relegationSpots,
  }) {
    final sorted = sortedStandings(standings);
    final promoted = sorted
        .take(promotionSpots)
        .map((s) => s.clubId)
        .toList();
    final relegated = sorted
        .reversed
        .take(relegationSpots)
        .map((s) => s.clubId)
        .toList();
    return (promoted: promoted, relegated: relegated);
  }

  List<MatchResult> getMatchesForWeek(List<MatchResult> matches, int week) =>
      matches.where((m) => m.week == week).toList();
}
