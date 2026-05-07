import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
    ).format(amount);
  }
}