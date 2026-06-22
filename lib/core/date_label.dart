import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import 'date_x.dart';

/// Localized human label for a day-key: "Today"/"Yesterday"/"Tomorrow" (from the
/// ARB), else a locale-formatted date like "Mon, 17 Jun" / "Mo., 17. Juni".
/// Requires `initializeDateFormatting()` at startup for the non-English months.
String dayLabel(BuildContext context, String dayKey) {
  final l10n = AppLocalizations.of(context);
  final today = DayKey.today();
  if (dayKey == today) return l10n.dateToday;
  if (dayKey == DayKey.shift(today, -1)) return l10n.dateYesterday;
  if (dayKey == DayKey.shift(today, 1)) return l10n.dateTomorrow;
  final code = Localizations.localeOf(context).languageCode;
  return DateFormat('EEE, d MMM', code).format(DayKey.parse(dayKey));
}
