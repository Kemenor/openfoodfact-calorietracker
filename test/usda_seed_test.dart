import 'dart:convert';
import 'dart:io' show gzip;

import 'package:calorie_tracker/data/db/database.dart';
import 'package:calorie_tracker/data/sources/usda_seed.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _sampleCsv =
    'fdc_id,name,kcal100,protein100,carb100,fat100,fiber100,sugar100,sodium_mg100\n'
    '171688,"Apple, raw, with skin",52,0.26,13.81,0.17,2.4,10.39,1\n'
    '173410,"Chicken, broiler, breast, raw",120,22.5,0,2.62,,,45\n'
    '99999,"No energy food",,1,1,1,,,';

class _FakeBundle extends CachingAssetBundle {
  final Uint8List bytes;
  _FakeBundle(this.bytes);

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(bytes);
}

void main() {
  group('parseCsv', () {
    test('handles quoted fields with embedded commas', () {
      final rows = parseCsv('a,b\n1,"x, y"');
      expect(rows.length, 2);
      expect(rows[1], ['1', 'x, y']);
    });

    test('handles doubled quotes', () {
      final rows = parseCsv('a\n"he said ""hi"""');
      expect(rows[1].first, 'he said "hi"');
    });
  });

  group('parseUsdaCsv', () {
    test('maps rows, keeps null macros, drops rows without energy', () {
      final foods = parseUsdaCsv(_sampleCsv);
      expect(foods.length, 2); // the "No energy food" is dropped
      final apple = foods.first;
      expect(apple.name.value, 'Apple, raw, with skin');
      expect(apple.kcal100.value, 52);
      expect(apple.protein100.value, 0.26);
      final chicken = foods[1];
      expect(chicken.fiber100.value, isNull); // empty -> null
    });
  });

  group('seedUsdaIfNeeded', () {
    test('imports the gzipped CSV once, idempotent', () async {
      final gz = Uint8List.fromList(gzip.encode(utf8.encode(_sampleCsv)));
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final n = await seedUsdaIfNeeded(db, bundle: _FakeBundle(gz));
      expect(n, 2);

      final found = await db.searchFoodsLocal('Apple');
      expect(found.length, 1);
      expect(found.first.name, 'Apple, raw, with skin');

      // second call is a no-op
      final n2 = await seedUsdaIfNeeded(db, bundle: _FakeBundle(gz));
      expect(n2, 0);
    });
  });
}
