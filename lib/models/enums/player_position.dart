enum PlayerPosition {
  gk('GK', 'Goalkeeper'),
  cb('CB', 'Centre Back'),
  lb('LB', 'Left Back'),
  rb('RB', 'Right Back'),
  lwb('LWB', 'Left Wing Back'),
  rwb('RWB', 'Right Wing Back'),
  cdm('CDM', 'Defensive Midfielder'),
  cm('CM', 'Central Midfielder'),
  cam('CAM', 'Attacking Midfielder'),
  lm('LM', 'Left Midfielder'),
  rm('RM', 'Right Midfielder'),
  lw('LW', 'Left Winger'),
  rw('RW', 'Right Winger'),
  st('ST', 'Striker');

  const PlayerPosition(this.code, this.label);
  final String code;
  final String label;

  bool get isGoalkeeper => this == PlayerPosition.gk;
  bool get isDefender =>
      [cb, lb, rb, lwb, rwb].contains(this);
  bool get isMidfielder =>
      [cdm, cm, cam, lm, rm].contains(this);
  bool get isAttacker => [lw, rw, st].contains(this);

  static PlayerPosition fromCode(String code) =>
      PlayerPosition.values.firstWhere(
        (p) => p.code == code,
        orElse: () => PlayerPosition.cm,
      );
}
