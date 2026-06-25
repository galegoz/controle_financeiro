import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final DateFormat _monthYearFormatter = DateFormat('MMM/yyyy', 'pt_BR');
  static final DateFormat _monthFormatter = DateFormat('MMMM', 'pt_BR');
  static final DateFormat _fullDateFormatter = DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR');

  static String formatCurrency(double value) {
    return _currencyFormatter.format(value);
  }

  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  static String formatMonth(DateTime date) {
    return _monthFormatter.format(date);
  }

  static String formatFullDate(DateTime date) {
    return _fullDateFormatter.format(date);
  }

  static double parseCurrency(String value) {
    final cleaned = value
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
