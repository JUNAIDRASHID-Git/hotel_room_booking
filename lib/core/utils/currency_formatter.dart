import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  static final NumberFormat _inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String formatINR(num amount) {
    return _inrFormat.format(amount);
  }
}
