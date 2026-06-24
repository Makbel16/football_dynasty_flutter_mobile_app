import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class MatchEvent extends Equatable {
  const MatchEvent({
    required this.minute,
    required this.type,
    required this.playerName,
    required this.clubId,
    this.assistPlayerName,
    this.description,
  });

  final int minute;
  final MatchEventType type;
  final String playerName;
  final String clubId;
  final String? assistPlayerName;
  final String? description;

  String get commentary {
    switch (type) {
      case MatchEventType.goal:
        final assist = assistPlayerName != null ? ' (assist: $assistPlayerName)' : '';
        return "$minute' Goal by $playerName$assist";
      case MatchEventType.assist:
        return "$minute' Assist by $playerName";
      case MatchEventType.yellowCard:
        return "$minute' Yellow Card - $playerName";
      case MatchEventType.redCard:
        return "$minute' Red Card - $playerName";
      case MatchEventType.injury:
        return "$minute' Injury - $playerName";
      case MatchEventType.substitution:
        return "$minute' Substitution - $playerName";
    }
  }

  Map<String, dynamic> toMap() => {
        'minute': minute,
        'type': type.name,
        'playerName': playerName,
        'clubId': clubId,
        'assistPlayerName': assistPlayerName,
        'description': description,
      };

  factory MatchEvent.fromMap(Map<String, dynamic> map) => MatchEvent(
        minute: map['minute'] as int,
        type: MatchEventType.values.byName(map['type'] as String),
        playerName: map['playerName'] as String,
        clubId: map['clubId'] as String,
        assistPlayerName: map['assistPlayerName'] as String?,
        description: map['description'] as String?,
      );

  @override
  List<Object?> get props => [minute, type, playerName];
}

class MatchResult extends Equatable {
  const MatchResult({
    required this.id,
    required this.homeClubId,
    required this.awayClubId,
    required this.homeGoals,
    required this.awayGoals,
    required this.season,
    required this.week,
    required this.events,
    this.isPlayed = false,
    this.leagueId,
  });

  final String id;
  final String homeClubId;
  final String awayClubId;
  final int homeGoals;
  final int awayGoals;
  final int season;
  final int week;
  final List<MatchEvent> events;
  final bool isPlayed;
  final String? leagueId;

  String get scoreline => '$homeGoals - $awayGoals';

  MatchResult copyWith({
    String? id,
    String? homeClubId,
    String? awayClubId,
    int? homeGoals,
    int? awayGoals,
    int? season,
    int? week,
    List<MatchEvent>? events,
    bool? isPlayed,
    String? leagueId,
  }) {
    return MatchResult(
      id: id ?? this.id,
      homeClubId: homeClubId ?? this.homeClubId,
      awayClubId: awayClubId ?? this.awayClubId,
      homeGoals: homeGoals ?? this.homeGoals,
      awayGoals: awayGoals ?? this.awayGoals,
      season: season ?? this.season,
      week: week ?? this.week,
      events: events ?? this.events,
      isPlayed: isPlayed ?? this.isPlayed,
      leagueId: leagueId ?? this.leagueId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'homeClubId': homeClubId,
        'awayClubId': awayClubId,
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
        'season': season,
        'week': week,
        'events': events.map((e) => e.toMap()).toList(),
        'isPlayed': isPlayed ? 1 : 0,
        'leagueId': leagueId,
      };

  factory MatchResult.fromMap(Map<String, dynamic> map) => MatchResult(
        id: map['id'] as String,
        homeClubId: map['homeClubId'] as String,
        awayClubId: map['awayClubId'] as String,
        homeGoals: map['homeGoals'] as int? ?? 0,
        awayGoals: map['awayGoals'] as int? ?? 0,
        season: map['season'] as int,
        week: map['week'] as int,
        events: (map['events'] as List<dynamic>?)
                ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
        isPlayed: (map['isPlayed'] as int? ?? 0) == 1,
        leagueId: map['leagueId'] as String?,
      );

  @override
  List<Object?> get props => [id, homeClubId, awayClubId, homeGoals, awayGoals];
}
