import 'package:intl/intl.dart';

abstract class DateFormatter {
  static final DateFormat _readableFormat = DateFormat('EEE, dd MMM yyyy');
  static final DateFormat _shortFormat = DateFormat('dd MMM yyyy');

  static String formatReadable(DateTime? date) {
    if (date == null) return 'Select Date';
    return _readableFormat.format(date);
  }

  static String formatShort(DateTime? date) {
    if (date == null) return '-';
    return _shortFormat.format(date);
  }
}
