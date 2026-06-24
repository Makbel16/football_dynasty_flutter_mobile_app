import 'package:equatable/equatable.dart';
import 'enums/player_position.dart';

class Player extends Equatable {
  const Player({
    required this.id,
    required this.name,
    required this.age,
    required this.nationality,
    required this.position,
    required this.overall,
    required this.potential,
    required this.pace,
    required this.shooting,
    required this.passing,
    required this.dribbling,
    required this.defending,
    required this.physical,
    required this.clubId,
    this.morale = 75,
    this.fitness = 100,
    this.contractYears = 3,
    this.marketValue = 1000000,
    this.salary = 10000,
    this.form = 50,
    this.isYouth = false,
    this.isOnLoan = false,
    this.loanFromClubId,
  });

  final String id;
  final String name;
  final int age;
  final String nationality;
  final PlayerPosition position;
  final int overall;
  final int potential;
  final int pace;
  final int shooting;
  final int passing;
  final int dribbling;
  final int defending;
  final int physical;
  final String clubId;
  final double morale;
  final double fitness;
  final int contractYears;
  final double marketValue;
  final double salary;
  final double form;
  final bool isYouth;
  final bool isOnLoan;
  final String? loanFromClubId;

  double get attributeAverage =>
      (pace + shooting + passing + dribbling + defending + physical) / 6;

  Player copyWith({
    String? id,
    String? name,
    int? age,
    String? nationality,
    PlayerPosition? position,
    int? overall,
    int? potential,
    int? pace,
    int? shooting,
    int? passing,
    int? dribbling,
    int? defending,
    int? physical,
    String? clubId,
    double? morale,
    double? fitness,
    int? contractYears,
    double? marketValue,
    double? salary,
    double? form,
    bool? isYouth,
    bool? isOnLoan,
    String? loanFromClubId,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      nationality: nationality ?? this.nationality,
      position: position ?? this.position,
      overall: overall ?? this.overall,
      potential: potential ?? this.potential,
      pace: pace ?? this.pace,
      shooting: shooting ?? this.shooting,
      passing: passing ?? this.passing,
      dribbling: dribbling ?? this.dribbling,
      defending: defending ?? this.defending,
      physical: physical ?? this.physical,
      clubId: clubId ?? this.clubId,
      morale: morale ?? this.morale,
      fitness: fitness ?? this.fitness,
      contractYears: contractYears ?? this.contractYears,
      marketValue: marketValue ?? this.marketValue,
      salary: salary ?? this.salary,
      form: form ?? this.form,
      isYouth: isYouth ?? this.isYouth,
      isOnLoan: isOnLoan ?? this.isOnLoan,
      loanFromClubId: loanFromClubId ?? this.loanFromClubId,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'nationality': nationality,
        'position': position.code,
        'overall': overall,
        'potential': potential,
        'pace': pace,
        'shooting': shooting,
        'passing': passing,
        'dribbling': dribbling,
        'defending': defending,
        'physical': physical,
        'clubId': clubId,
        'morale': morale,
        'fitness': fitness,
        'contractYears': contractYears,
        'marketValue': marketValue,
        'salary': salary,
        'form': form,
        'isYouth': isYouth ? 1 : 0,
        'isOnLoan': isOnLoan ? 1 : 0,
        'loanFromClubId': loanFromClubId,
      };

  factory Player.fromMap(Map<String, dynamic> map) => Player(
        id: map['id'] as String,
        name: map['name'] as String,
        age: map['age'] as int,
        nationality: map['nationality'] as String,
        position: PlayerPosition.fromCode(map['position'] as String),
        overall: map['overall'] as int,
        potential: map['potential'] as int,
        pace: map['pace'] as int,
        shooting: map['shooting'] as int,
        passing: map['passing'] as int,
        dribbling: map['dribbling'] as int,
        defending: map['defending'] as int,
        physical: map['physical'] as int,
        clubId: map['clubId'] as String,
        morale: (map['morale'] as num).toDouble(),
        fitness: (map['fitness'] as num).toDouble(),
        contractYears: map['contractYears'] as int,
        marketValue: (map['marketValue'] as num).toDouble(),
        salary: (map['salary'] as num).toDouble(),
        form: (map['form'] as num?)?.toDouble() ?? 50,
        isYouth: (map['isYouth'] as int? ?? 0) == 1,
        isOnLoan: (map['isOnLoan'] as int? ?? 0) == 1,
        loanFromClubId: map['loanFromClubId'] as String?,
      );

  @override
  List<Object?> get props => [id, name, clubId, overall];
}
