import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class Achievement extends Equatable {
  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.unlockedAt,
    this.clubId,
  });

  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final DateTime? unlockedAt;
  final String? clubId;

  bool get isUnlocked => unlockedAt != null;

  Achievement copyWith({
    String? id,
    AchievementType? type,
    String? title,
    String? description,
    DateTime? unlockedAt,
    String? clubId,
  }) {
    return Achievement(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      clubId: clubId ?? this.clubId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.name,
        'title': title,
        'description': description,
        'unlockedAt': unlockedAt?.toIso8601String(),
        'clubId': clubId,
      };

  factory Achievement.fromMap(Map<String, dynamic> map) => Achievement(
        id: map['id'] as String,
        type: AchievementType.values.byName(map['type'] as String),
        title: map['title'] as String,
        description: map['description'] as String,
        unlockedAt: map['unlockedAt'] != null
            ? DateTime.parse(map['unlockedAt'] as String)
            : null,
        clubId: map['clubId'] as String?,
      );

  @override
  List<Object?> get props => [id, type, unlockedAt];
}
