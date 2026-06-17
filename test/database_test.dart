import 'package:calorie_tracker/data/db/database.dart';
import 'package:calorie_tracker/domain/enums.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('seeds 7 weekday targets on create, all null', () async {
    final t = await db.allTargets();
    expect(t.length, 7);
    expect(t.every((x) => x.kcal == null), isTrue);
  });

  test('upsertFood dedups on (source, externalId)', () async {
    final id1 = await db.upsertFood(FoodsCompanion.insert(
      source: FoodSource.openFoodFacts,
      externalId: const Value('123'),
      name: 'Cola',
      kcal100: 42,
    ));
    final id2 = await db.upsertFood(FoodsCompanion.insert(
      source: FoodSource.openFoodFacts,
      externalId: const Value('123'),
      name: 'Cola Updated',
      kcal100: 43,
    ));
    expect(id1, id2);
    final found = await db.searchFoodsLocal('Cola');
    expect(found.length, 1);
    expect(found.first.name, 'Cola Updated');
    expect(found.first.kcal100, 43);
  });

  test('custom foods with null externalId stay distinct', () async {
    await db.upsertFood(FoodsCompanion.insert(
        source: FoodSource.custom, name: 'Granny Apple', kcal100: 52));
    await db.upsertFood(FoodsCompanion.insert(
        source: FoodSource.custom, name: 'Granny Pear', kcal100: 57));
    final found = await db.searchFoodsLocal('Granny');
    expect(found.length, 2);
  });

  test('tokenized search matches USDA formal names via synonyms', () async {
    await db.upsertFood(FoodsCompanion.insert(
        source: FoodSource.usda,
        externalId: const Value('p1'),
        name: 'Peppers, sweet, green, raw',
        kcal100: 20));
    await db.upsertFood(FoodsCompanion.insert(
        source: FoodSource.usda,
        externalId: const Value('c1'),
        name: 'Candies, milk chocolate',
        kcal100: 535));
    final r = await db.searchFoodsLocal('bell pepper');
    expect(r.map((f) => f.name), contains('Peppers, sweet, green, raw'));
    expect(r.map((f) => f.name), isNot(contains('Candies, milk chocolate')));
  });

  test('ranks simpler/shorter names first', () async {
    await db.upsertFood(FoodsCompanion.insert(
        source: FoodSource.usda,
        externalId: const Value('a'),
        name: 'Potatoes, au gratin, dry mix, prepared with water and milk',
        kcal100: 93));
    await db.upsertFood(FoodsCompanion.insert(
        source: FoodSource.usda,
        externalId: const Value('b'),
        name: 'Potatoes, raw',
        kcal100: 77));
    final r = await db.searchFoodsLocal('potatoes');
    expect(r.first.name, 'Potatoes, raw');
  });

  test('watchDay reflects added entries', () async {
    const day = '2026-06-17';
    await db.addEntry(EntriesCompanion.insert(
      day: day,
      mealType: MealType.breakfast,
      grams: 100,
      sName: 'Egg',
      sKcal100: 155,
    ));
    final entries = await db.watchDay(day).first;
    expect(entries.length, 1);
    expect(entries.first.sName, 'Egg');
  });

  test('settings round-trip', () async {
    await db.setSetting('unit', 'kcal');
    expect(await db.getSetting('unit'), 'kcal');
    await db.setSetting('unit', 'kJ');
    expect(await db.getSetting('unit'), 'kJ');
  });

  test('target update persists', () async {
    await db.setTarget(0, const TargetsCompanion(kcal: Value(2200)));
    final t = await db.targetForWeekday(0);
    expect(t!.kcal, 2200);
  });

  test('recipe with items round-trips and cascades on delete', () async {
    final id = await db.createRecipe(
      RecipesCompanion.insert(name: 'Porridge'),
      [
        RecipeItemsCompanion.insert(
            recipeId: 0, sName: 'Oats', grams: 50, sKcal100: 389),
        RecipeItemsCompanion.insert(
            recipeId: 0, sName: 'Milk', grams: 200, sKcal100: 64),
      ],
    );
    final items = await db.itemsForRecipe(id);
    expect(items.length, 2);
    await db.deleteRecipe(id);
    expect(await db.itemsForRecipe(id), isEmpty);
  });
}
