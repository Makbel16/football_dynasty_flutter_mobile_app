import 'package:equatable/equatable.dart';
import 'enums/game_enums.dart';

class Tactics extends Equatable {
  const Tactics({
    required this.clubId,
    this.formation = '4-4-2',
    this.attackingStyle = AttackingStyle.balanced,
    this.defensiveStyle = DefensiveStyle.midBlock,
    this.pressing = PressingIntensity.medium,
    this.possession = 50,
    this.counterAttack = 50,
    this.width = 50,
    this.tempo = 50,
    this.startingXi = const [],
  });

  final String clubId;
  final String formation;
  final AttackingStyle attackingStyle;
  final DefensiveStyle defensiveStyle;
  final PressingIntensity pressing;
  final int possession;
  final int counterAttack;
  final int width;
  final int tempo;
  final List<String> startingXi;

  double get attackModifier {
    var mod = 1.0;
    switch (attackingStyle) {
      case AttackingStyle.possession:
        mod += 0.05;
      case AttackingStyle.direct:
        mod += 0.03;
      case AttackingStyle.counter:
        mod += counterAttack / 500;
      case AttackingStyle.balanced:
        break;
    }
    mod += tempo / 500;
    return mod;
  }

  double get defenseModifier {
    var mod = 1.0;
    switch (defensiveStyle) {
      case DefensiveStyle.lowBlock:
        mod += 0.08;
      case DefensiveStyle.midBlock:
        mod += 0.04;
      case DefensiveStyle.highPress:
        mod += pressing == PressingIntensity.high ? 0.06 : 0.02;
    }
    return mod;
  }

  Tactics copyWith({
    String? clubId,
    String? formation,
    AttackingStyle? attackingStyle,
    DefensiveStyle? defensiveStyle,
    PressingIntensity? pressing,
    int? possession,
    int? counterAttack,
    int? width,
    int? tempo,
    List<String>? startingXi,
  }) {
    return Tactics(
      clubId: clubId ?? this.clubId,
      formation: formation ?? this.formation,
      attackingStyle: attackingStyle ?? this.attackingStyle,
      defensiveStyle: defensiveStyle ?? this.defensiveStyle,
      pressing: pressing ?? this.pressing,
      possession: possession ?? this.possession,
      counterAttack: counterAttack ?? this.counterAttack,
      width: width ?? this.width,
      tempo: tempo ?? this.tempo,
      startingXi: startingXi ?? this.startingXi,
    );
  }

  Map<String, dynamic> toMap() => {
        'clubId': clubId,
        'formation': formation,
        'attackingStyle': attackingStyle.name,
        'defensiveStyle': defensiveStyle.name,
        'pressing': pressing.name,
        'possession': possession,
        'counterAttack': counterAttack,
        'width': width,
        'tempo': tempo,
        'startingXi': startingXi.join(','),
      };

  factory Tactics.fromMap(Map<String, dynamic> map) => Tactics(
        clubId: map['clubId'] as String,
        formation: map['formation'] as String? ?? '4-4-2',
        attackingStyle: AttackingStyle.values.byName(
          map['attackingStyle'] as String? ?? 'balanced',
        ),
        defensiveStyle: DefensiveStyle.values.byName(
          map['defensiveStyle'] as String? ?? 'midBlock',
        ),
        pressing: PressingIntensity.values.byName(
          map['pressing'] as String? ?? 'medium',
        ),
        possession: map['possession'] as int? ?? 50,
        counterAttack: map['counterAttack'] as int? ?? 50,
        width: map['width'] as int? ?? 50,
        tempo: map['tempo'] as int? ?? 50,
        startingXi: (map['startingXi'] as String?)?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      );

  @override
  List<Object?> get props => [clubId, formation];
}
