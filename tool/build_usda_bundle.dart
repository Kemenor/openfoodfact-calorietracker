// Dev-time pipeline: build the bundled USDA produce dataset.
//
// Downloads the public-domain USDA FoodData Central *SR Legacy* and *Foundation
// Foods* JSON datasets, extracts per-100g energy + macros (+ a few micros) for
// every food that has calories, and writes a compact gzipped CSV to
// assets/usda_foods.csv.gz which the app imports into its local catalog on
// first launch. No runtime API key, fully offline.
//
// Run from the repo root:  dart run tool/build_usda_bundle.dart
//
// (The big Branded Foods dataset is intentionally excluded — Open Food Facts
// already covers packaged/barcoded products.)

import 'dart:convert';
import 'dart:io';

// www.usda.gov's CDN is flaky for these; fdc.nal.usda.gov serves them reliably.
const _base = 'https://fdc.nal.usda.gov/fdc-datasets/';
const _ua = 'Mozilla/5.0 (X11; Linux x86_64)';

const _datasets = <Map<String, String>>[
  {'key': 'SRLegacyFoods', 'file': 'FoodData_Central_sr_legacy_food_json_2018-04'},
  {'key': 'FoundationFoods', 'file': 'FoodData_Central_foundation_food_json_2026-04-30'},
];

// USDA nutrient ids (per 100 g).
const _energyIds = [1008, 2047, 2048]; // kcal, Atwater general, Atwater specific
const _idProtein = 1003;
const _idFat = 1004;
const _idCarb = 1005;
const _idFiber = 1079;
const _idSugars = 2000;
const _idSodiumMg = 1093;

String _csv(Object? v) {
  final s = (v ?? '').toString();
  if (s.contains(',') || s.contains('"') || s.contains('\n')) {
    return '"${s.replaceAll('"', '""')}"';
  }
  return s;
}

String _numOrEmpty(double? v) => v == null ? '' : v.toStringAsFixed(2);

Future<void> main() async {
  final tmp = Directory.systemTemp.createTempSync('usda_bundle');
  final seen = <int>{};
  final rows = <String>[
    'fdc_id,name,kcal100,protein100,carb100,fat100,fiber100,sugar100,sodium_mg100',
  ];

  for (final ds in _datasets) {
    final file = ds['file']!;
    final url = '$_base$file.zip';
    final zipPath = '${tmp.path}/$file.zip';
    final outDir = '${tmp.path}/$file';

    stdout.writeln('↓ Downloading $file.zip …');
    final dl = await Process.run('curl',
        ['-fSL', '--http1.1', '-A', _ua, '--retry', '3', '-o', zipPath, url]);
    if (dl.exitCode != 0) {
      stderr.writeln('Download failed: ${dl.stderr}');
      exit(1);
    }
    stdout.writeln('  unzip …');
    await Process.run('unzip', ['-o', '-q', zipPath, '-d', outDir]);

    final jsonFile = Directory(outDir)
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere((f) => f.path.toLowerCase().endsWith('.json'));
    stdout.writeln('  parsing ${jsonFile.uri.pathSegments.last} …');

    final data = jsonDecode(await jsonFile.readAsString()) as Map<String, dynamic>;
    final foods = (data[ds['key']] as List?) ?? const [];

    var added = 0;
    for (final f in foods) {
      if (f is! Map<String, dynamic>) continue;
      final nutrients = <int, double>{};
      for (final fn in (f['foodNutrients'] as List? ?? const [])) {
        if (fn is! Map) continue;
        final nut = fn['nutrient'];
        final id = nut is Map ? nut['id'] : null;
        final amount = fn['amount'];
        if (id is int && amount is num) nutrients[id] = amount.toDouble();
      }
      double? energy;
      for (final id in _energyIds) {
        if (nutrients[id] != null) {
          energy = nutrients[id];
          break;
        }
      }
      if (energy == null || energy <= 0) continue;

      final fdcId = f['fdcId'];
      if (fdcId is! int || !seen.add(fdcId)) continue;
      final name = (f['description'] ?? '').toString().trim();
      if (name.isEmpty) continue;

      rows.add([
        fdcId,
        _csv(name),
        energy.toStringAsFixed(2),
        _numOrEmpty(nutrients[_idProtein]),
        _numOrEmpty(nutrients[_idCarb]),
        _numOrEmpty(nutrients[_idFat]),
        _numOrEmpty(nutrients[_idFiber]),
        _numOrEmpty(nutrients[_idSugars]),
        _numOrEmpty(nutrients[_idSodiumMg]),
      ].join(','));
      added++;
    }
    stdout.writeln('  + $added foods');
  }

  final csv = rows.join('\n');
  final gz = gzip.encode(utf8.encode(csv));
  final outFile = File('assets/usda_foods.csv.gz');
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(gz);

  stdout.writeln('✓ ${rows.length - 1} foods → assets/usda_foods.csv.gz '
      '(${(gz.length / 1024).toStringAsFixed(0)} KB gzipped, '
      '${(csv.length / 1024).toStringAsFixed(0)} KB raw)');
  tmp.deleteSync(recursive: true);
}
