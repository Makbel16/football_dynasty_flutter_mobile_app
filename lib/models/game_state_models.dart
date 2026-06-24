import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class TrainingSession extends Equatable {
  const TrainingSession({
    required this.clubId,
    required this.season,
    required this.week,
    required this.type,
    this.intensity = 50,
  });

  final String clubId;
  final int season;
  final int week;
  final TrainingType type;
  final int intensity;

  Map<String, dynamic> toMap() => {
        'clubId': clubId,
        'season': season,
        'week': week,
        'type': type.name,
        'intensity': intensity,
      };

  factory TrainingSession.fromMap(Map<String, dynamic> map) => TrainingSession(
        clubId: map['clubId'] as String,
        season: map['season'] as int,
        week: map['week'] as int,
        type: TrainingType.values.byName(map['type'] as String),
        intensity: map['intensity'] as int? ?? 50,
      );

  @override
  List<Object?> get props => [clubId, season, week, type];
}

class Trophy extends Equatable {
  const Trophy({
    required this.id,
    required this.name,
    required this.season,
    required this.clubId,
    this.competition,
  });

  final String id;
  final String name;
  final int season;
  final String clubId;
  final String? competition;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'season': season,
        'clubId': clubId,
        'competition': competition,
      };

  factory Trophy.fromMap(Map<String, dynamic> map) => Trophy(
        id: map['id'] as String,
        name: map['name'] as String,
        season: map['season'] as int,
        clubId: map['clubId'] as String,
        competition: map['competition'] as String?,
      );

  @override
  List<Object?> get props => [id, name, season];
}

class GameSave extends Equatable {
  const GameSave({
    required this.id,
    required this.userId,
    required this.saveName,
    required this.updatedAt,
    this.isCloud = false,
    this.clubName,
    this.season,
    this.week,
  });

  final String id;
  final String userId;
  final String saveName;
  final DateTime updatedAt;
  final bool isCloud;
  final String? clubName;
  final int? season;
  final int? week;

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'saveName': saveName,
        'updatedAt': updatedAt.toIso8601String(),
        'isCloud': isCloud ? 1 : 0,
        'clubName': clubName,
        'season': season,
        'week': week,
      };

  factory GameSave.fromMap(Map<String, dynamic> map) => GameSave(
        id: map['id'] as String,
        userId: map['userId'] as String,
        saveName: map['saveName'] as String,
        updatedAt: DateTime.parse(map['updatedAt'] as String),
        isCloud: (map['isCloud'] as int? ?? 0) == 1,
        clubName: map['clubName'] as String?,
        season: map['season'] as int?,
        week: map['week'] as int?,
      );

  @override
  List<Object?> get props => [id, userId, saveName];
}
