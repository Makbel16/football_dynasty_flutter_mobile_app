import 'package:equatable/equatable.dart';

class LeagueStanding extends Equatable {
  const LeagueStanding({
    required this.leagueId,
    required this.clubId,
    required this.season,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
  });

  final String leagueId;
  final String clubId;
  final int season;
  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;

  int get goalDifference => goalsFor - goalsAgainst;

  LeagueStanding copyWith({
    String? leagueId,
    String? clubId,
    int? season,
    int? played,
    int? won,
    int? drawn,
    int? lost,
    int? goalsFor,
    int? goalsAgainst,
    int? points,
  }) {
    return LeagueStanding(
      leagueId: leagueId ?? this.leagueId,
      clubId: clubId ?? this.clubId,
      season: season ?? this.season,
      played: played ?? this.played,
      won: won ?? this.won,
      drawn: drawn ?? this.drawn,
      lost: lost ?? this.lost,
      goalsFor: goalsFor ?? this.goalsFor,
      goalsAgainst: goalsAgainst ?? this.goalsAgainst,
      points: points ?? this.points,
    );
  }

  Map<String, dynamic> toMap() => {
        'leagueId': leagueId,
        'clubId': clubId,
        'season': season,
        'played': played,
        'won': won,
        'drawn': drawn,
        'lost': lost,
        'goalsFor': goalsFor,
        'goalsAgainst': goalsAgainst,
        'points': points,
      };

  factory LeagueStanding.fromMap(Map<String, dynamic> map) => LeagueStanding(
        leagueId: map['leagueId'] as String,
        clubId: map['clubId'] as String,
        season: map['season'] as int,
        played: map['played'] as int? ?? 0,
        won: map['won'] as int? ?? 0,
        drawn: map['drawn'] as int? ?? 0,
        lost: map['lost'] as int? ?? 0,
        goalsFor: map['goalsFor'] as int? ?? 0,
        goalsAgainst: map['goalsAgainst'] as int? ?? 0,
        points: map['points'] as int? ?? 0,
      );

  @override
  List<Object?> get props => [leagueId, clubId, season, points];
}

class League extends Equatable {
  const League({
    required this.id,
    required this.name,
    required this.country,
    required this.tier,
    required this.clubIds,
    this.season = 1,
  });

  final String id;
  final String name;
  final String country;
  final int tier;
  final List<String> clubIds;
  final int season;

  League copyWith({
    String? id,
    String? name,
    String? country,
    int? tier,
    List<String>? clubIds,
    int? season,
  }) {
    return League(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      tier: tier ?? this.tier,
      clubIds: clubIds ?? this.clubIds,
      season: season ?? this.season,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'country': country,
        'tier': tier,
        'clubIds': clubIds.join(','),
        'season': season,
      };

  factory League.fromMap(Map<String, dynamic> map) => League(
        id: map['id'] as String,
        name: map['name'] as String,
        country: map['country'] as String,
        tier: map['tier'] as int,
        clubIds: (map['clubIds'] as String).split(',').where((e) => e.isNotEmpty).toList(),
        season: map['season'] as int? ?? 1,
      );

  @override
  List<Object?> get props => [id, name, country];
}
