import 'package:equatable/equatable.dart';
import 'achievement.dart';
import 'board_objective.dart';
import 'club.dart';
import 'financial_record.dart';
import 'game_state_models.dart';
import 'league.dart';
import 'match_result.dart';
import 'player.dart';
import 'tactics.dart';
import 'transfer_offer.dart';

class GameState extends Equatable {
  const GameState({
    this.userClubId,
    this.season = 1,
    this.week = 1,
    this.clubs = const [],
    this.players = const [],
    this.leagues = const [],
    this.standings = const [],
    this.matches = const [],
    this.tactics = const [],
    this.transfers = const [],
    this.finances = const [],
    this.achievements = const [],
    this.objectives = const [],
    this.trophies = const [],
    this.positionHistory = const [],
    this.isInitialized = false,
    this.managerName = 'Manager',
    this.yearsManaged = 0,
  });

  final String? userClubId;
  final int season;
  final int week;
  final List<Club> clubs;
  final List<Player> players;
  final List<League> leagues;
  final List<LeagueStanding> standings;
  final List<MatchResult> matches;
  final List<Tactics> tactics;
  final List<TransferOffer> transfers;
  final List<FinancialRecord> finances;
  final List<Achievement> achievements;
  final List<BoardObjective> objectives;
  final List<Trophy> trophies;
  final List<int> positionHistory;
  final bool isInitialized;
  final String managerName;
  final int yearsManaged;

  Club? get userClub =>
      userClubId != null ? clubs.cast<Club?>().firstWhere(
            (c) => c?.id == userClubId,
            orElse: () => null,
          ) : null;

  List<Player> playersForClub(String clubId) =>
      players.where((p) => p.clubId == clubId && !p.isYouth).toList();

  List<Player> youthForClub(String clubId) =>
      players.where((p) => p.clubId == clubId && p.isYouth).toList();

  Tactics? tacticsForClub(String clubId) {
    try {
      return tactics.firstWhere((t) => t.clubId == clubId);
    } catch (_) {
      return null;
    }
  }

  League? get userLeague {
    final club = userClub;
    if (club == null) return null;
    try {
      return leagues.firstWhere((l) => l.clubIds.contains(club.id));
    } catch (_) {
      return null;
    }
  }

  LeagueStanding? get userStanding {
    final league = userLeague;
    final clubId = userClubId;
    if (league == null || clubId == null) return null;
    try {
      return standings.firstWhere(
        (s) => s.leagueId == league.id && s.clubId == clubId && s.season == season,
      );
    } catch (_) {
      return null;
    }
  }

  List<MatchResult> recentMatches({int limit = 5}) {
    if (userClubId == null) return [];
    return matches
        .where((m) =>
            m.isPlayed &&
            (m.homeClubId == userClubId || m.awayClubId == userClubId))
        .toList()
      ..sort((a, b) => b.week.compareTo(a.week))
      ..take(limit);
  }

  List<MatchResult> upcomingMatches({int limit = 3}) {
    if (userClubId == null) return [];
    return matches
        .where((m) =>
            !m.isPlayed &&
            (m.homeClubId == userClubId || m.awayClubId == userClubId))
        .toList()
      ..sort((a, b) => a.week.compareTo(b.week))
      ..take(limit);
  }

  GameState copyWith({
    String? userClubId,
    int? season,
    int? week,
    List<Club>? clubs,
    List<Player>? players,
    List<League>? leagues,
    List<LeagueStanding>? standings,
    List<MatchResult>? matches,
    List<Tactics>? tactics,
    List<TransferOffer>? transfers,
    List<FinancialRecord>? finances,
    List<Achievement>? achievements,
    List<BoardObjective>? objectives,
    List<Trophy>? trophies,
    List<int>? positionHistory,
    bool? isInitialized,
    String? managerName,
    int? yearsManaged,
  }) {
    return GameState(
      userClubId: userClubId ?? this.userClubId,
      season: season ?? this.season,
      week: week ?? this.week,
      clubs: clubs ?? this.clubs,
      players: players ?? this.players,
      leagues: leagues ?? this.leagues,
      standings: standings ?? this.standings,
      matches: matches ?? this.matches,
      tactics: tactics ?? this.tactics,
      transfers: transfers ?? this.transfers,
      finances: finances ?? this.finances,
      achievements: achievements ?? this.achievements,
      objectives: objectives ?? this.objectives,
      trophies: trophies ?? this.trophies,
      positionHistory: positionHistory ?? this.positionHistory,
      isInitialized: isInitialized ?? this.isInitialized,
      managerName: managerName ?? this.managerName,
      yearsManaged: yearsManaged ?? this.yearsManaged,
    );
  }

  Map<String, dynamic> toMap() => {
        'userClubId': userClubId,
        'season': season,
        'week': week,
        'clubs': clubs.map((c) => c.toMap()).toList(),
        'players': players.map((p) => p.toMap()).toList(),
        'leagues': leagues.map((l) => l.toMap()).toList(),
        'standings': standings.map((s) => s.toMap()).toList(),
        'matches': matches.map((m) => m.toMap()).toList(),
        'tactics': tactics.map((t) => t.toMap()).toList(),
        'transfers': transfers.map((t) => t.toMap()).toList(),
        'finances': finances.map((f) => f.toMap()).toList(),
        'achievements': achievements.map((a) => a.toMap()).toList(),
        'objectives': objectives.map((o) => o.toMap()).toList(),
        'trophies': trophies.map((t) => t.toMap()).toList(),
        'positionHistory': positionHistory,
        'isInitialized': isInitialized,
        'managerName': managerName,
        'yearsManaged': yearsManaged,
      };

  factory GameState.fromMap(Map<String, dynamic> map) => GameState(
        userClubId: map['userClubId'] as String?,
        season: map['season'] as int? ?? 1,
        week: map['week'] as int? ?? 1,
        clubs: (map['clubs'] as List<dynamic>?)
                ?.map((c) => Club.fromMap(c as Map<String, dynamic>))
                .toList() ??
            [],
        players: (map['players'] as List<dynamic>?)
                ?.map((p) => Player.fromMap(p as Map<String, dynamic>))
                .toList() ??
            [],
        leagues: (map['leagues'] as List<dynamic>?)
                ?.map((l) => League.fromMap(l as Map<String, dynamic>))
                .toList() ??
            [],
        standings: (map['standings'] as List<dynamic>?)
                ?.map((s) => LeagueStanding.fromMap(s as Map<String, dynamic>))
                .toList() ??
            [],
        matches: (map['matches'] as List<dynamic>?)
                ?.map((m) => MatchResult.fromMap(m as Map<String, dynamic>))
                .toList() ??
            [],
        tactics: (map['tactics'] as List<dynamic>?)
                ?.map((t) => Tactics.fromMap(t as Map<String, dynamic>))
                .toList() ??
            [],
        transfers: (map['transfers'] as List<dynamic>?)
                ?.map((t) => TransferOffer.fromMap(t as Map<String, dynamic>))
                .toList() ??
            [],
        finances: (map['finances'] as List<dynamic>?)
                ?.map((f) => FinancialRecord.fromMap(f as Map<String, dynamic>))
                .toList() ??
            [],
        achievements: (map['achievements'] as List<dynamic>?)
                ?.map((a) => Achievement.fromMap(a as Map<String, dynamic>))
                .toList() ??
            [],
        objectives: (map['objectives'] as List<dynamic>?)
                ?.map((o) => BoardObjective.fromMap(o as Map<String, dynamic>))
                .toList() ??
            [],
        trophies: (map['trophies'] as List<dynamic>?)
                ?.map((t) => Trophy.fromMap(t as Map<String, dynamic>))
                .toList() ??
            [],
        positionHistory: (map['positionHistory'] as List<dynamic>?)
                ?.map((e) => e as int)
                .toList() ??
            [],
        isInitialized: map['isInitialized'] as bool? ?? false,
        managerName: map['managerName'] as String? ?? 'Manager',
        yearsManaged: map['yearsManaged'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [userClubId, season, week, isInitialized];
}
