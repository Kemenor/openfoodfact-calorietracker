import 'package:calorie_tracker/domain/enums.dart';
import 'package:calorie_tracker/domain/meal_type_i18n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('localized meal-type titles (singular, used in auto-names)', () {
    expect(mealTypeTitle(MealType.breakfast, 'de'), 'Frühstück');
    expect(mealTypeTitle(MealType.lunch, 'fr'), 'Déjeuner');
    expect(mealTypeTitle(MealType.dinner, 'it'), 'Cena');
    expect(mealTypeTitle(MealType.snack, 'de'), 'Snack');
  });

  test('falls back to canonical English for en / unknown / null', () {
    expect(mealTypeTitle(MealType.breakfast, 'en'), 'Breakfast');
    expect(mealTypeTitle(MealType.lunch, 'es'), 'Lunch');
    expect(mealTypeTitle(MealType.dinner, null), 'Dinner');
  });

  test('labels (plural) localize, with stable English for serialization', () {
    expect(mealTypeLabel(MealType.snack, 'de'), 'Snacks');
    expect(mealTypeLabel(MealType.snack, 'it'), 'Spuntini');
    expect(mealTypeLabel(MealType.breakfast, 'en'), 'Breakfast');
  });
}
