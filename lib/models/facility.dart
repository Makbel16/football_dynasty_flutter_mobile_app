import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class Facility extends Equatable {
  const Facility({
    required this.clubId,
    required this.type,
    this.level = 1,
    this.maxLevel = 5,
  });

  final String clubId;
  final FacilityType type;
  final int level;
  final int maxLevel;

  double get upgradeCost => switch (type) {
        FacilityType.stadium => 2000000.0 * level,
        FacilityType.trainingGround => 500000.0 * level,
        FacilityType.medicalCenter => 300000.0 * level,
        FacilityType.youthFacilities => 400000.0 * level,
      };

  double get bonus => level * 0.05;

  String get label => switch (type) {
        FacilityType.stadium => 'Stadium Capacity',
        FacilityType.trainingGround => 'Training Ground',
        FacilityType.medicalCenter => 'Medical Center',
        FacilityType.youthFacilities => 'Youth Facilities',
      };

  Facility copyWith({
    String? clubId,
    FacilityType? type,
    int? level,
    int? maxLevel,
  }) {
    return Facility(
      clubId: clubId ?? this.clubId,
      type: type ?? this.type,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
    );
  }

  Map<String, dynamic> toMap() => {
        'clubId': clubId,
        'type': type.name,
        'level': level,
        'maxLevel': maxLevel,
      };

  factory Facility.fromMap(Map<String, dynamic> map) => Facility(
        clubId: map['clubId'] as String,
        type: FacilityType.values.byName(map['type'] as String),
        level: map['level'] as int? ?? 1,
        maxLevel: map['maxLevel'] as int? ?? 5,
      );

  @override
  List<Object?> get props => [clubId, type, level];
}
