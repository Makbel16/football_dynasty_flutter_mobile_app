import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/random_utils.dart';
import '../../models/club.dart';
import '../../models/league.dart';
import '../../models/player.dart';
import 'player_generator_service.dart';

class WorldGeneratorService {
  WorldGeneratorService._();
  static final WorldGeneratorService instance = WorldGeneratorService._();
  static const _uuid = Uuid();

  static const _clubPrefixes = [
    'United', 'City', 'Athletic', 'Sporting', 'Real', 'Inter', 'Dynamo',
    'Rangers', 'Rovers', 'Wanderers', 'Town', 'FC', 'SC', 'CF',
  ];

  static const _clubNames = [
    'Northwood', 'Riverside', 'Highfield', 'Oakmont', 'Westbridge',
    'Eastvale', 'Southport', 'Greenwich', 'Kingsford', 'Silverton',
    'Blackwood', 'Redcliffe', 'Bluewater', 'Goldcrest', 'Ironbridge',
    'Stonehaven', 'Fairview', 'Millbrook', 'Hillcrest', 'Lakeview',
  ];

  Club generateClub({
    required String country,
    required String league,
    int reputation = 50,
    bool isUserClub = false,
    String? name,
    String? stadiumName,
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    final clubName = name ??
        '${RandomUtils.pick(_clubNames)} ${RandomUtils.pick(_clubPrefixes)}';
    return Club(
      id: _uuid.v4(),
      name: clubName,
      country: country,
      league: league,
      stadiumName: stadiumName ?? '$clubName Stadium',
      primaryColor: primaryColor ?? _randomColor(),
      secondaryColor: secondaryColor ?? _randomColor(),
      budget: reputation * 100000.0,
      clubValue: reputation * 200000.0,
      fanHappiness: RandomUtils.nextDouble(50, 80),
      boardConfidence: 70,
      reputation: reputation,
      isUserClub: isUserClub,
      stadiumCapacity: RandomUtils.nextInt(15000, 60000),
      foundedYear: RandomUtils.nextInt(1880, 2000),
    );
  }

  League generateLeague({
    required String country,
    required String leagueName,
    required int tier,
    int clubCount = 20,
  }) {
    final clubs = List.generate(
      clubCount,
      (i) => generateClub(
        country: country,
        league: leagueName,
        reputation: (100 - tier * 10 - i * 2).clamp(20, 95),
      ),
    );

    return League(
      id: _uuid.v4(),
      name: leagueName,
      country: country,
      tier: tier,
      clubIds: clubs.map((c) => c.id).toList(),
    );
  }

  ({List<Club> clubs, List<League> leagues, List<Player> players})
      generateWorld({
    String country = 'England',
    String leagueName = 'Premier League',
    int tier = 1,
  }) {
    final league = generateLeague(
      country: country,
      leagueName: leagueName,
      tier: tier,
    );

    final clubs = <Club>[];
    final allPlayers = <Player>[];

    for (final clubId in league.clubIds) {
      final club = generateClub(country: country, league: leagueName);
      final clubWithId = club.copyWith(id: clubId);
      clubs.add(clubWithId);
      allPlayers.addAll(
        PlayerGeneratorService.instance.generateSquad(
          clubId,
          count: AppConstants.playersPerClub,
        ),
      );
    }

    return (clubs: clubs, leagues: [league], players: allPlayers);
  }

  Color _randomColor() {
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFFFB300),
      const Color(0xFF8E24AA),
      const Color(0xFF00ACC1),
      const Color(0xFF6D4C41),
      const Color(0xFF546E7A),
    ];
    return RandomUtils.pick(colors);
  }
}
