import 'package:equatable/equatable.dart';

class FinancialRecord extends Equatable {
  const FinancialRecord({
    required this.id,
    required this.clubId,
    required this.season,
    required this.week,
    this.ticketRevenue = 0,
    this.sponsorship = 0,
    this.prizeMoney = 0,
    this.playerSalaries = 0,
    this.transferIn = 0,
    this.transferOut = 0,
    this.facilityCosts = 0,
    this.otherIncome = 0,
    this.otherExpenses = 0,
  });

  final String id;
  final String clubId;
  final int season;
  final int week;
  final double ticketRevenue;
  final double sponsorship;
  final double prizeMoney;
  final double playerSalaries;
  final double transferIn;
  final double transferOut;
  final double facilityCosts;
  final double otherIncome;
  final double otherExpenses;

  double get totalIncome =>
      ticketRevenue + sponsorship + prizeMoney + transferOut + otherIncome;

  double get totalExpenses =>
      playerSalaries + transferIn + facilityCosts + otherExpenses;

  double get netBalance => totalIncome - totalExpenses;

  FinancialRecord copyWith({
    String? id,
    String? clubId,
    int? season,
    int? week,
    double? ticketRevenue,
    double? sponsorship,
    double? prizeMoney,
    double? playerSalaries,
    double? transferIn,
    double? transferOut,
    double? facilityCosts,
    double? otherIncome,
    double? otherExpenses,
  }) {
    return FinancialRecord(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      season: season ?? this.season,
      week: week ?? this.week,
      ticketRevenue: ticketRevenue ?? this.ticketRevenue,
      sponsorship: sponsorship ?? this.sponsorship,
      prizeMoney: prizeMoney ?? this.prizeMoney,
      playerSalaries: playerSalaries ?? this.playerSalaries,
      transferIn: transferIn ?? this.transferIn,
      transferOut: transferOut ?? this.transferOut,
      facilityCosts: facilityCosts ?? this.facilityCosts,
      otherIncome: otherIncome ?? this.otherIncome,
      otherExpenses: otherExpenses ?? this.otherExpenses,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'clubId': clubId,
        'season': season,
        'week': week,
        'ticketRevenue': ticketRevenue,
        'sponsorship': sponsorship,
        'prizeMoney': prizeMoney,
        'playerSalaries': playerSalaries,
        'transferIn': transferIn,
        'transferOut': transferOut,
        'facilityCosts': facilityCosts,
        'otherIncome': otherIncome,
        'otherExpenses': otherExpenses,
      };

  factory FinancialRecord.fromMap(Map<String, dynamic> map) => FinancialRecord(
        id: map['id'] as String,
        clubId: map['clubId'] as String,
        season: map['season'] as int,
        week: map['week'] as int,
        ticketRevenue: (map['ticketRevenue'] as num?)?.toDouble() ?? 0,
        sponsorship: (map['sponsorship'] as num?)?.toDouble() ?? 0,
        prizeMoney: (map['prizeMoney'] as num?)?.toDouble() ?? 0,
        playerSalaries: (map['playerSalaries'] as num?)?.toDouble() ?? 0,
        transferIn: (map['transferIn'] as num?)?.toDouble() ?? 0,
        transferOut: (map['transferOut'] as num?)?.toDouble() ?? 0,
        facilityCosts: (map['facilityCosts'] as num?)?.toDouble() ?? 0,
        otherIncome: (map['otherIncome'] as num?)?.toDouble() ?? 0,
        otherExpenses: (map['otherExpenses'] as num?)?.toDouble() ?? 0,
      );

  @override
  List<Object?> get props => [id, clubId, season, week];
}
