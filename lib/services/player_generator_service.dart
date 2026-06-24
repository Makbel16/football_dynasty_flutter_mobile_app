import 'package:uuid/uuid.dart';
import '../../models/enums/player_position.dart';
import '../../models/player.dart';
import '../../core/utils/random_utils.dart';

class PlayerGeneratorService {
  PlayerGeneratorService._();
  static final PlayerGeneratorService instance = PlayerGeneratorService._();
  static const _uuid = Uuid();

  static const _firstNames = [
    'James', 'John', 'Michael', 'David', 'Carlos', 'Luis', 'Marco', 'Pierre',
    'Hans', 'Luca', 'Pedro', 'Diego', 'Andre', 'Thomas', 'Mohamed', 'Yuki',
    'Antoine', 'Bruno', 'Kevin', 'Luka', 'Neymar', 'Cristiano', 'Lionel',
    'Harry', 'Marcus', 'Kylian', 'Erling', 'Jude', 'Phil', 'Bukayo',
  ];

  static const _lastNames = [
    'Smith', 'Johnson', 'Williams', 'Brown', 'Garcia', 'Martinez', 'Silva',
    'Santos', 'Mueller', 'Schmidt', 'Rossi', 'Ferrari', 'Dubois', 'Martin',
    'Anderson', 'Taylor', 'Wilson', 'Moore', 'Jackson', 'White', 'Harris',
    'Clark', 'Lewis', 'Walker', 'Hall', 'Young', 'King', 'Wright', 'Lopez',
  ];

  static const _nationalities = [
    'England', 'Spain', 'Germany', 'Italy', 'France', 'Brazil', 'Argentina',
    'Portugal', 'Netherlands', 'Belgium', 'Croatia', 'Uruguay', 'Colombia',
    'Mexico', 'USA', 'Japan', 'South Korea', 'Nigeria', 'Senegal', 'Morocco',
  ];

  Player generatePlayer({
    required String clubId,
    PlayerPosition? position,
    int? minAge,
    int? maxAge,
    int? minOverall,
    int? maxOverall,
    bool isYouth = false,
  }) {
    final PlayerPosition pos =
        position ?? RandomUtils.pick(PlayerPosition.values.toList());
    final age = isYouth
        ? RandomUtils.nextInt(15, 18)
        : RandomUtils.nextInt(minAge ?? 17, maxAge ?? 35);

    final baseOverall = isYouth
        ? RandomUtils.nextInt(40, 65)
        : RandomUtils.nextInt(minOverall ?? 55, maxOverall ?? 88);

    final potential = isYouth
        ? RandomUtils.nextInt(50, 99)
        : (baseOverall + RandomUtils.nextInt(0, 15)).clamp(50, 99).toInt();

    final attrs = _generateAttributes(pos, baseOverall);
    final marketValue = _calculateMarketValue(baseOverall, potential, age);
    final salary = marketValue * 0.0001;

    return Player(
      id: _uuid.v4(),
      name: '${RandomUtils.pick(_firstNames)} ${RandomUtils.pick(_lastNames)}',
      age: age,
      nationality: RandomUtils.pick(_nationalities),
      position: pos,
      overall: baseOverall,
      potential: potential,
      pace: attrs['pace']!,
      shooting: attrs['shooting']!,
      passing: attrs['passing']!,
      dribbling: attrs['dribbling']!,
      defending: attrs['defending']!,
      physical: attrs['physical']!,
      clubId: clubId,
      morale: RandomUtils.nextDouble(60, 90),
      fitness: RandomUtils.nextDouble(85, 100),
      contractYears: RandomUtils.nextInt(1, 5),
      marketValue: marketValue,
      salary: salary,
      form: RandomUtils.nextDouble(40, 70),
      isYouth: isYouth,
    );
  }

  List<Player> generateSquad(String clubId, {int count = 25}) {
    final players = <Player>[];
    final positions = [
      PlayerPosition.gk,
      ...List.filled(4, PlayerPosition.cb),
      PlayerPosition.lb,
      PlayerPosition.rb,
      ...List.filled(4, PlayerPosition.cm),
      PlayerPosition.lw,
      PlayerPosition.rw,
      ...List.filled(2, PlayerPosition.st),
      PlayerPosition.cam,
      PlayerPosition.cdm,
    ];

    for (var i = 0; i < count; i++) {
      final pos = i < positions.length
          ? positions[i]
          : RandomUtils.pick(PlayerPosition.values);
      players.add(generatePlayer(clubId: clubId, position: pos));
    }
    return players;
  }

  List<Player> generateYouthIntake(String clubId, {int count = 8}) {
    return List.generate(
      count,
      (_) => generatePlayer(clubId: clubId, isYouth: true),
    );
  }

  List<Player> generateTransferMarket({int count = 500}) {
    final players = <Player>[];
    for (var i = 0; i < count; i++) {
      players.add(
        generatePlayer(
          clubId: 'market_${i ~/ 50}',
          minOverall: 50,
          maxOverall: 90,
        ),
      );
    }
    return players;
  }

  Map<String, int> _generateAttributes(PlayerPosition pos, int overall) {
    final variance = 8;
    int attr(int base) =>
        (base + RandomUtils.nextInt(-variance, variance)).clamp(1, 99).toInt();

    return switch (pos) {
      PlayerPosition.gk => {
          'pace': attr(overall - 20),
          'shooting': attr(overall - 30),
          'passing': attr(overall - 5),
          'dribbling': attr(overall - 15),
          'defending': attr(overall + 5),
          'physical': attr(overall),
        },
      PlayerPosition.cb => {
          'pace': attr(overall - 10),
          'shooting': attr(overall - 15),
          'passing': attr(overall - 5),
          'dribbling': attr(overall - 10),
          'defending': attr(overall + 10),
          'physical': attr(overall + 5),
        },
      PlayerPosition.lb || PlayerPosition.rb => {
          'pace': attr(overall + 5),
          'shooting': attr(overall - 10),
          'passing': attr(overall),
          'dribbling': attr(overall),
          'defending': attr(overall + 5),
          'physical': attr(overall),
        },
      PlayerPosition.cdm => {
          'pace': attr(overall - 5),
          'shooting': attr(overall - 10),
          'passing': attr(overall + 5),
          'dribbling': attr(overall - 5),
          'defending': attr(overall + 10),
          'physical': attr(overall + 5),
        },
      PlayerPosition.cm || PlayerPosition.cam => {
          'pace': attr(overall),
          'shooting': attr(overall),
          'passing': attr(overall + 10),
          'dribbling': attr(overall + 5),
          'defending': attr(overall - 5),
          'physical': attr(overall),
        },
      PlayerPosition.lw ||
      PlayerPosition.rw ||
      PlayerPosition.lm ||
      PlayerPosition.rm =>
        {
          'pace': attr(overall + 10),
          'shooting': attr(overall + 5),
          'passing': attr(overall),
          'dribbling': attr(overall + 10),
          'defending': attr(overall - 15),
          'physical': attr(overall - 5),
        },
      PlayerPosition.st => {
          'pace': attr(overall + 5),
          'shooting': attr(overall + 15),
          'passing': attr(overall - 5),
          'dribbling': attr(overall + 5),
          'defending': attr(overall - 20),
          'physical': attr(overall + 5),
        },
      _ => {
          'pace': attr(overall),
          'shooting': attr(overall),
          'passing': attr(overall),
          'dribbling': attr(overall),
          'defending': attr(overall),
          'physical': attr(overall),
        },
    };
  }

  double _calculateMarketValue(int overall, int potential, int age) {
    var value = overall * overall * 1000.0;
    value *= 1 + (potential - overall) * 0.05;
    if (age < 23) value *= 1.3;
    if (age > 30) value *= 0.7;
    if (age > 33) value *= 0.5;
    return value.clamp(50000, 150000000);
  }
}
