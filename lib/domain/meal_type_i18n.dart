import 'enums.dart';

/// Localized meal-type words. Kept here (not in the ARB) because they're needed
/// both in widgets AND in the data layer — the auto-generated group name
/// ("Frühstück 08:23") is built in a Riverpod notifier that has no BuildContext,
/// so it can't reach `AppLocalizations`. English falls back to [MealTypeLabel].
///
/// The auto-name is localized at *creation* time and then stored as free text;
/// switching language later doesn't retro-translate existing meal names.

const Map<String, Map<MealType, String>> _titles = {
  'de': {
    MealType.breakfast: 'Frühstück',
    MealType.lunch: 'Mittagessen',
    MealType.dinner: 'Abendessen',
    MealType.snack: 'Snack',
  },
  'fr': {
    MealType.breakfast: 'Petit-déjeuner',
    MealType.lunch: 'Déjeuner',
    MealType.dinner: 'Dîner',
    MealType.snack: 'Collation',
  },
  'it': {
    MealType.breakfast: 'Colazione',
    MealType.lunch: 'Pranzo',
    MealType.dinner: 'Cena',
    MealType.snack: 'Spuntino',
  },
};

const Map<String, Map<MealType, String>> _labels = {
  'de': {
    MealType.breakfast: 'Frühstück',
    MealType.lunch: 'Mittagessen',
    MealType.dinner: 'Abendessen',
    MealType.snack: 'Snacks',
  },
  'fr': {
    MealType.breakfast: 'Petit-déjeuner',
    MealType.lunch: 'Déjeuner',
    MealType.dinner: 'Dîner',
    MealType.snack: 'Collations',
  },
  'it': {
    MealType.breakfast: 'Colazione',
    MealType.lunch: 'Pranzo',
    MealType.dinner: 'Cena',
    MealType.snack: 'Spuntini',
  },
};

/// Singular form, for naming a single meal ("Snack 14:02") and the meal-type
/// chips. Falls back to the canonical English [MealType.title].
String mealTypeTitle(MealType type, String? locale) =>
    _titles[locale]?[type] ?? type.title;

/// Plural/section form ("Snacks"), for the meal-times settings rows. Pass
/// `'en'` for stable serialization (CSV). Falls back to English [MealType.label].
String mealTypeLabel(MealType type, String? locale) =>
    _labels[locale]?[type] ?? type.label;
