import 'package:uuid/uuid.dart';
import '../../models/club.dart';
import '../../models/financial_record.dart';

class FinanceService {
  FinanceService._();
  static final FinanceService instance = FinanceService._();
  static const _uuid = Uuid();

  FinancialRecord generateWeeklyRecord({
    required Club club,
    required int season,
    required int week,
    required double totalSalaries,
    double facilityCosts = 0,
    bool isHomeMatch = false,
  }) {
    final attendance = isHomeMatch
        ? (club.stadiumCapacity * 0.7 * (club.fanHappiness / 100)).round()
        : 0;
    final ticketPrice = 45.0;
    final ticketRevenue = attendance * ticketPrice;
    final sponsorship = club.reputation * 5000.0;

    return FinancialRecord(
      id: _uuid.v4(),
      clubId: club.id,
      season: season,
      week: week,
      ticketRevenue: ticketRevenue,
      sponsorship: sponsorship / 52,
      playerSalaries: totalSalaries,
      facilityCosts: facilityCosts,
    );
  }

  Club applyFinancials(Club club, FinancialRecord record) {
    return club.copyWith(
      budget: club.budget + record.netBalance,
      clubValue: club.clubValue + record.netBalance * 0.1,
    );
  }

  double calculateTotalSalaries(List<double> salaries) =>
      salaries.fold(0.0, (sum, s) => sum + s);

  List<FinancialRecord> getSeasonReport(
    List<FinancialRecord> records,
    String clubId,
    int season,
  ) {
    return records
        .where((r) => r.clubId == clubId && r.season == season)
        .toList()
      ..sort((a, b) => a.week.compareTo(b.week));
  }

  double getTotalRevenue(List<FinancialRecord> records) =>
      records.fold(0.0, (sum, r) => sum + r.totalIncome);

  double getTotalExpenses(List<FinancialRecord> records) =>
      records.fold(0.0, (sum, r) => sum + r.totalExpenses);
}
