import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Formatters {
  Formatters._();

  static final _currencyFormat = NumberFormat.compactCurrency(
    symbol: AppConstants.defaultCurrency,
    decimalDigits: 0,
  );

  static final _numberFormat = NumberFormat.compact();

  static String currency(double value) => _currencyFormat.format(value);

  static String number(num value) => _numberFormat.format(value);

  static String percentage(double value) => '${value.toStringAsFixed(0)}%';

  static String date(DateTime date) => DateFormat('dd MMM yyyy').format(date);
}
