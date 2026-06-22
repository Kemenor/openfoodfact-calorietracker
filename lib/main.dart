import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load date-symbol data so DateFormat can render de/fr/it month + weekday names.
  await initializeDateFormatting();
  runApp(const ProviderScope(child: CalorieApp()));
}
