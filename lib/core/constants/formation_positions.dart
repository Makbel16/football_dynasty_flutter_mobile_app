import '../../models/enums/player_position.dart';

class FormationPositions {
  FormationPositions._();

  static const Map<String, List<PlayerPosition>> formations = {
    '4-4-2': [
      PlayerPosition.gk,
      PlayerPosition.rb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.lb,
      PlayerPosition.rm,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.lm,
      PlayerPosition.st,
      PlayerPosition.st,
    ],
    '4-3-3': [
      PlayerPosition.gk,
      PlayerPosition.rb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.lb,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.rw,
      PlayerPosition.st,
      PlayerPosition.lw,
    ],
    '3-5-2': [
      PlayerPosition.gk,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.rwb,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.lwb,
      PlayerPosition.st,
      PlayerPosition.st,
    ],
    '5-3-2': [
      PlayerPosition.gk,
      PlayerPosition.rwb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.lwb,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.cm,
      PlayerPosition.st,
      PlayerPosition.st,
    ],
    '4-2-3-1': [
      PlayerPosition.gk,
      PlayerPosition.rb,
      PlayerPosition.cb,
      PlayerPosition.cb,
      PlayerPosition.lb,
      PlayerPosition.cdm,
      PlayerPosition.cdm,
      PlayerPosition.rw,
      PlayerPosition.cam,
      PlayerPosition.lw,
      PlayerPosition.st,
    ],
  };

  static List<String> get availableFormations => formations.keys.toList();
}
