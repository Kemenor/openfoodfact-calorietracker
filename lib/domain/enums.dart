/// Where a food record came from.
enum FoodSource {
  /// Fetched from the Open Food Facts live API (packaged / barcoded products).
  openFoodFacts,

  /// From the bundled USDA public-domain dataset (whole foods / produce).
  usda,

  /// Entered by the user.
  custom,
}

/// Meal a diary entry belongs to. Order matters: it's the display order.
enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  /// Monday-first weekday helper lives elsewhere; this is just a label key.
  String get labelKey => name;
}

extension MealTypeLabel on MealType {
  String get label => switch (this) {
        MealType.breakfast => 'Breakfast',
        MealType.lunch => 'Lunch',
        MealType.dinner => 'Dinner',
        MealType.snack => 'Snacks',
      };
}
