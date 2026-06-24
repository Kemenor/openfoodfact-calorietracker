import 'package:intl/intl.dart';

/// Day-key helpers. A "day" in this app is a local calendar day encoded as
/// 'YYYY-MM-DD' (used as the diary partition key).
class DayKey {
  static final DateFormat _fmt = DateFormat('yyyy-MM-dd');

  /// 'YYYY-MM-DD' for the given date (local).
  static String of(DateTime date) => _fmt.format(date);

  static String today() => of(DateTime.now());

  static DateTime parse(String key) => _fmt.parseStrict(key);

  /// Shift a day-key by [days] (can be negative).
  static String shift(String key, int days) =>
      of(parse(key).add(Duration(days: days)));

  /// Monday-first weekday index: Monday = 0 … Sunday = 6.
  static int weekdayIndex(String key) => parse(key).weekday - 1;
}
