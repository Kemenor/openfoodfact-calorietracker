// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Knabberfuchs';

  @override
  String get navDay => 'Day';

  @override
  String get navRecipes => 'Recipes';

  @override
  String get navSettings => 'Settings';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionImport => 'Import';

  @override
  String get settingsSectionLanguage => 'Language';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get dayPreviousDay => 'Previous day';

  @override
  String get dayNextDay => 'Next day';

  @override
  String get dayAddFood => 'Add food';

  @override
  String get dayMealFromList => 'Meal from an ingredient list';

  @override
  String get dayEmptyHint =>
      'Tap + to start a meal.\nEverything you add flows into it until you tap ✓ (or 15 min pass).';

  @override
  String get unitKcal => 'kcal';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Carbs';

  @override
  String get macroFat => 'Fat';

  @override
  String targetOver(String kcal) {
    return '$kcal over';
  }

  @override
  String targetToGo(String kcal) {
    return '$kcal to go';
  }

  @override
  String targetLeft(String kcal) {
    return '$kcal left';
  }

  @override
  String get targetMinReached => 'minimum reached';

  @override
  String targetRangeBoth(String min, String max) {
    return 'Target $min–$max kcal';
  }

  @override
  String targetRangeMax(String max) {
    return 'Target $max kcal';
  }

  @override
  String targetRangeMin(String min) {
    return 'Minimum $min kcal';
  }

  @override
  String get mealMenuEdit => 'Edit meal';

  @override
  String get mealMenuSplit => 'Split across days';

  @override
  String get mealMenuSaveRecipe => 'Save as recipe';

  @override
  String get mealMenuDelete => 'Delete meal';

  @override
  String get mealFinish => 'Finish meal';

  @override
  String get mealAddTo => 'Add to this meal';

  @override
  String mealSavedToRecipes(String name) {
    return 'Saved \"$name\" to recipes';
  }

  @override
  String get editMealTitle => 'Edit meal';

  @override
  String get editMealName => 'Name';

  @override
  String get editMealType => 'Meal type';

  @override
  String get editMealWhen => 'When';

  @override
  String get recipesTitle => 'Recipes';

  @override
  String get recipesEmpty =>
      'No recipes yet.\nCreate one to reuse meals, share them, or batch-cook and split across days.';

  @override
  String get recipeNew => 'New recipe';

  @override
  String recipeServings(String count) {
    return '$count servings';
  }

  @override
  String recipeImported(String name) {
    return 'Imported \"$name\"';
  }

  @override
  String get qrNotRecipe => 'That QR code is not a recipe.';

  @override
  String get createBuildManually => 'Build manually';

  @override
  String get createBuildManuallySub => 'Add ingredients one by one';

  @override
  String get createFromList => 'From an ingredient list';

  @override
  String get createFromListSub =>
      'Photograph a printed list — save it or log it as a meal';

  @override
  String get createFromQr => 'Import from QR code';

  @override
  String get createFromQrSub => 'Scan a shared recipe';
}
