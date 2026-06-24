import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class BoardObjective extends Equatable {
  const BoardObjective({
    required this.id,
    required this.clubId,
    required this.type,
    required this.description,
    required this.targetValue,
    this.currentValue = 0,
    this.season,
    this.isCompleted = false,
  });

  final String id;
  final String clubId;
  final BoardObjectiveType type;
  final String description;
  final int targetValue;
  final int currentValue;
  final int? season;
  final bool isCompleted;

  double get progress =>
      targetValue == 0 ? 0 : (currentValue / targetValue).clamp(0.0, 1.0);

  BoardObjective copyWith({
    String? id,
    String? clubId,
    BoardObjectiveType? type,
    String? description,
    int? targetValue,
    int? currentValue,
    int? season,
    bool? isCompleted,
  }) {
    return BoardObjective(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      type: type ?? this.type,
      description: description ?? this.description,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      season: season ?? this.season,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'clubId': clubId,
        'type': type.name,
        'description': description,
        'targetValue': targetValue,
        'currentValue': currentValue,
        'season': season,
        'isCompleted': isCompleted ? 1 : 0,
      };

  factory BoardObjective.fromMap(Map<String, dynamic> map) => BoardObjective(
        id: map['id'] as String,
        clubId: map['clubId'] as String,
        type: BoardObjectiveType.values.byName(map['type'] as String),
        description: map['description'] as String,
        targetValue: map['targetValue'] as int,
        currentValue: map['currentValue'] as int? ?? 0,
        season: map['season'] as int?,
        isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
      );

  @override
  List<Object?> get props => [id, clubId, type];
}
