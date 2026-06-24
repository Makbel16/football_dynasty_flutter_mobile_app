import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../services/finance_service.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/stat_card.dart';

class FinancesScreen extends ConsumerWidget {
  const FinancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final club = game.userClub;
    if (club == null) return const Scaffold(body: Center(child: Text('No data')));

    final records = FinanceService.instance.getSeasonReport(
      game.finances,
      club.id,
      game.season,
    );

    final totalRevenue = FinanceService.instance.getTotalRevenue(records);
    final totalExpenses = FinanceService.instance.getTotalExpenses(records);
    final netBalance = totalRevenue - totalExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Club Finances')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.6,
              children: [
                StatCard(
                  title: 'Current Budget',
                  value: Formatters.currency(club.budget),
                  icon: Icons.account_balance_wallet,
                  color: AppTheme.accentGold,
                ),
                StatCard(
                  title: 'Net Balance',
                  value: Formatters.currency(netBalance),
                  icon: Icons.trending_up,
                  color: netBalance >= 0 ? AppTheme.successGreen : AppTheme.dangerRed,
                ),
                StatCard(
                  title: 'Total Revenue',
                  value: Formatters.currency(totalRevenue),
                  icon: Icons.arrow_downward,
                  color: AppTheme.successGreen,
                ),
                StatCard(
                  title: 'Total Expenses',
                  value: Formatters.currency(totalExpenses),
                  icon: Icons.arrow_upward,
                  color: AppTheme.dangerRed,
                ),
              ],
            ),

            if (records.isNotEmpty) ...[
              const SectionHeader(title: 'Revenue Trend'),
              SizedBox(
                height: 200,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          getDrawingHorizontalLine: (v) => FlLine(
                            color: AppTheme.textSecondary.withValues(alpha: 0.1),
                          ),
                        ),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: records.asMap().entries.map((e) {
                              return FlSpot(
                                e.key.toDouble(),
                                e.value.totalIncome,
                              );
                            }).toList(),
                            isCurved: true,
                            color: AppTheme.accentGold,
                            barWidth: 3,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.accentGold.withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            const SectionHeader(title: 'Income Breakdown'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _FinanceRow('Ticket Revenue', records.fold(0.0, (s, r) => s + r.ticketRevenue)),
                    _FinanceRow('Sponsorship', records.fold(0.0, (s, r) => s + r.sponsorship)),
                    _FinanceRow('Prize Money', records.fold(0.0, (s, r) => s + r.prizeMoney)),
                    _FinanceRow('Transfer Income', records.fold(0.0, (s, r) => s + r.transferOut)),
                  ],
                ),
              ),
            ),

            const SectionHeader(title: 'Expense Breakdown'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _FinanceRow('Player Salaries', records.fold(0.0, (s, r) => s + r.playerSalaries)),
                    _FinanceRow('Transfer Fees', records.fold(0.0, (s, r) => s + r.transferIn)),
                    _FinanceRow('Facility Costs', records.fold(0.0, (s, r) => s + r.facilityCosts)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  const _FinanceRow(this.label, this.amount);
  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            Formatters.currency(amount),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
