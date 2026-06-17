import 'dart:convert';
import 'dart:io' show gzip;

import 'package:drift/drift.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../domain/enums.dart';
import '../db/database.dart';

const _assetPath = 'assets/usda_foods.csv.gz';
const _versionKey = 'usdaDatasetVersion';

/// Bump whenever assets/usda_foods.csv.gz changes so existing installs re-import.
const usdaDatasetVersion = '2';

/// Minimal RFC-4180-ish CSV parser: handles quoted fields containing commas,
/// newlines, and doubled quotes. Good enough for our controlled asset.
List<List<String>> parseCsv(String input) {
  final rows = <List<String>>[];
  var field = StringBuffer();
  var row = <String>[];
  var inQuotes = false;
  var sawAny = false;

  for (var i = 0; i < input.length; i++) {
    final c = input[i];
    sawAny = true;
    if (inQuotes) {
      if (c == '"') {
        if (i + 1 < input.length && input[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(c);
      }
    } else {
      switch (c) {
        case '"':
          inQuotes = true;
        case ',':
          row.add(field.toString());
          field = StringBuffer();
        case '\n':
          row.add(field.toString());
          rows.add(row);
          row = <String>[];
          field = StringBuffer();
        case '\r':
          break; // ignore CR
        default:
          field.write(c);
      }
    }
  }
  if (sawAny && (field.isNotEmpty || row.isNotEmpty)) {
    row.add(field.toString());
    rows.add(row);
  }
  return rows;
}

/// Parse the bundled USDA CSV into catalog rows.
/// Columns: fdc_id,name,kcal100,protein100,carb100,fat100,fiber100,sugar100,sodium_mg100
List<FoodsCompanion> parseUsdaCsv(String csv) {
  final rows = parseCsv(csv);
  final out = <FoodsCompanion>[];
  for (var i = 1; i < rows.length; i++) {
    // skip header
    final r = rows[i];
    if (r.length < 9) continue;
    final kcal = double.tryParse(r[2]);
    if (kcal == null) continue;
    final name = r[1].trim();
    if (name.isEmpty) continue;
    double? n(String s) => s.trim().isEmpty ? null : double.tryParse(s);
    out.add(FoodsCompanion.insert(
      source: FoodSource.usda,
      externalId: Value(r[0]),
      name: name,
      kcal100: kcal,
      protein100: Value(n(r[3])),
      carb100: Value(n(r[4])),
      fat100: Value(n(r[5])),
      fiber100: Value(n(r[6])),
      sugar100: Value(n(r[7])),
      sodiumMg100: Value(n(r[8])),
    ));
  }
  return out;
}

/// Import the bundled USDA produce dataset into the local catalog. Runs on
/// first launch and again whenever [usdaDatasetVersion] changes (so cleaned/
/// updated bundles replace the old rows). Idempotent within a version.
/// Returns the number of rows imported (0 if up to date or asset missing).
Future<int> seedUsdaIfNeeded(AppDatabase db, {AssetBundle? bundle}) async {
  if (await db.getSetting(_versionKey) == usdaDatasetVersion) return 0;
  final b = bundle ?? rootBundle;
  try {
    final data = await b.load(_assetPath);
    final csv = utf8.decode(gzip.decode(data.buffer.asUint8List()));
    final companions = parseUsdaCsv(csv);
    await db.transaction(() async {
      // Replace any previously-seeded USDA rows (entries keep their snapshots;
      // the FK is set-null on delete).
      await (db.delete(db.foods)
            ..where((f) => f.source.equalsValue(FoodSource.usda)))
          .go();
      await db.batch((batch) {
        batch.insertAll(db.foods, companions, mode: InsertMode.insertOrIgnore);
      });
    });
    await db.setSetting(_versionKey, usdaDatasetVersion);
    return companions.length;
  } catch (_) {
    // No asset bundled (e.g. dev build before the pipeline ran) — skip quietly.
    return 0;
  }
}
