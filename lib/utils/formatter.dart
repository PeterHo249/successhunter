import 'package:intl/intl.dart';

class Formatter {
  static String getDateString(DateTime date, {String pattern = 'dd-MM-yyyy'}) {
    var formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  static String getTimeString(DateTime time, {String pattern = 'HH:mm:ss'}) {
    var formatter = DateFormat(pattern);
    return formatter.format(time.toLocal());
  }
}